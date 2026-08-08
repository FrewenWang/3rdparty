set(OPENCV_VERSION v4.11.0)                                                          # OpenCV的版本
if (OPENCV_VERSION STREQUAL v4.11.0)
    set(BUILD_OPENCV4 true)
    add_definitions(-DBUILD_OPENCV4)
    set(OPENCV_BUILD_TYPE ${AURA_DEPENDENCY_VARIANT})

    # Dependency directories follow <os>-<arch>-<variant>. Never silently use
    # x86_64 or arm64 binaries for a different target architecture.
    set(OPENCV_PLATFORM_DIR
        ${LIB_DIR}/opencv/lib/${OPENCV_VERSION}/${TARGET_OS}-${TARGET_ARCH}-${OPENCV_BUILD_TYPE})
    set(AURA_OPENCV_ROOT "${OPENCV_PLATFORM_DIR}" CACHE PATH
        "OpenCV package root for the selected target")
    set(OPENCV_PLATFORM_DIR "${AURA_OPENCV_ROOT}")

    if(NOT EXISTS "${OPENCV_PLATFORM_DIR}")
        message(WARNING
            "No bundled OpenCV package for ${TARGET_OS}-${TARGET_ARCH}. "
            "Set -DAURA_OPENCV_ROOT=<path> or -DBUILD_OPENCV=OFF.")
    endif()

    set(OPENCV_DIR ${OPENCV_PLATFORM_DIR})
    set(OPENCV_INCLUDE_DIR ${OPENCV_DIR}/include/opencv4)                               # OpenCV的include的目录
    set(OPENCV_LINK_DIR ${OPENCV_DIR}/lib)                                              # OpenCV的链接库
    set(OPENCV_3RDPARTY_LINK_DIR ${OPENCV_DIR}/lib/opencv4/3rdparty)                    # OpenCV的三方库的链接库

    # 主要库文件
    set(OPENCV_LIB opencv_world)

    # 第三方库文件
    set(OPENCV_3RDPARTY_LIBS
        libjpeg-turbo
        libpng
        libtiff
        libwebp
        libopenjp2
        IlmImf
        zlib
        ippicv
        ittnotify
    )

    # 包含目录
    include_directories(${OPENCV_INCLUDE_DIR})

    # 链接目录
    link_directories(${OPENCV_LINK_DIR})
    if(EXISTS ${OPENCV_3RDPARTY_LINK_DIR})
        link_directories(${OPENCV_3RDPARTY_LINK_DIR})
    endif()

    # 平台特定设置
    if(TARGET_OS STREQUAL "android")
        # Android 平台特定库
        set(OPENCV_PLATFORM_LIBS log)
    endif()
elseif (OPENCV_VERSION STREQUAL v2.4.13.4)
    set(BUILD_OPENCV2 true)
    add_definitions(-DBUILD_OPENCV2)
    set(OPENCV_BUILD_TYPE release)
    set(OPENCV_DIR ${LIB_DIR}/opencv/lib/${OPENCV_VERSION}/${TARGET_OS}-${TARGET_ARCH}-${OPENCV_BUILD_TYPE}) #OpenCV的目录
    set(OPENCV_INCLUDE_DIR ${OPENCV_DIR}/include/)                                      # OpenCV的include的目录
    set(OPENCV_LINK_DIR ${OPENCV_DIR}/lib/)                                             # OpenCV的链接库
    set(OPENCV_3RDPARTY_LINK_DIR ${OPENCV_DIR}/3rdparty/)                               # OpenCV的三方库的链接库
    set(OPENCV_LIB opencv_calib3d opencv_highgui opencv_imgproc opencv_core libtiff libpng IlmImf)
    include_directories(${OPENCV_INCLUDE_DIR})
    link_directories(${OPENCV_LINK_DIR})
    link_directories(${OPENCV_3RDPARTY_LINK_DIR})
endif ()
message(STATUS "[Dependency] opencv OPENCV_DIR=" ${OPENCV_DIR})
message(STATUS "[Dependency] opencv OPENCV_INCLUDE_DIR=" ${OPENCV_INCLUDE_DIR})
message(STATUS "[Dependency] opencv OPENCV_LINK_DIR=" ${OPENCV_LINK_DIR})
message(STATUS "[Dependency] opencv OPENCV_3RDPARTY_LINK_DIR=" ${OPENCV_3RDPARTY_LINK_DIR})
message(STATUS "[Dependency] opencv OPENCV_LIB=" ${OPENCV_LIB})
