class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "http://www.fftw.org"
  url "http://fftw.org/fftw-3.3.7.tar.gz"
  sha256 "3b609b7feba5230e8f6dd8d245ddbefac324c5a6ae4186947670d9ac2cd25573"

  bottle do
    root_url "https://github.com/iltommi/homebrew-brews/releases/download/latest"
    sha256 "9850065d6e200e1bb59d5ca5ff905bb9e301db3087396bb5c53670bc9d66f882" => :sierra
  end

  option "with-mpi", "Enable MPI parallel transforms"

  depends_on "open-mpi"
  depends_on "gcc"

  def install
    args = ["--enable-shared",
            "--disable-debug",
            "--prefix=#{prefix}",
            "--disable-dependency-tracking"]
    simd_args = ["--enable-sse2"]
    simd_args << "--enable-avx" if ENV.compiler == :clang && Hardware::CPU.avx? && !build.bottle?
    simd_args << "--enable-avx2" if ENV.compiler == :clang && Hardware::CPU.avx2? && !build.bottle?

    args << "--enable-mpi" if build.with? "mpi"
    system "./configure", "--enable-threads", "--disable-fortran", *(args + simd_args)
    system "make", "install"
  end
end

