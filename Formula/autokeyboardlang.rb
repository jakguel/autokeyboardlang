class Autokbisw < Formula
  desc "Automatic keyboard input language switching for macOS"
  homepage "https://github.com/jakguel/autokeyboardlang"
  version "2.1.0"

  on_arm do
    if MacOS.version >= :sequoia
      url "https://github.com/jakguel/autokeyboardlang/releases/download/v2.1.0/autokbisw-v2.1.0.arm64_tahoe.tar.gz"
      sha256 "3edca2e600d00ff383fe55859f6c010f5dd65b61a3a28f9fd2d270452ac71284"
    else
      url "https://github.com/jakguel/autokeyboardlang/releases/download/v2.1.0/autokbisw-v2.1.0.arm64_sequoia.tar.gz"
      sha256 "837a162c6bec1048d2421cee216dcf8a0b891e27c000de21559e2d42df391873"
    end
  end

  def install
    bin.install "autokeyboardlang"
  end

  service do
    run [bin/"autokeyboardlang"]
    keep_alive true
    log_path var/"log/autokeyboardlang.log"
    error_log_path var/"log/autokeyboardlang.log"
  end

  test do
    system bin/"autokeyboardlang", "--help"
  end
end
