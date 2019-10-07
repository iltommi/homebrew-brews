class Hdf5Parallel < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.bz2"
  sha256 "68d6ea8843d2a106ec6a7828564c1689c7a85714a35d8efafa2fee20ca366f44"

  keg_only "it conflicts with hdf5 package"

  depends_on "cmake"
  depends_on "gcc"
  depends_on "open-mpi"
  depends_on "szip"
  
  fails_with :clang
  env :std
  
  def install
    ENV['OMPI_CXX'] = ENV["CXX"]
    ENV["CXX"] = "mpicxx"
    ENV['OMPI_CC'] = ENV["CC"]
    ENV["CC"] = "mpicc"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHDF5_ENABLE_PARALLEL=ON", "-DHDF5_BUILD_CPP_LIB=OFF", "-DHDF5_BUILD_FORTRAN:BOOL=ON"
      system "make", "install"
    end
  end
end
