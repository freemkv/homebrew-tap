#!/usr/bin/env bash
# Rewrite this tap's formulae and casks for a published release.
#
#   ./update.sh 1.8.0                    # freemkv: freemkv-cli formula + freemkv cask
#   FMKV_REPO=freemkv/freemkv-firmware ./update.sh 0.10.1
#                                        # freemkv-flash, freemkv-fw + their -gui casks
#
# The repo (FMKV_REPO, default freemkv/freemkv) selects which files are
# rewritten: the firmware repo updates the four firmware files, anything else
# the freemkv app's two. autorip is retired and is never touched.
#
# Run by the freemkv and freemkv-firmware release workflows; safe to run by hand
# to repair a tap that drifted. It reads the checksums from the release ASSETS
# rather than taking them on trust, so a formula can never point at a version
# with a stale hash -- which would fail every install with a checksum mismatch
# and look like a compromised download.
#
# Downloads use `gh release download` (authenticated; what CI uses). To run by
# hand without touching the GitHub API, set FMKV_FETCH=curl: the assets are
# public, so the plain release-download URLs work too.
#
# freemkv asset names are unversioned from 1.8.0 on (only the tag carries the
# version), so this cannot rewrite the tap back to an older freemkv release.
set -euo pipefail

VER="${1:-}"
[ -n "$VER" ] || { echo "usage: update.sh X.Y.Z" >&2; exit 2; }
VER="${VER#v}"
REPO="${FMKV_REPO:-freemkv/freemkv}"
FETCH="${FMKV_FETCH:-gh}"
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TMP="$(mktemp -d)"
# NOTE: no `trap ... EXIT` to clean this up. An EXIT trap also fires when a
# COMMAND SUBSTITUTION subshell exits, so `x=$(fetch ...)` would delete the
# directory the moment the first fetch returned and every later one would fail
# with a missing-asset error that has nothing to do with the release. Cleaned up
# explicitly at the end instead.

# Download an asset and print its sha256. Hashing the bytes is deliberate: the
# published .sha256 sidecars are written by the same job that builds the asset,
# so trusting them would only check the build against itself.
fetch_sha() {
  local asset="$1" err
  if [ "$FETCH" = curl ]; then
    err=$(curl -fsSL --retry 3 -o "$TMP/$asset" \
            "https://github.com/$REPO/releases/download/v$VER/$asset" 2>&1) || {
      echo "::error::could not download release asset '$asset': $err" >&2
      exit 1
    }
  elif ! err=$(gh release download "v$VER" --repo "$REPO" \
                 -p "$asset" -O "$TMP/$asset" --clobber 2>&1); then
    echo "::error::could not download release asset '$asset': $err" >&2
    exit 1
  fi
  shasum -a 256 "$TMP/$asset" | cut -d' ' -f1
}

# Fail if a downloaded zip does not hold the path the cask installs from, so a
# repackaged release cannot leave the tap pointing at an archive the cask's
# `app`/`binary` stanzas would fail on.
require_in_zip() {
  local asset="$1" path="$2" list
  # Listed into a variable first: `unzip | grep -q` under pipefail fails when
  # grep exits early and unzip takes SIGPIPE.
  list=$(unzip -Z1 "$TMP/$asset")
  if ! grep -qxF "$path" <<<"$list"; then
    echo "::error::$asset does not contain $path" >&2
    exit 1
  fi
}

# Rewrite a cask's `version` and its arm/intel sha256 pair.
rewrite_cask() {
  python3 - "$1" "$VER" "$2" "$3" <<'PY'
import re, sys
path, ver, arm, x86 = sys.argv[1:5]
s = open(path).read()
s, n1 = re.subn(r'^  version "[^"]+"$', f'  version "{ver}"', s, flags=re.M)
s, n2 = re.subn(r'^  sha256 arm:\s+"[0-9a-f]{64}",$',
                f'  sha256 arm:   "{arm}",', s, flags=re.M)
s, n3 = re.subn(r'^(\s+)intel: "[0-9a-f]{64}"$',
                rf'\g<1>intel: "{x86}"', s, flags=re.M)
assert (n1, n2, n3) == (1, 1, 1), \
    f"{path}: matched version/arm/intel {n1}/{n2}/{n3} times, expected 1/1/1"
open(path, "w").write(s)
PY
}

# Rewrite a formula's url tags and the sha256 line directly after each url,
# matched by asset name rather than by position. The formulae have no `version`
# line: Homebrew scans it from the v<tag> in the URLs. Args: file, then
# asset=sha pairs -- every url in the file must be one of them.
rewrite_formula() {
  local f="$1"; shift
  python3 - "$f" "$VER" "$@" <<'PY'
import re, sys
path, ver, *pairs = sys.argv[1:]
shas = dict(p.split("=", 1) for p in pairs)
out, pending, done = [], None, set()
for line in open(path).read().split("\n"):
    m = re.match(r'^(\s*url ".*?/releases/download/)v[^/]+/([^"/]+)"$', line)
    if m:
        pending = m.group(2)
        assert pending in shas, f"{path}: unexpected asset in url: {pending}"
        line = f'{m.group(1)}v{ver}/{pending}"'
    else:
        m = re.match(r'^(\s*)sha256 "[0-9a-f]{64}"$', line)
        if m and pending:
            line = f'{m.group(1)}sha256 "{shas[pending]}"'
            done.add(pending)
            pending = None
    out.append(line)
assert done == set(shas), f"{path}: rewrote {sorted(done)}, expected {sorted(shas)}"
open(path, "w").write("\n".join(out))
PY
}

echo "reading v$VER assets from $REPO"

# ---- firmware repo: freemkv-flash / freemkv-fw (+ their -gui casks) ----------
# Both tools are released together from one repo and tag, under the stable
# <bin>-<os>-<arch>.{tar.gz,zip} names the firmware release workflow publishes.
if [ "${REPO##*/}" = "freemkv-firmware" ]; then
  for tool in flash fw; do
    bin="freemkv-$tool"
    pairs=()
    for a in "$bin-macos-aarch64.tar.gz" "$bin-macos-x86_64.tar.gz" \
             "$bin-linux-x86_64.tar.gz"; do
      pairs+=("$a=$(fetch_sha "$a")")
    done
    rewrite_formula "$SELF_DIR/Formula/$bin.rb" "${pairs[@]}"

    G_ARM=$(fetch_sha "$bin-gui-macos-aarch64.zip")
    G_X86=$(fetch_sha "$bin-gui-macos-x86_64.zip")
    for z in "$bin-gui-macos-aarch64.zip" "$bin-gui-macos-x86_64.zip"; do
      require_in_zip "$z" "$bin-gui.app/Contents/MacOS/$bin-gui"
    done
    rewrite_cask "$SELF_DIR/Casks/$bin-gui.rb" "$G_ARM" "$G_X86"
  done
  rm -rf "$TMP"
  echo "updated firmware tools to $VER"
  grep -n 'download/v\|^  version "' \
    "$SELF_DIR"/Formula/freemkv-{flash,fw}.rb "$SELF_DIR"/Casks/freemkv-{flash,fw}-gui.rb
  exit 0
fi

# ---- freemkv: freemkv-cli formula (bare CLI) + freemkv cask (app .zip) --------
pairs=()
for a in freemkv-cli-aarch64-macos freemkv-cli-x86_64-macos \
         freemkv-cli-aarch64-linux freemkv-cli-x86_64-linux; do
  pairs+=("$a=$(fetch_sha "$a")")
done
rewrite_formula "$SELF_DIR/Formula/freemkv-cli.rb" "${pairs[@]}"

# The app ships as a zipped, ad-hoc-signed freemkv.app -- never the .dmg (see
# Casks/freemkv.rb). The cask links the bundle's executable as `freemkv`.
APP_ARM=$(fetch_sha "freemkv-aarch64-macos.zip")
APP_X86=$(fetch_sha "freemkv-x86_64-macos.zip")
for z in freemkv-aarch64-macos.zip freemkv-x86_64-macos.zip; do
  require_in_zip "$z" "freemkv.app/Contents/MacOS/freemkv"
done
rewrite_cask "$SELF_DIR/Casks/freemkv.rb" "$APP_ARM" "$APP_X86"

rm -rf "$TMP"
echo "updated freemkv to $VER"
grep -n 'download/v\|^  version "' "$SELF_DIR/Formula/freemkv-cli.rb" "$SELF_DIR/Casks/freemkv.rb"
