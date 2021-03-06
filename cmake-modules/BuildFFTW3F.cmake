macro(build_fftw3f install_prefix staging_prefix)
  
  IF(CMAKE_BUILD_TYPE STREQUAL Release)
    SET(EXT_C_FLAGS   "${CMAKE_C_FLAGS}   ${CMAKE_C_FLAGS_RELEASE}")
    SET(EXT_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}")
  ELSE()
    SET(EXT_C_FLAGS   "${CMAKE_C_FLAGS}    ${CMAKE_C_FLAGS_DEBUG}")
    SET(EXT_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG}")
  ENDIF()

  SET(EXT_C_COMPILER ${CMAKE_C_COMPILER})
  SET(EXT_CXX_COMPILER ${CMAKE_CXX_COMPILER})
  IF(CCACHE_FOUND)
    SET(EXT_C_COMPILER   "${CCACHE_FOUND} ${CMAKE_C_COMPILER}")
    SET(EXT_CXX_COMPILER "${CCACHE_FOUND} ${CMAKE_CXX_COMPILER}")
  ENDIF(CCACHE_FOUND)

  SET(FFTW3F_CONFIG --enable-sse --enable-sse2  --with-pic --disable-shared --enable-threads --disable-fortran --enable-single --enable-float)
  
  IF(NOT APPLE)
    LIST(APPEND FFTW3F_CONFIG --enable-avx )
  ENDIF(NOT APPLE)

  IF(MT_USE_OPENMP)
    LIST(APPEND FFTW3F_CONFIG --enable-openmp  )
  ENDIF(MT_USE_OPENMP)
  
  GET_PACKAGE("http://www.fftw.org/fftw-3.3.6-pl2.tar.gz" "927e481edbb32575397eb3d62535a856" "fftw-3.3.6-pl2.tar.gz" FFTW_PATH ) 

  ExternalProject_Add(FFTW3F
        SOURCE_DIR FFTW3F
        URL "${FFTW_PATH}"
        URL_MD5 "927e481edbb32575397eb3d62535a856"
        BUILD_IN_SOURCE 1
        INSTALL_DIR     "${staging_prefix}"
        BUILD_COMMAND   $(MAKE) -s V=0
        INSTALL_COMMAND $(MAKE) -s V=0 DESTDIR=${staging_prefix} install
        CONFIGURE_COMMAND  ./configure --enable-silent-rules --silent ${FFTW3F_CONFIG} --libdir=${install_prefix}/lib${LIB_SUFFIX}  --prefix=${install_prefix} "CC=${EXT_C_COMPILER}" "CXX=${EXT_CXX_COMPILER}" "CXXFLAGS=${EXT_CXX_FLAGS}" "CFLAGS=${EXT_C_FLAGS}"
#        INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/external
      )

      
SET(FFTW3F_INCLUDE_DIR      ${install_prefix}/include )
SET(FFTW3F_LIBRARY          ${install_prefix}/lib${LIB_SUFFIX}/libfftw3f.a )
SET(FFTW3F_THREADS_LIBRARY  ${install_prefix}/lib${LIB_SUFFIX}/libfftw3f_threads.a )
SET(FFTW3F_OMP_LIBRARY      ${install_prefix}/lib${LIB_SUFFIX}/libfftw3f_omp.a )
configure_file(${CMAKE_SOURCE_DIR}/cmake-modules/FFTW3FConfig.cmake.in ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/FFTW3FConfig.cmake @ONLY)

      
SET(FFTW3F_INCLUDE_DIR      ${staging_prefix}/${install_prefix}/include )
SET(FFTW3F_LIBRARY          ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libfftw3f.a )
SET(FFTW3F_THREADS_LIBRARY  ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libfftw3f_threads.a )
SET(FFTW3F_OMP_LIBRARY      ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libfftw3f_omp.a )


SET(FFTW3F_FOUND ON)


endmacro(build_fftw3f)
