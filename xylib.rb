class Xylib < Formula
  desc "Library for reading x-y data files"
  homepage "http://xylib.sourceforge.net"
  url "https://github.com/wojdyr/xylib/releases/download/v1.5/xylib-1.5.tar.bz2"
  sha256 "cdda7aa84e548e90ad1b0afd41fbee5d90232ab3da0968661a7f37f801ea53e4"

  depends_on "boost" => :build
  depends_on "wxmac"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"xyconv", "--version"
    (testpath/"with_sigma.txt").write "20.0 490.5"
    system "#{bin}/xyconv", "-g", "#{testpath}/with_sigma.txt"
  end
end
