#!/bin/bash

# Set capnp executables for cross-compilation builds
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  export CAPNP_EXECUTABLE="${PREFIX}/bin/capnp"
  export CAPNPC_CXX_EXECUTABLE="${PREFIX}/bin/capnpc-c++"
  export Java_JAVA_EXECUTABLE="${PREFIX}/lib/jvm/bin/java"
  export Java_JAVAC_EXECUTABLE="${PREFIX}/lib/jvm/bin/javac"
  export Java_JAVAH_EXECUTABLE="${PREFIX}/lib/jvm/bin/java"
  export Java_JAR_EXECUTABLE="${PREFIX}/lib/jvm/bin/jar"
  export Java_JARSIGNER_EXECUTABLE="${PREFIX}/lib/jvm/bin/jarsigner"
else
  export CAPNP_EXECUTABLE="${BUILD_PREFIX}/bin/capnp"
  export CAPNPC_CXX_EXECUTABLE="${BUILD_PREFIX}/bin/capnpc-c++"
  export Java_JAVA_EXECUTABLE="${BUILD_PREFIX}/lib/jvm/bin/java"
  export Java_JAVAC_EXECUTABLE="${BUILD_PREFIX}/lib/jvm/bin/javac"
  export Java_JAVAH_EXECUTABLE="${BUILD_PREFIX}/lib/jvm/bin/java"
  export Java_JAR_EXECUTABLE="${BUILD_PREFIX}/lib/jvm/bin/jar"
  export Java_JARSIGNER_EXECUTABLE="${BUILD_PREFIX}/lib/jvm/bin/jarsigner"
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
    # Java JNI
    -D JAVA_HOME="${PREFIX}/lib/jvm"
    -D Java_JAVA_EXECUTABLE="${Java_JAVA_EXECUTABLE}"
    -D Java_JAVAC_EXECUTABLE="${Java_JAVAC_EXECUTABLE}"
    -D Java_JAVAH_EXECUTABLE="${Java_JAVAH_EXECUTABLE}"
    -D Java_JAR_EXECUTABLE="${Java_JAR_EXECUTABLE}"
    -D Java_JARSIGNER_EXECUTABLE="${Java_JARSIGNER_EXECUTABLE}"
)

cmake ${CMAKE_ARGS} "${extra_cmake_args[@]}" \
    -B build -S "${SRC_DIR}"

# Build and install
cmake --build build --target install

# Create symlink to jar file
ln -sf ${PREFIX}/java/UDA-${PKG_VERSION}.jar ${PREFIX}/java/UDA.jar
