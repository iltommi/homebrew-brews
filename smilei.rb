class Smilei < Formula
  desc "a collaborative Particle-In-Cell code for plasma simulation"
  homepage "https://github.com/SmileiPIC/Smilei"
  head "https://github.com/SmileiPIC/Smilei.git"

  depends_on "python"
  depends_on "hdf5-parallel"
  depends_on "sphinx"
   
  env :std
    
  def install
#     ENV["OMPI_CXX"] = "g++-#{Formula["gcc"].version_suffix}"
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
    
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil
    
    system "make"
    system "make", "doc"
    
    bin.install "smilei"
    bin.install "smilei_test"
    share.install "build/html"

  end
  def caveats
    <<~EOS
    
        Smilei executables are in the path, sources are located in ~/Library/Caches/Homebrew/smilei--git
        
        Documentation can be opened with
        open /usr/local/opt/smilei/share/html/index.html
        
        To install the happi post-processing module type
        make -C ~/Library/Caches/Homebrew/smilei--git happi
        
        
        To keep up-to date Smilei with just type
        brew upgrade
        Plese note that changes in ~/Library/Caches/Homebrew/smilei--git will be overwritten.
        
        If  you need to make changes to the code, please consider 
        forking the project on GitHub https://github.com/SmileiPIC/Smilei
        
    EOS
  end
end
