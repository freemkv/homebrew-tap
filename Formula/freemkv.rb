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
  version "1.6.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.2/freemkv-aarch64-macos-v1.6.2"
      sha256 "9c564c50797241aa88944fd9798cfa4671029192bd24dc5e719e0de25c9a662a"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.2/freemkv-x86_64-macos-v1.6.2"
      sha256 "81810b90b80b8637aa7fc06a5ea7a25f297b6d5601c184f4a67a479b24a27afb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.2/freemkv-aarch64-linux-v1.6.2"
      sha256 "dfa1afdbc88246a72823edaf8bca7f3bc66c25b5f8b76f9599542875a34d15b9"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.6.2/freemkv-x86_64-linux-v1.6.2"
      sha256 "ce33ea759726d0e3ece079727264089797561739b6cb33284c2efe845e497003"
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
