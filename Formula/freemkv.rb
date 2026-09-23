# The freemkv command-line ripper.
#
# Homebrew downloads with curl, and curl does not set the com.apple.quarantine
# attribute -- only browsers do. So this install is not subject to the Gatekeeper
# prompt a downloaded binary gets, and works whether or not the binary is
# notarized. That is why this formula exists: it is the friction-free way to get
# the CLI on a Mac.
class Freemkv < Formula
  desc "Rip and remux Blu-ray, UHD, DVD and HD DVD discs to MKV"
  homepage "https://freemkv.org"
  license "MIT"
  # No explicit `version`: Homebrew scans it from the URL, so bumping the URLs
  # bumps the version and the two can never disagree. `brew audit` flags a
  # standalone version here as redundant, and it is.

  on_macos do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.5/freemkv-aarch64-macos-v1.7.5"
      sha256 "5124248def5ecca58c5187fded0badff997f6a12eb086f3b98a33182a181b237"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.5/freemkv-x86_64-macos-v1.7.5"
      sha256 "30cb302da0b44394e81d194a7dc11e15ddd6265d6438deddc438e6b1ef1f9349"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.5/freemkv-aarch64-linux-v1.7.5"
      sha256 "9b41b15813d696a043e0975242e119b66cd47f9415a0ac2c6e41a0435d21bdd0"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.7.5/freemkv-x86_64-linux-v1.7.5"
      sha256 "e1aa483c347e205c896cef42fe89468100198f95beb3cf497ee120dfb72b085c"
    end
  end

  def install
    # The release asset is the bare executable under a versioned name; install
    # it as plain `freemkv`.
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
