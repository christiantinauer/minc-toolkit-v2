macro(build_netcdf install_prefix staging_prefix)

  SET(NETCDF_TESTS OFF)
  
  if(CMAKE_EXTRA_GENERATOR)
    set(CMAKE_GEN "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
  else()
    set(CMAKE_GEN "${CMAKE_GENERATOR}")
  endif()

  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT:STRING=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
    )
  endif()

  ExternalProject_Add(NETCDF 
    URL "ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.3.3.1.tar.gz"
    URL_MD5 "5c9dad3705a3408d27f696e5b31fb88c"
  SOURCE_DIR NETCDF
  BINARY_DIR NETCDF-build
  LIST_SEPARATOR :::
  CMAKE_GENERATOR ${CMAKE_GEN}
  CMAKE_ARGS
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DBUILD_SHARED_LIBS:BOOL=${NETCDF_TESTS}
      -DBUILD_TESTING:BOOL=${NETCDF_TESTS}
      -DBUILD_TESTSETS:BOOL=${NETCDF_TESTS}
      -DENABLE_TESTS:BOOL=${NETCDF_TESTS}
      -DENABLE_V2_API:BOOL=ON
      -DNC_ENABLE_HDF_16_API:BOOL=OFF
      -DUSE_HDF5:BOOL=OFF
      -DUSE_NETCDF4:BOOL=OFF
      -DCMAKE_SKIP_RPATH:BOOL=OFF
      -DENABLE_DAP:BOOL=OFF
      -DENABLE_LARGE_FILE_SUPPORT:BOOL=ON
      -DCMAKE_SKIP_INSTALL_RPATH:BOOL=OFF
      -DENABLE_NETCDF4:BOOL=OFF
      -DENABLE_NETCDF_4:BOOL=OFF
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
      ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
      "-DCMAKE_CXX_FLAGS:STRING=-fPIC ${CMAKE_CXX_FLAGS}"
      "-DCMAKE_C_FLAGS:STRING=-fPIC ${CMAKE_C_FLAGS}"
      -DCMAKE_EXE_LINKER_FLAGS:STRING=${CMAKE_EXE_LINKER_FLAGS}
      -DCMAKE_MODULE_LINKER_FLAGS:STRING=${CMAKE_MODULE_LINKER_FLAGS}
      -DCMAKE_SHARED_LINKER_FLAGS:STRING=${CMAKE_SHARED_LINKER_FLAGS}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_INSTALL_LIBDIR:PATH=${install_prefix}/lib${LIB_SUFFIX} # DISABLING Multiarch support for now ?
  INSTALL_COMMAND $(MAKE) install DESTDIR=${staging_prefix}
  INSTALL_DIR ${staging_prefix}/${install_prefix}
  )

  SET(NETCDF_LIBRARY     ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libnetcdf.a )
  SET(NETCDF_INCLUDE_DIR ${staging_prefix}/${install_prefix}/include )
  SET(NETCDF_FOUND ON)




endmacro(build_netcdf)
