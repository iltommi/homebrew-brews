class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "http://www.fftw.org"
  url "http://fftw.org/fftw-3.3.7.tar.gz"
  sha256 "3b609b7feba5230e8f6dd8d245ddbefac324c5a6ae4186947670d9ac2cd25573"

  bottle do
    root_url "https://github.com/iltommi/homebrew-brews/releases/download/latest"
    sha256 "f8d47233c389c34a26bb3cbdbad81d8abcdd6dd43425f238379a686a3929f3f5" => :sierra
  end

  option "with-mpi", "Enable MPI parallel transforms"

  depends_on :mpi => [:cc, :optional]
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
Z
