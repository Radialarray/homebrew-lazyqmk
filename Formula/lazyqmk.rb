class Lazyqmk < Formula
  desc "Interactive terminal workspace for QMK firmware for mechanical keyboards"
  homepage "https://github.com/Radialarray/LazyQMK"
  version "0.19.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.19.0/lazyqmk-aarch64-apple-darwin.tar.xz"
      sha256 "080e4e53b5ef380e1c9f0bdff3df540894718326750714ce663e88eac05ddaf2"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.19.0/lazyqmk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4754174b7ced35d6f5973772a181f387a4dfb6eae9088ff25ba210c67f01d79c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.19.0/lazyqmk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5bc0c67818f55e57a3a4183fb485308d9ae4b0f9a45df0e3421b60e44a1174bb"
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
