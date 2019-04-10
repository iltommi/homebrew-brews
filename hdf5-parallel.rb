class Hdf5Parallel < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.bz2"
  sha256 "68d6ea8843d2a106ec6a7828564c1689c7a85714a35d8efafa2fee20ca366f44"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "szip"

  keg_only "it conflicts with other hdf5 libraries"
    
  def install
    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in tools/src/misc/h5cc.in],
      "${libdir}/libhdf5.settings",
      "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am",
              "settingsdir=$(libdir)",
              "settingsdir=#{pkgshare}"

    system "autoreconf", "-fiv"

    ENV["CC"] = "mpicc"
    ENV["CXX"] = "mpicxx"
    ENV["FC"] = "mpif90"
    ENV["OMPI_C"] = "gcc-#{Formula["gcc"].version_suffix}"
    ENV["OMPI_CXX"] = "g++-#{Formula["gcc"].version_suffix}"
    ENV["OMPI_FC"] = "gfortran-#{Formula["gcc"].version_suffix}"
    
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
      --enable-build-mode=production
      --enable-parallel
    ]

    system "./configure", *args
    system "make", "install"
  end
end
