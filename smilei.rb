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
    ENV.permit_arch_flags
    ENV["PYTHONEXE"] = "python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"
    ENV["HDF5_ROOT_DIR"] = "#{Formula["hdf5-parallel"].opt_prefix}"
    ENV["CXX"] = "mpicxx"
    ENV['OMPI_CXX'] = ENV["OBJCXX"]
    
    system "make"
    bin.install "smilei"
    bin.install "smilei_test"

    system "make", "doc"
    share.install "build/html"
    share.install "benchmarks"
    
    libexec.install "happi"
    (libexec/"src").install "src/Python"
    xy = Language::Python.major_minor_version "python3"
    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec}')\n"
    (prefix/site_packages/"smilei.pth").write pth_contents

  end
  
  test do
    system "mpirun", "-np", "2", "./smilei", "benchmarks/tst1d_00_em_propagation.py"
  end
  
  def caveats
    <<~EOS
    
        To install the happi post-processing dependencies, type
        pip3 install numpy ipython h5py pint matplotlib scipy
        
        Documentation can be opened with
        open /usr/local/opt/smilei/share/html/index.html
        
        To update Smilei just type
        brew upgrade --fetch-HEAD smilei

    EOS
  end
end
