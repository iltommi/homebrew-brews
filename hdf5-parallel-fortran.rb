class Hdf5Parallel < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.bz2"
  sha256 "68d6ea8843d2a106ec6a7828564c1689c7a85714a35d8efafa2fee20ca366f44"

  keg_only "it conflicts with hdf5 package"

  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "szip"
  depends_on "gcc"
  
  fails_with :clang
  env :std
  
  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHDF5_ENABLE_PARALLEL=ON", "-DHDF5_BUILD_CPP_LIB=OFF", "-DHDF5_BUILD_FORTRAN=ON"
      system "make", "install"
    end
  end
end
