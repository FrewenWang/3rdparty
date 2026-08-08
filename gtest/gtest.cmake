
set(GTEST_VERSION "v1.11.0")
set(GTEST_PATH "${LIB_DIR}/gtest")

set(GTEST_LIB_PATH "${GTEST_PATH}/${GTEST_VERSION}")
set(GTEST_SRC_PATH "${GTEST_PATH}/src/googletest-release-v1.11.0")
set(GTEST_INCLUDE_PATH "${GTEST_LIB_PATH}/include")
set(GTEST_LINK_PATH "${GTEST_LIB_PATH}/lib/${TARGET_OS}-${TARGET_ARCH}")

# Prefer a matching bundled binary, otherwise build the bundled source.  The
# repository currently ships Linux binaries only, so macOS must use sources.
if (EXISTS "${GTEST_LINK_PATH}/libgtest.a" AND
    EXISTS "${GTEST_LINK_PATH}/libgtest_main.a")
    include_directories(${GTEST_INCLUDE_PATH})
    link_directories(${GTEST_LINK_PATH})
    set(GTEST_LIB gtest gtest_main)
    message(STATUS "[Dependency] gtest using prebuilt libraries from ${GTEST_LINK_PATH}")
elseif (EXISTS "${GTEST_SRC_PATH}/CMakeLists.txt")
    # CMake 4 removed compatibility modes older than 3.5, while GTest 1.11's
    # top-level file still declares 2.8.12.
    set(CMAKE_POLICY_VERSION_MINIMUM 3.5 CACHE STRING "" FORCE)
    set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
    set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)
    add_subdirectory(
        "${GTEST_SRC_PATH}"
        "${CMAKE_BINARY_DIR}/_deps/googletest"
        EXCLUDE_FROM_ALL)
    set(GTEST_LIB GTest::gtest GTest::gtest_main)
    message(STATUS "[Dependency] gtest building bundled source from ${GTEST_SRC_PATH}")
else ()
    message(FATAL_ERROR "No compatible GTest binary or source tree was found")
endif ()

message(STATUS "[Dependency] gtest LIB = ${GTEST_LIB}")
