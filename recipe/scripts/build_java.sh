#!/bin/bash

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
    -D CMAKE_BUILD_TYPE=Release \
    -B build -S "${SRC_DIR}"

# Build and install
cmake --build build --target install

# Create symlink to jar file
ln -sf $PREFIX/java/UDA-${PKG_VERSION}.jar $PREFIX/java/UDA.jar
