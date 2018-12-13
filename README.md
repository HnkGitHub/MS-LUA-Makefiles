# MS-LUA-Makefiles
MSVC Makefile and definition files, Borland Makefile and Definition Files to build Lua: " a powerful, efficient, lightweight, embeddable scripting language. It supports procedural programming, object-oriented programming, functional programming, data-driven programming, and data description. (https://github.com/lua)" 

These files will allow you to build Lua using Microsoft Visual C++ or Borland/Embarcadero Compilers. Read the Makefiles
for further information and help on how to setup your Lua Source Directory and set compiler options. As early as 
Microsoft Visual C++ version 6.0 sp5 can build Lua ver. 5.3.5 in either a Dynamic (DLL) or Static build. 
If you have Borland C++ version 5.3, you can build a DLL version of Lua.exe However, the Make that comes with 5.3 did not work for me. Find a different make [use 5.5.1's make instead]. A DLL build Will not work with Borland C++ 5.5.1 (the free command line compiler). Later and current versions of Embarcadero's C compilers should build either a DLL or a static
build of lua.exe. Lua recommends a DLL build for the lua.exe and a static build for the luac.exe (lua compiler) on Windows platforms. However, read the Makefile and set the proper macro to build a Static build. A DLL will be built by default if 
STATIC is not set on the command line with the Borland Make or the MS nmake program.

     nmake /f Make_mvc.mak STATIC=yes, or make /f Make_brlnd.mak -DSTATIC=yes

Attention! Please note that the lua.c or one of its header files needs to be hacked to allow the Borland build to work. Read the
Borland makefile for instructions and the hack.

Place the lua53.def files in the VC and Bor directories. These definition files are not interchangeable: one is mangled. Rename
the lua53.def.bor to lua53.def and copy it to the Bor directory. The makefiles are setup to not bother the Lua-5.3.5/src 
directory. You should have a Lua-5.3.5/Bor and a Lua-5/3/5/VC directory. Executable files, the lua53.dll
file, and the lib files will be in either the Bor or Vc after a successful build depending on the compiler you choose.

If the directory structure is setup properly and the correct def file is copied into the correct directory, everything should compile. Again read the Makefiles themselves before compiling to set the correct optimization for your CPU.
