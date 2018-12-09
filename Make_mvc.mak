# ====================================================================
# Makefile for MSVC compilers for Lua54
# Check your cl /? options for applicable options for ARCH and OPTIM
# Set CPUTYPE for either X86 or X64
# cl Version should be at least 15.00.xxxxx.xx
# ---------------------------------------------------------------------

CC = cl
LINK = link
LIBR = lib

!ifndef STATIC
STATIC = no
!endif

# set OPTIM="/[O2,Ox,..]" on command line: e.g., nmake /f Make_mvc.mak OPTIM="/O2"
# Flexible so you can define as you wish.
# example:  nmake /f Make_mvc.mak OPTIM="/Ox /favor:AMD64" 
!ifndef OPTIM
OPTIM=
!endif

# set this your to compiler's target architecture; e.g. X86  X64 IA64?
# Linking will fail, if not set correctly!
!ifndef CPUTYPE
CPUTYPE=X86
!endif

# set ARCH="/arch:[SSE|SSE2|AVX|AVX2]" -- choose your supported flavor: /arch:SSE , etc. ..
# Set for the FPU instructions supported for maximum performance in math calculations.
!ifndef ARCH
ARCH=
!endif

CFLAGS = $(OPTIM) $(ARCH) /GL 
LFLAGS = /RELEASE /nologo /SUBSYSTEM:CONSOLE /MACHINE:$(CPUTYPE) /LTCG:STATUS  
LBFLAGS = /MACHINE:$(CPUTYPE) /NOLOGO /SUBSYSTEM:CONSOLE
SOURCE = .
TRGT = MSVC

BASE_OBJS = $(TRGT)\lapi.obj $(TRGT)\lcode.obj $(TRGT)\lctype.obj $(TRGT)\ldebug.obj \
	$(TRGT)\ldo.obj $(TRGT)\ldump.obj $(TRGT)\lfunc.obj $(TRGT)\lgc.obj \
	$(TRGT)\llex.obj $(TRGT)\lmem.obj $(TRGT)\lobject.obj $(TRGT)\lopcodes.obj \
	$(TRGT)\lparser.obj $(TRGT)\lstate.obj $(TRGT)\lstring.obj $(TRGT)\ltable.obj \
	$(TRGT)\ltm.obj  $(TRGT)\lundump.obj $(TRGT)\lvm.obj $(TRGT)\lzio.obj \
	$(TRGT)\lauxlib.obj $(TRGT)\lbaselib.obj $(TRGT)\lcorolib.obj \
	$(TRGT)\ldblib.obj $(TRGT)\liolib.obj $(TRGT)\lmathlib.obj $(TRGT)\loslib.obj \
	$(TRGT)\lstrlib.obj $(TRGT)\ltablib.obj $(TRGT)\lutf8lib.obj $(TRGT)\loadlib.obj \
	$(TRGT)\linit.obj

all : $(TRGT)\lua.exe $(TRGT)\lua.obj
!if "$(STATIC)" == "yes"
$(TRGT)\lua.exe : $(TRGT)\base.lib $(TRGT)\lua.obj 
	$(LINK) $(LFLAGS) /OUT:$(TRGT)\lua.exe $(TRGT)\lua $(BASE_OBJS) $(TRGT)\base.lib
!else
$(TRGT)\lua.exe : $(TRGT)\lua54.dll $(TRGT)\lua.obj 
	$(LINK) $(LFLAGS) /OUT:$(TRGT)\lua.exe $(TRGT)\lua.obj $(TRGT)\lua54.lib 
!endif

$(TRGT)\base.lib : $(BASE_OBJS)
	$(LIBR)  /OUT:$(TRGT)\base.lib  $(TRGT)\lapi.obj $(TRGT)\lcode.obj $(TRGT)\lctype.obj $(TRGT)\ldebug.obj \
	$(TRGT)\ldo.obj $(TRGT)\ldump.obj $(TRGT)\lfunc.obj $(TRGT)\lgc.obj \
	$(TRGT)\llex.obj $(TRGT)\lmem.obj $(TRGT)\lobject.obj $(TRGT)\lopcodes.obj \
	$(TRGT)\lparser.obj $(TRGT)\lstate.obj $(TRGT)\lstring.obj $(TRGT)\ltable.obj \
	$(TRGT)\ltm.obj $(TRGT)\lundump.obj $(TRGT)\lvm.obj $(TRGT)\lzio.obj \
	$(TRGT)\lauxlib.obj $(TRGT)\lbaselib.obj $(TRGT)\lcorolib.obj \
	$(TRGT)\ldblib.obj $(TRGT)\liolib.obj $(TRGT)\lmathlib.obj $(TRGT)\loslib.obj \
	$(TRGT)\lstrlib.obj $(TRGT)\ltablib.obj $(TRGT)\lutf8lib.obj $(TRGT)\loadlib.obj \
	$(TRGT)\linit.obj

$(TRGT)\lua54.dll : $(BASE_OBJS)
	$(LINK) $(LFLAGS) /DLL /OUT:$(TRGT)\lua54.dll /DEF:$(TRGT)\lua54.def $(BASE_OBJS) 

clean :
	del $(BASE_OBJS)
	if exist $(TRGT)\base.lib del $(TRGT)\base.lib
	if exist $(TRGT)\lua54.lib del $(TRGT)\lua54.lib
	if exist $(TRGT)\lua54.dll del $(TRGT)\lua54.dll
	if exist $(TRGT)\lua.obj del $(TRGT)\lua.obj
	if exist $(TRGT)\lua.exe del $(TRGT)\lua.exe

install :
	if not exist c:\lua54\bin mkdir c:\lua54\bin
	if not exist c:\lua54\include mkdir c:\lua54\include 
	if not exist c:\lua54\man mkdir c:\lua54\man
	if not exist c:\lua54\lib mkdir c:\lua54\lib 
	if exist msvc\lua.exe copy msvc\lua.exe c:\lua54\bin
	if exist msvc\lua54.dll copy msvc\lua54.dll c:\lua54\bin
	if exist msvc\lua54.lib copy msvc\lua54.lib c:\lua54\lib

uninstall :
	if exist c:\lua54\bin del c:\lua54\bin\lua.exe
	if exist c:\lua54\bin\lua54.dll del c:\lua54\bin\lua54.dll
	if exist c:\lua54\lib\lua54.lib del c:\lua54\lib\lua54.lib

.SUFFIXES : .c .obj .exe

{$(SOURCE)}.c{$(TRGT)}.obj ::
	$(CC) $(CFLAGS) /c /Fo$(TRGT)\ $<
