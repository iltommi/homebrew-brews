class Clfft < Formula
  desc "FFT functions written in OpenCL"
  homepage "https://github.com/iltommi/clFFT"
  url "https://github.com/iltommi/clFFT/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "e846139e127e6a6d62cfc2d2d6fa49b9b4b61769b9060cdcfe9a0012ee4da9fb"
  license "Apache-2.0"

  depends_on "boost" => :build
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "../src", "-DBUILD_EXAMPLES:BOOL=OFF", "-DBUILD_TEST:BOOL=OFF", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "src/examples"
  end

  test do
    system ENV.cxx, pkgshare/"examples/fft1d.c", "-I#{include}", "-L#{lib}",
                    "-lclFFT", "-framework", "OpenCL", "-o", "fft1d"
    assert_match "one dimensional array of size N = 16", shell_output("./fft1d")
  end
end
