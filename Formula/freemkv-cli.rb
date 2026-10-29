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
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.6/freemkv-cli-aarch64-macos"
      sha256 "881db116200cf27f0320b528b3fe99716365c310bbe70d68025803f292296538"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.6/freemkv-cli-x86_64-macos"
      sha256 "4a951ea4037340cdb5e5a3028e62dc1c018df57822cfc7e5b4ee7f44b6b6d78a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.6/freemkv-cli-aarch64-linux"
      sha256 "81d2aadfc571152e31b5a43e4412cf9964061375e243791b1c1e8b29102d57e9"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.6/freemkv-cli-x86_64-linux"
      sha256 "563dac9db4c0fa041c0605c5b5c8687c61498a3634b7c263e9adf14eb97b716f"
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
