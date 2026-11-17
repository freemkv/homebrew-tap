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
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.10/freemkv-cli-aarch64-macos"
      sha256 "387950caa5f724179c58e64dd2d00e860f01b8610e27463117b8979f623a2620"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.10/freemkv-cli-x86_64-macos"
      sha256 "042b82904834d02d6f2ad6876952a73b255d1382eac1bbc21e7d1ca4bfdf143c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.10/freemkv-cli-aarch64-linux"
      sha256 "e94067264e4391ab0294b1c4051b781e0c384c65b7cb6d0982c934ece326ee5c"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.10/freemkv-cli-x86_64-linux"
      sha256 "47ad3cf965bb065023aff3fb8af7a0005e40cb0bd21b98dc7ddf4f6637edb4bb"
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
