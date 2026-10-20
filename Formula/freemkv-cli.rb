# The freemkv command-line ripper, without the desktop app.
#
# Homebrew downloads with curl, and curl does not set the com.apple.quarantine
# attribute -- only browsers do. So this install is not subject to the Gatekeeper
# prompt a downloaded binary gets, and works whether or not the binary is
# notarized. That is why this formula exists: it is the friction-free way to get
# the CLI on a Mac, and the way to get it on Linux.
#
# Was `freemkv` before 1.8.0; formula_renames.json carries existing installs
# across. The `freemkv` cask now links the same command from inside the app, so
# install one or the other (see the naming note in Casks/freemkv.rb).
class FreemkvCli < Formula
  desc "Rip and remux Blu-ray, UHD, DVD and HD DVD discs to MKV"
  homepage "https://freemkv.org"
  license "MIT"
  # No explicit `version`: Homebrew scans it from the URL -- from the v1.8.0
  # release-tag path segment, now that the asset names themselves are
  # unversioned -- so bumping the URLs bumps the version and the two can never
  # disagree. `brew audit` flags a standalone version here as redundant.

  on_macos do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.5/freemkv-cli-aarch64-macos"
      sha256 "f0b9c83f14d8021cd0d8baa56e558f661c886b1d5f7cd9e24fb907d9994d95ee"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.5/freemkv-cli-x86_64-macos"
      sha256 "adc3a61048140a95a3f2a728fc93b215635872710870d6f33a62e4eec3d7b7e5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.5/freemkv-cli-aarch64-linux"
      sha256 "f6f00a2b1faec88ab97487cb935e2d1e5a2aa4ff786b828a77862dbc130fb27d"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.5/freemkv-cli-x86_64-linux"
      sha256 "457ea27f64fc64acf3aa36a0e7c4e13a78c85330aa83baa72b005261111f248e"
    end
  end

  def install
    # The release asset is the bare executable under a per-platform name;
    # install it as plain `freemkv`.
    bin.install Dir["*"].first => "freemkv"
  end

  def caveats
    <<~EOS
      Decrypting a commercial disc needs a key database (keydb.cfg) or a key
      service. Neither ships with freemkv:

        freemkv update-keys

      Reading a disc also needs a drive freemkv can address directly; it
      unmounts the disc first to take exclusive access.
    EOS
  end

  test do
    # `--version` prints "<version> (<commit>)", so match the leading version
    # rather than the whole line.
    assert_match version.to_s, shell_output("#{bin}/freemkv --version")
  end
end
