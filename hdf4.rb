class Hdf4 < Formula
  desc "HDF version 4"
  homepage "https://www.hdfgroup.org"
  url "https://support.hdfgroup.org/ftp/HDF/HDF_Current/src/hdf-4.2.13.tar.bz2"
  sha256 "55d3a42313bda0aba7b0463687caf819a970e0ba206f5ed2c23724f80d2ae0f3"
  revision 3

  bottle do
	root_url "https://github.com/iltommi/homebrew-brews/releases/download/latest/hdf4-4.2.13_3.sierra.bottle.tar.gz"
    sha256 "51d8d8d9eec66ac81b6e1f79c6355fb0f4d89d7edd9724b69e46b7c7bb7937a9" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "szip"
  depends_on "jpeg"

  # redefine library name to "df" from "hdf".  this seems to be an artifact
  # of using cmake that needs to be corrected for compatibility with
  # anything depending on hdf4.
  patch :DATA

  def install
    ENV["SZIP_INSTALL"] = HOMEBREW_PREFIX

    args = std_cmake_args
    args.concat [
      "-DBUILD_SHARED_LIBS=ON",
      "-DBUILD_TESTING=OFF",
      "-DHDF4_BUILD_TOOLS=ON",
      "-DHDF4_BUILD_UTILS=ON",
      "-DHDF4_BUILD_WITH_INSTALL_NAME=ON",
      "-DHDF4_ENABLE_JPEG_LIB_SUPPORT=ON",
      "-DHDF4_ENABLE_NETCDF=OFF", # Conflict. Just install NetCDF for this.
      "-DHDF4_ENABLE_SZIP_ENCODING=ON",
      "-DHDF4_ENABLE_SZIP_SUPPORT=ON",
      "-DHDF4_ENABLE_Z_LIB_SUPPORT=ON",
      "-DHDF4_BUILD_FORTRAN=OFF",
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"

      # Remove stray ncdump executable as it conflicts with NetCDF.
      rm (bin+"ncdump")
      rm (bin+"ncgen")
    end
  end

  def caveats; <<-EOS.undent
      HDF4 has been superseeded by HDF5.  However, the API changed
      substantially and some programs still require the HDF4 libraries in order
      to function.
    EOS
  end
end

__END__
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -119,7 +119,7 @@ mark_as_advanced (HDF4_NO_PACKAGES)
 #-----------------------------------------------------------------------------
 # Set the core names of all the libraries
 #-----------------------------------------------------------------------------
-set (HDF4_SRC_LIB_CORENAME          "hdf")
+set (HDF4_SRC_LIB_CORENAME          "df")
 set (HDF4_SRC_FCSTUB_LIB_CORENAME   "hdf_fcstub")
 set (HDF4_SRC_FORTRAN_LIB_CORENAME  "hdf_fortran")
 set (HDF4_MF_LIB_CORENAME           "mfhdf")
