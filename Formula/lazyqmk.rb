class Lazyqmk < Formula
  desc "Interactive terminal workspace for QMK firmware"
  homepage "https://github.com/Radialarray/LazyQMK"
  version "0.12.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v#{version}/lazyqmk-macos-aarch64.zip"
      sha256 "3040c924cb146ffe0e0b9e5c77a9e5dc90be8b4cb315502b0823e4f6b8731af4"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v#{version}/lazyqmk-linux-aarch64.zip"
      sha256 "03e5f1dfe3485c08f7e96618b5dca3960f8d999a2fd414d7d99c6578bd8c0393"
    else
      url "https://github.com/Radialarray/LazyQMK/releases/download/v#{version}/lazyqmk-linux-x86_64.zip"
      sha256 "bd420fe35da364cb0720d3f328d96d06fbcba27a62e2945601268243e220a7c4"
    end
  end

  def install
    bin.install "lazyqmk"
  end

  test do
    system "#{bin}/lazyqmk", "--version"
  end
end
