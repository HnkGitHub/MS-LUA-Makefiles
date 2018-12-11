# MS-LUA-Makefiles
MSVC Makefile and definition files, Borland Makefile and Definition Files to build Lua.

These files will allow you to build Lua using Microsoft Visual C++ or Borland/Embarcadero Compilers. Read the Makefiles
for further information and help on how to setup your Lua Source Directory and set compiler options. You should need at least cl.exe version 15.00.xxxxx.xx to build version 5.4. Current versions--7.x or later--of Embarcadero's C compilers should build either a DLL or a static build of lua.exe. 

Edit the Makefiles to reflect your compiler for x86, AMD64, or IA64. Yes, you can build an Itanium Architecture EXE for Lua!

Lua recommends a DLL build for the lua.exe and a static build for the luac.exe (lua compiler) on Windows platforms. However, read the Makefile and set the proper macro to build a Static build. A DLL will be built by default if STATIC is not set on the command line with the Borland Make or the MS nmake program.

     nmake /f Make_mvc.mak STATIC=yes, or make /f Make_blnd.mak -DSTATIC=yes

Attention! Please note that the lua.c or one of its header files needs to be hacked to allow the Borland build to work. Read the
Borland makefile for instructions and the hack.

Place the lua54.def files in the VC and Bor directories. These definition files are not interchangeable: one is mangled. Rename
the lua54.def.bor to lua54.def and copy it to the Bor directory. The makefiles are setup to not bother the Lua/src 
directory. You should have a Lua/Bor and a Lua/MSVC directory. Executable files, the lua54.dll
file, and the lib files will be in either the Bor or MSVC directory after a successful build depending on the compiler you choose and the type of build, static or dynamic.

If the directory structure is setup properly and the correct def file is copied into the correct directory, everything should compile. Again, read the Makefiles themselves for further tips before compiling to set the correct optimizations for your CPU.
