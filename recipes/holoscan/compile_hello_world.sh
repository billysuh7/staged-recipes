#!/bin/bash

set -ex

cp -vf $PREFIX/examples/hello_world/cpp/CMakeLists.txt .
cp -vf $PREFIX/examples/hello_world/cpp/hello_world.cpp .

# $CONDA_PREFIX/libexec/gcc/x86_64-conda-linux-gnu/13.3.0/cc1plus
find $CONDA_PREFIX -name cc1plus

GCC_DIR=$(dirname $(find $CONDA_PREFIX -name cc1plus))

export PATH=${GCC_DIR}:$PATH
export LD_LIBRARY_PATH=${GCC_DIR}:$LD_LIBRARY_PATH

export CXXFLAGS="${CXXFLAGS} -fno-use-linker-plugin"

$PREFIX/bin/x86_64-conda-linux-gnu-c++ --version

cmake . \
  -DCMAKE_LIBRARY_PATH=${GCC_DIR} \
  -DCMAKE_C_COMPILER=$PREFIX/bin/x86_64-conda-linux-gnu-gcc \
  -DCMAKE_CXX_COMPILER=$PREFIX/bin/x86_64-conda-linux-gnu-g++ \
  -DCUDAToolkit_INCLUDE_DIRECTORIES="$PREFIX/include;$PREFIX/targets/x86_64-linux/include" \
  -DCUDAToolkit_LIBRARY_DIRECTORIES="$PREFIX/lib;${GCC_DIR}"

cmake --build .

test -f hello_world && test -x hello_world

./hello_world
