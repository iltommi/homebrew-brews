class Hdf5Parallel < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
#   head "https://bitbucket.hdfgroup.org/scm/hdffv/hdf5.git"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.bz2"
  sha256 "97906268640a6e9ce0cde703d5a71c9ac3092eded729591279bf2e3ca9765f61"

  keg_only "it conflicts with hdf5 package"

  depends_on "cmake"
  depends_on "gcc"
  depends_on "open-mpi"
  depends_on "szip"
  
  fails_with :clang
  env :std
  
  def install
    ENV["OMPI_CXX"] = ENV["CXX"]
    ENV["CXX"] = "mpicxx"
    ENV["OMPI_CC"] = ENV["CC"]
    ENV["CC"] = "mpicc"
    ENV["OMPI_FC"] = "gfortran"
    ENV["FC"] = "mpif90"
    
    args = %W[
      -DHDF5_ENABLE_PARALLEL=ON
      -DHDF5_BUILD_CPP_LIB=OFF
      -DHDF5_BUILD_FORTRAN=ON
      -DCMAKE_BUILD_TYPE=Release
    ]
    
    mkdir "build" do
      system "cmake", "..", *std_cmake_args , *args
      system "make", "install"
    end
  end
  
end
