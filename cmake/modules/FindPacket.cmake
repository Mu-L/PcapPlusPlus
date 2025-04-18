# ~~~
# Copyright (C) 2017 Ali Abdulkadir <autostart.ini@gmail.com>.
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sub-license, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# FindPacket
# ==========
#
# Find the Packet library and include files.
#
# This module defines the following variables:
#
# Packet_INCLUDE_DIR     - absolute path to the directory containing Packet32.h.
#
# Packet_LIBRARY         - relative or absolute path to the Packet library to
#                          link with. An absolute path is will be used if the
#                          Packet library is not located in the compiler's
#                          default search path.
#
# Packet_FOUND           - TRUE if the Packet library *and* header are found.
#
# Hints and Backward Compatibility
# ================================
#
# To tell this module where to look, a user may set the environment variable Packet_ROOT to point cmake to the *root* of
# a directory with include and lib subdirectories for packet.dll (e.g WpdPack or npcap-sdk). Alternatively, Packet_ROOT
# may also be set from cmake command line or GUI (e.g cmake -DPacket_ROOT=C:\path\to\packet [...])
# ~~~

# The 64-bit Packet.lib is located under /x64
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  #
  # For the WinPcap and Npcap SDKs, the Lib subdirectory of the top-level directory contains 32-bit libraries; the
  # 64-bit libraries are in the Lib/x64 directory.
  #
  # The only way to *FORCE* CMake to look in the Lib/x64 directory without searching in the Lib directory first appears
  # to be to set CMAKE_LIBRARY_ARCHITECTURE to "x64".
  #
  set(CMAKE_LIBRARY_ARCHITECTURE "x64")
endif()

# Find the header
find_path(Packet_INCLUDE_DIR Packet32.h PATH_SUFFIXES include Include)

# Find the library
find_library(Packet_LIBRARY NAMES Packet packet NAMES_PER_DIR)

# Set Packet_FOUND to TRUE if Packet_INCLUDE_DIR and Packet_LIBRARY are TRUE.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Packet DEFAULT_MSG Packet_LIBRARY Packet_INCLUDE_DIR)

# create IMPORTED target for libpcap dependency
if(NOT TARGET Packet::Packet)
  add_library(Packet::Packet IMPORTED SHARED)
  set_target_properties(
    Packet::Packet
    PROPERTIES
      IMPORTED_LOCATION ${Packet_LIBRARY}
      IMPORTED_IMPLIB ${Packet_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${Packet_INCLUDE_DIR}
  )
endif()

mark_as_advanced(Packet_INCLUDE_DIR Packet_LIBRARY)
