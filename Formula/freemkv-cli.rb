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
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.1/freemkv-cli-aarch64-macos"
      sha256 "ff3f370b0d58d675c7f281afc43987973b611fd2c50733f701d153815037891a"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.1/freemkv-cli-x86_64-macos"
      sha256 "e2f95f4bf4fbbb3f32abfc6f8d90d6e9a5b901a08636061f7d93a4730190420a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.1/freemkv-cli-aarch64-linux"
      sha256 "c058f2b0d64c1d988dd8d9e499677a48ade67595fb5a7cda12430358e3daef22"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.1/freemkv-cli-x86_64-linux"
      sha256 "3f6a091416ea71e040cf76c3c700bd24dc80d56c2eacd7b4e7dd38e10811704e"
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
