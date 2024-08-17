find_program(CCACHE_BIN NAMES ccache sccache)

if(CCACHE_BIN)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_BIN})

    # Handle Clang specific flags
    if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        list(APPEND CMAKE_CXX_FLAGS -Qunused-arguments -fcolor-diagnostics)
        list(APPEND CMAKE_C_FLAGS -Qunused-arguments -fcolor-diagnostics)
    endif()
endif()
