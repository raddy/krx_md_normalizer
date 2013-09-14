from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy as np
import os,cython

sourcefiles = ['krx_normalize.pyx']
this_dir = os.path.split(cython.__file__)[0]
extensions = [
    Extension("krx_normalize", sourcefiles,
              libraries=['pcap'],
              include_dirs=[np.get_include(),this_dir])
    ]

setup(cmdclass={'build_ext': build_ext},
      ext_modules=extensions,language="c++")