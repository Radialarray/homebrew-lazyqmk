class Lazyqmk < Formula
  desc "Interactive terminal workspace for QMK firmware for mechanical keyboards"
  homepage "https://github.com/Radialarray/LazyQMK"
  version "0.27.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Radialarray/LazyQMK/releases/download/v0.27.4/lazyqmk-aarch64-apple-darwin.tar.xz"
    sha256 "33e6843eb5263e4d22f5646d774b7151cadc982833727e238d4a280559f55285"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.27.4/lazyqmk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0d53bafc6076f5c0aa28dcfb8293f5fafd12acfae897adbd289ab841a44d7c01"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Radialarray/LazyQMK/releases/download/v0.27.4/lazyqmk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f051830b6af1a15f2226dbc956d98e7094255fedeac2703b76cb579cfc6d8b45"
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
