require "formula"

class Fityk < Formula
  homepage "http://fityk.nieto.pl"
  url "https://github.com/wojdyr/fityk/releases/download/v1.3.1/fityk-1.3.1.tar.bz2"
  sha256 "3d88feb96dbdca70fbfb5f8fa994cea01e77723751e5957094ca46a0c6d511fe"

  depends_on "boost" => :build
  depends_on "lua"
  depends_on "zlib"
  depends_on "xylib"
  depends_on "wxWidgets"
  depends_on "readline" => :recommended
  depends_on "gnuplot" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"fityk", "--version"
    system bin/"xyconvert", "--version"
    system bin/"cfityk", "--version"
  end
end