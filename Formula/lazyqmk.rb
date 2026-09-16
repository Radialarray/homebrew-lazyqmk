class Lazyqmk < Formula
  desc "Interactive terminal workspace for QMK firmware for mechanical keyboards"
  homepage "https://github.com/Radialarray/LazyQMK"
  version "0.27.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Radialarray/LazyQMK/releases/download/v0.27.6/lazyqmk-aarch64-apple-darwin.tar.xz"
    sha256 "4e9227d0c1f4fa0427951fde588e782ce3603b3dc32ff3baff2b5007d0b3b636"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.27.6/lazyqmk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd1cf433ce43b4e2989dca62e077611756dc250e5526ce0bc7804637d9c508fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.27.6/lazyqmk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c2c7dcd5f0339b054faa2a617b061d30a96b4f00be4f6eba84c71fa7d7163047"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "lazyqmk"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "lazyqmk"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "lazyqmk"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
