class Autokbisw < Formula
  desc "Automatic keyboard input language switching for macOS"
  homepage "https://github.com/charliejones1/autokbisw"
  version "2.1.0"

  on_arm do
    if MacOS.version >= :sequoia
      url "https://github.com/charliejones1/autokbisw/releases/download/v2.1.0/autokbisw-v2.1.0.arm64_tahoe.tar.gz"
      sha256 "TAHOE_SHA256_HERE"
    else
      url "https://github.com/charliejones1/autokbisw/releases/download/v2.1.0/autokbisw-v2.1.0.arm64_sequoia.tar.gz"
      sha256 "SEQUOIA_SHA256_HERE"
    end
  end

  def install
    bin.install "autokbisw"
  end

  service do
    run [bin/"autokbisw"]
    keep_alive true
    log_path var/"log/autokbisw.log"
    error_log_path var/"log/autokbisw.log"
  end

  test do
    system bin/"autokbisw", "--help"
  end
end
