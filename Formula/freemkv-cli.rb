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
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.11/freemkv-cli-aarch64-macos"
      sha256 "4c0fb6f5fcce260ccde4c8d07261ef301434687c7e8cecc72809a86d18652b0a"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.11/freemkv-cli-x86_64-macos"
      sha256 "2486fd16358b6cb4ec9f08e702279f651e456dd94d3fab9498c5a30e4a790b4a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.11/freemkv-cli-aarch64-linux"
      sha256 "c345ccc9f95c5a8b86e5f4c4b21e07fa024ecb1be9b1222a7c26550d3f196721"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.11/freemkv-cli-x86_64-linux"
      sha256 "71f37e9c73380c0d46238fbe48bef551f69bcbf5e607023dcdb67399eff989e5"
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
