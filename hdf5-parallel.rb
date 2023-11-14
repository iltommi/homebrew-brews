class Hdf5Parallel < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.14/hdf5-1.14.3/src/hdf5-1.14.3.tar.bz2"
  sha256 "9425f224ed75d1280bb46d6f26923dd938f9040e7eaebf57e66ec7357c08f917"
  license "BSD-3-Clause"

  keg_only "it conflicts with hdf5 package"

  depends_on "gcc"
  depends_on "open-mpi"
  depends_on "libaec"
  
  fails_with :clang
  env :std
  
  def install
    ENV["CXX"] = "#{Formula["open-mpi"].opt_prefix}/bin/mpic++"
    ENV["CC"]  = "#{Formula["open-mpi"].opt_prefix}/bin/mpicc"
    ENV["FC"]  = "#{Formula["open-mpi"].opt_prefix}/bin/mpif90"
    
    system "env"
    system "./configure", "--enable-parallel",
                          "--enable-fortran",
                          "--prefix=#{prefix}",
                          "--with-szlib=#{Formula["libaec"].opt_prefix}"
    
    system "make", "install"    
  end
  
end
