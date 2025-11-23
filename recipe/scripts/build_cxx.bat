@echo off

:: === Build & Install UDA client ===
:: Configure and build
cmake %CMAKE_ARGS% ^
    -G Ninja ^
    -D BUILD_SHARED_LIBS=ON ^
    -D SSLAUTHENTICATION=ON ^
    -D CLIENT_ONLY=ON ^
    -D SERVER_ONLY=OFF ^
    -D ENABLE_CAPNP=ON ^
    -D NO_MEMCACHE=ON ^
    -D NO_WRAPPERS=OFF ^
    -D NO_CXX_WRAPPER=OFF ^
    -D NO_PYTHON_WRAPPER=ON ^
    -D NO_JAVA_WRAPPER=ON ^
    -D NO_IDL_WRAPPER=ON ^
    -D FAT_IDL=OFF ^
    -D NO_CLI=ON ^
    -D XDR_LIBRARIES="%LIBRARY_LIB%\xdr.lib" ^
    -D XDR_INCLUDE_DIR="%LIBRARY_INC%\rpc" ^
    -B build -S "%SRC_DIR%" || exit /b 1

:: Build and install
cmake --build build --target install || exit /b 1
