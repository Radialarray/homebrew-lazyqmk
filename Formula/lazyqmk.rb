class Lazyqmk < Formula
  desc "Interactive terminal workspace for QMK firmware for mechanical keyboards"
  homepage "https://github.com/Radialarray/LazyQMK"
  version "0.12.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Radialarray/LazyQMK/releases/download/v0.12.2/lazyqmk-aarch64-apple-darwin.tar.xz"
    sha256 "a7aa50d7ee5475b2b3eb66f13d65d91d231345c46d866885cd67bc8eb60c7d62"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.12.2/lazyqmk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "93b3fc3dba64dd4d2e1b9cfb78335adc925c6e64a4d9f448da4d74373d7108a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.12.2/lazyqmk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0d8fd2dc4c4bfe795a191d4eafc73773552f9c4bfcb79e7a04561dafae807bef"
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
