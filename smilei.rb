class Smilei < Formula
  desc "a collaborative Particle-In-Cell code for plasma simulation"
  homepage "https://github.com/SmileiPIC/Smilei"
  head "https://github.com/SmileiPIC/Smilei.git"

  depends_on "python"
  depends_on "numpy"
  depends_on "hdf5-parallel"
  
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
    ENV.permit_arch_flags
    ENV["PYTHONEXE"] = "#{Formula["python"].opt_bin}/python3"
    ENV["PYTHONPATH"] = lib/"python3/site-packages"
    ENV["HDF5_ROOT_DIR"] = "#{Formula["hdf5-parallel"].opt_prefix}"
    ENV["OMPI_CXX"] = "#{Formula["gcc"].opt_bin}/g++-#{Formula["gcc"].any_installed_version.major}"
    ENV["CXX"] = "#{Formula["open-mpi"].opt_prefix}/bin/mpic++"
    
    system "make"
    bin.install "smilei"
    bin.install "smilei_test"

    share.install "benchmarks"
    
    libexec.install "happi"
    (libexec/"src").install "src/Python"
    (prefix/"lib/python#{Language::Python.major_minor_version ENV["PYTHONEXE"]}/site-packages/smilei.pth").write "import site; site.addsitedir('#{libexec}')\n"

  end
  
  test do
    system "mpirun", "-np", "2", "./smilei", "benchmarks/tst1d_00_em_propagation.py"
  end
  
  def caveats
    <<~EOS
    
        To install the happi post-processing dependencies, type
        pip3 install numpy ipython h5py pint matplotlib scipy
        
        To update Smilei just type
        brew upgrade --fetch-HEAD smilei

    EOS
  end
end
