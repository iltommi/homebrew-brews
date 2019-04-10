class Smilei < Formula
  desc "a collaborative Particle-In-Cell code for plasma simulation"
  homepage "https://github.com/SmileiPIC/Smilei"
  head "https://github.com/SmileiPIC/Smilei.git"

  depends_on "gcc"
  depends_on "libomp"
  depends_on "python"
  depends_on "open-mpi"
  depends_on "hdf5-parallel"
  depends_on "autoconf"
   
  env :std
    
  def install
#     ENV["OMPI_CXX"] = "g++-#{Formula["gcc"].version_suffix}"
    ENV.deparallelize
    ENV.permit_arch_flags
    ENV['OMPI_CXX'] = "g++-8"
    ENV["PYTHONEXE"] = "python3"
    ENV["HDF5_ROOT_DIR"] = "#{Formula["hdf5-parallel"].opt_prefix}"
    ENV["CXX"] = "mpicxx"
    ENV["HOMEBREW_CXX"] = "g++-8"
    ENV["HOMEBREW_CC"] = "gcc-8"
    ENV["CXXFLAGS"] = ""
    ENV["CFLAGS"] = ""
    ENV["LDFLAGS"] = ""
    
    system "make config=verbose"
    bin.install "smilei"
    bin.install "smilei_test"
    
  end
end
