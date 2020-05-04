class GnuplotMulti < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  head "https://git.code.sf.net/p/gnuplot/gnuplot-main.git"

  keg_only "it conflicts with gnuplot package"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "pkg-config" => :build
  depends_on "pango"
  depends_on "wxmac"
  depends_on "qt"
  
  def install
    ENV.cxx11
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-tutorial
      --with-wx=#{Formula["wxmac"].opt_prefix}/bin/
      --with-readline=builtin
      --without-x
      --without-gd
      --without-lua
      --without-libcerf
      --without-cairo
    ]
    
    system "sed -i '' 's/define\ GP_CAIRO_SCALE\ 20/define\ GP_CAIRO_SCALE\ 1/g' ./src/wxterminal/gp_cairo.h"
    
    system "./prepare"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_predicate testpath/"graph.txt", :exist?
  end
end
