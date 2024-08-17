include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

function(check_and_add_flag var flag)
  set(config_test "1")

  # Handle configuration flags
  if(ARGV2 STREQUAL "DEBUG_ONLY")
    set(config_test "$<CONFIG:Debug>")
  elseif(ARGV2 STREQUAL "NO_DEBINFO_ONLY")
    set(config_test "$<NOT:$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>>")
  elseif(ARGV2 STREQUAL "RELEASE_ONLY")
    set(config_test "$<NOT:$<CONFIG:Debug>>")
  elseif(ARGV2)
    message(FATAL_ERROR "check_and_add_flag called with incorrect arguments: ${ARGN}")
  endif()

  # Initialize flags for C and C++
  set(is_c "$<COMPILE_LANGUAGE:C>")
  set(is_cxx "$<COMPILE_LANGUAGE:CXX>")
  set(test_flags_c "-Werror ")
  set(test_flags_cxx "-Werror ")

  # Special handling for Visual Studio generators
  if(CMAKE_GENERATOR MATCHES "Visual Studio")
    set(is_c "0")
    set(is_cxx "1")
  endif()

  # Check and add flags for C and C++
  check_c_compiler_flag("${test_flags_c}${flag}" FLAG_C_${var})
  if(FLAG_C_${var})
    add_compile_options("$<$<AND:${is_c},${config_test}>:${flag}>")
  endif()

  check_cxx_compiler_flag("${test_flags_cxx}${flag}" FLAG_CXX_${var})
  if(FLAG_CXX_${var})
    add_compile_options("$<$<AND:${is_cxx},${config_test}>:${flag}>")
  endif()
endfunction()
