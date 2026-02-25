class Lazyqmk < Formula
  desc "Interactive terminal workspace for QMK firmware for mechanical keyboards"
  homepage "https://github.com/Radialarray/LazyQMK"
  version "0.18.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.18.0/lazyqmk-aarch64-apple-darwin.tar.xz"
      sha256 "a9bad62066068a6748956783cfbe275d2cd82505a39efd4ca8c555743983fde3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.18.0/lazyqmk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d97bfe30a69b136484468d73964def4638524cf9c138b7262e7ffd870fc76bbe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.18.0/lazyqmk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ffdb027aa2ebdd8b4fb31fd673a50e767b9c3368b31f16b96c1b69a5b034694a"
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
