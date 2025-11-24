#!/bin/bash

# Set capnp executables for cross-compilation builds
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  export CAPNP_EXECUTABLE="${PREFIX}/bin/capnp"
  export CAPNPC_CXX_EXECUTABLE="${PREFIX}/bin/capnpc-c++"
else
  export CAPNP_EXECUTABLE="${BUILD_PREFIX}/bin/capnp"
  export CAPNPC_CXX_EXECUTABLE="${BUILD_PREFIX}/bin/capnpc-c++"
  export JNI_INCLUDE_PATH="${PREFIX}/lib/jvm/include"
  export JAVA_INCLUDE_PATH="${PREFIX}/lib/jvm/lib"
  export JAVA_JVM_LIBRARY="${PREFIX}/lib/jvm/lib"
fi

# CMake extra configuration:
extra_cmake_args=(
    -G Ninja
    -D BUILD_SHARED_LIBS=ON
    # SSL/RTL X509 authentication
    -D SSLAUTHENTICATION=ON
    # Build client
    -D CLIENT_ONLY=ON
    -D SERVER_ONLY=OFF
    # Enable Cap’n Proto serialisation
    -D ENABLE_CAPNP=ON
    -D CAPNP_EXECUTABLE="${CAPNP_EXECUTABLE}"
    -D CAPNPC_CXX_EXECUTABLE="${CAPNPC_CXX_EXECUTABLE}"
    # Disenable LibMemcached
    -D NO_MEMCACHE=ON
    # Wrappers
    -D NO_WRAPPERS=OFF
    -D NO_CXX_WRAPPER=ON
    -D NO_PYTHON_WRAPPER=ON
    -D NO_JAVA_WRAPPER=OFF
    -D NO_IDL_WRAPPER=ON
    -D FAT_IDL=OFF
    # CLI
    -D NO_CLI=ON
)

cmake ${CMAKE_ARGS} "${extra_cmake_args[@]}" \
    -B build -S "${SRC_DIR}"

# Build and install
cmake --build build --target install

# Create symlink to jar file
ln -sf ${PREFIX}/java/UDA-${PKG_VERSION}.jar ${PREFIX}/java/UDA.jar
