class Lazyqmk < Formula
  desc "Interactive terminal workspace for QMK firmware for mechanical keyboards"
  homepage "https://github.com/Radialarray/LazyQMK"
  version "0.21.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Radialarray/LazyQMK/releases/download/v0.21.0/lazyqmk-aarch64-apple-darwin.tar.xz"
    sha256 "2cc9b232b67da22e8119b2812fb2bbd7d88b3185d5e09a8f4529dc66cf45bbda"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.21.0/lazyqmk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "feef48ba623e6c6cf7eaec9e6c10e37847d958824099069b95bdc5eb07a32e96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.21.0/lazyqmk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "03d4159fa09ea2b9cec1823129309b18149ddb8fdb5380a9178af8e49a956ae5"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "lazyqmk" if OS.mac? && Hardware::CPU.arm?
    bin.install "lazyqmk" if OS.linux? && Hardware::CPU.arm?
    bin.install "lazyqmk" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
