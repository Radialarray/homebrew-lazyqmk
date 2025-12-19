class Lazyqmk < Formula
  desc "Interactive terminal workspace for QMK firmware"
  homepage "https://github.com/Radialarray/LazyQMK"
  version "0.12.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v#{version}/lazyqmk-macos-aarch64.zip"
      sha256 "d7bab8ba24155dcdb4c7a3fd4bdc8885cc52fdabe642a2b3f0a745175eca248f"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v#{version}/lazyqmk-linux-aarch64.zip"
      sha256 "e66222e7f566a72fa637531757edc19a46e2e0d92d367d64e2ebf4be74235cac"
    else
      url "https://github.com/Radialarray/LazyQMK/releases/download/v#{version}/lazyqmk-linux-x86_64.zip"
      sha256 "0fa31c7486f46e83f2d33687d06eca83e904b6c5a7dd2f3d4a98ad7837d19daa"
    end
  end

  def install
    bin.install "lazyqmk"
  end

  test do
    system "#{bin}/lazyqmk", "--version"
  end
end
