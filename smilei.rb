class Smilei < Formula
  desc "a collaborative Particle-In-Cell code for plasma simulation"
  homepage "https://github.com/SmileiPIC/Smilei"
  head "https://github.com/SmileiPIC/Smilei.git"

  depends_on "python"
  depends_on "hdf5-parallel"
  depends_on "sphinx"
  
  fails_with :clang
  env :std
    
  build.head? do
    reason <<~EOS
      Smilei needs the Apple Command Line Tools to be installed.
        You can install them, if desired, with:
          xcode-select --install
    EOS
    satisfy { MacOS::CLT.installed? }
  end

  def install
#     ENV["OMPI_CXX"] = "g++-#{Formula["gcc"].version_suffix}"
    ENV.permit_arch_flags
    ENV['OMPI_CXX'] = "g++-8"
    ENV["PYTHONEXE"] = "python3"
    ENV["HDF5_ROOT_DIR"] = "#{Formula["hdf5-parallel"].opt_prefix}"
    ENV["CXX"] = "mpicxx"
    
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil
    
    system "make"
    
    bin.install "smilei"
    bin.install "smilei_test"

    system "make", "doc"
    share.install "build/html"

    system "make", "happi"

  end
  
  test do
    system "mpirun", "-np", "2", "./smilei", "benchmarks/tst1d_00_em_propagation.py"
  end
  
  def caveats
    <<~EOS
    
        Smilei executables are in the path, sources are located in ~/Library/Caches/Homebrew/smilei--git
        
        Documentation can be opened with
        open /usr/local/opt/smilei/share/html/index.html
        
        To install the happi post-processing module type
        make -C ~/Library/Caches/Homebrew/smilei--git happi
        
        To update Smilei just type
        brew upgrade --fetch-HEAD smilei
        
        Plese note that changes in ~/Library/Caches/Homebrew/smilei--git will be overwritten.
        
        If  you need to make changes to the code, please consider 
        forking the project on GitHub https://github.com/SmileiPIC/Smilei
        
    EOS
  end
end
