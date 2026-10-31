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
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.7/freemkv-cli-aarch64-macos"
      sha256 "31fd64f0b37b4f511d8e16a5f3f19078d50622ff4ea0b3b21721cb9f6365ff6f"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.7/freemkv-cli-x86_64-macos"
      sha256 "519d7257a71b58c904d2ae6fa8c54c3c3fb3821ceb5d02aadc808d56d05fa3ae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.7/freemkv-cli-aarch64-linux"
      sha256 "24023bb28b7909c155487094b5044f9b349153f24cc00755b82bf86614c75529"
    end
    on_intel do
      url "https://github.com/freemkv/freemkv/releases/download/v1.8.7/freemkv-cli-x86_64-linux"
      sha256 "3913996dc3ecad740fbabb5d1e38f09afae49eef4e2dfde348e2ec69a0203e7d"
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
