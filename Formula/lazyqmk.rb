class Lazyqmk < Formula
  desc "Interactive terminal workspace for QMK firmware for mechanical keyboards"
  homepage "https://github.com/Radialarray/LazyQMK"
  version "0.12.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Radialarray/LazyQMK/releases/download/v0.12.2/lazyqmk-aarch64-apple-darwin.tar.xz"
    sha256 "bf2ed842de138fdab0e73a65d5125af925ad04d6eba560c93dc7262da530dc53"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.12.2/lazyqmk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1e49b2c1d7dbdb0eb4a84733f4039a67c6f82fa888b2e2a5d005f1a11feeda37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.12.2/lazyqmk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "16da127b866d136c7d051477cd2d809c11fe76e4a1706fb5e873f36417c23abc"
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
