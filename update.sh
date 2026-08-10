#!/usr/bin/env bash
# Rewrite the formula and cask for a published freemkv release.
#
#   ./update.sh 1.6.3
#
# Run by the freemkv release workflow; safe to run by hand to repair a tap that
# drifted. It reads the checksums from the release ASSETS rather than taking
# them on trust, so a formula can never point at a version with a stale hash --
# which would fail every install with a checksum mismatch and look like a
# compromised download.
set -euo pipefail

VER="${1:-}"
[ -n "$VER" ] || { echo "usage: update.sh X.Y.Z" >&2; exit 2; }
VER="${VER#v}"
REPO="${FMKV_REPO:-freemkv/freemkv}"
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
  if ! err=$(gh release download "v$VER" --repo "$REPO" \
               -p "$asset" -O "$TMP/$asset" --clobber 2>&1); then
    echo "::error::could not download release asset '$asset': $err" >&2
    exit 1
  fi
  shasum -a 256 "$TMP/$asset" | cut -d' ' -f1
}

echo "reading v$VER assets from $REPO"
CLI_MAC_ARM=$(fetch_sha "freemkv-aarch64-macos-v$VER")
CLI_MAC_X86=$(fetch_sha "freemkv-x86_64-macos-v$VER")
CLI_LNX_ARM=$(fetch_sha "freemkv-aarch64-linux-v$VER")
CLI_LNX_X86=$(fetch_sha "freemkv-x86_64-linux-v$VER")
DMG_ARM=$(fetch_sha "freemkv-v$VER-aarch64-apple-darwin.dmg")
DMG_X86=$(fetch_sha "freemkv-v$VER-x86_64-apple-darwin.dmg")

# Rewrite in place. Each substitution is anchored to the line it belongs to, so
# a version string appearing in prose or a comment is untouched.
F="$SELF_DIR/Formula/freemkv.rb"
python3 - "$F" "$VER" \
  "$CLI_MAC_ARM" "$CLI_MAC_X86" "$CLI_LNX_ARM" "$CLI_LNX_X86" <<'PY'
import re, sys
path, ver, mac_arm, mac_x86, lnx_arm, lnx_x86 = sys.argv[1:7]
s = open(path).read()
s = re.sub(r'^  version "[^"]+"$', f'  version "{ver}"', s, flags=re.M)
s = re.sub(r'/download/v[0-9][^/]*/freemkv-aarch64-macos-v[0-9][^"]*',
           f'/download/v{ver}/freemkv-aarch64-macos-v{ver}', s)
s = re.sub(r'/download/v[0-9][^/]*/freemkv-x86_64-macos-v[0-9][^"]*',
           f'/download/v{ver}/freemkv-x86_64-macos-v{ver}', s)
s = re.sub(r'/download/v[0-9][^/]*/freemkv-aarch64-linux-v[0-9][^"]*',
           f'/download/v{ver}/freemkv-aarch64-linux-v{ver}', s)
s = re.sub(r'/download/v[0-9][^/]*/freemkv-x86_64-linux-v[0-9][^"]*',
           f'/download/v{ver}/freemkv-x86_64-linux-v{ver}', s)
# The four sha256 lines are positional: each follows the url it belongs to, and
# the on_macos/on_linux x on_arm/on_intel order in the file is fixed.
hashes = [mac_arm, mac_x86, lnx_arm, lnx_x86]
out, i = [], 0
for line in s.split("\n"):
    m = re.match(r'^(\s*)sha256 "[0-9a-f]{64}"$', line)
    if m:
        line = f'{m.group(1)}sha256 "{hashes[i]}"'
        i += 1
    out.append(line)
assert i == 4, f"expected 4 sha256 lines in the formula, rewrote {i}"
open(path, "w").write("\n".join(out))
PY

C="$SELF_DIR/Casks/freemkv-app.rb"
python3 - "$C" "$VER" "$DMG_ARM" "$DMG_X86" <<'PY'
import re, sys
path, ver, arm, x86 = sys.argv[1:5]
s = open(path).read()
s = re.sub(r'^  version "[^"]+"$', f'  version "{ver}"', s, flags=re.M)
s = re.sub(r'^  sha256 arm:\s+"[0-9a-f]{64}",$',
           f'  sha256 arm:   "{arm}",', s, flags=re.M)
s = re.sub(r'^(\s+)intel: "[0-9a-f]{64}"$',
           rf'\1intel: "{x86}"', s, flags=re.M)
open(path, "w").write(s)
PY

rm -rf "$TMP"
echo "updated to $VER"
grep -n 'version "' "$F" "$C"
