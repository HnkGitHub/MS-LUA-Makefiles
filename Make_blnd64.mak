# Make_blnd64.mak = 64 bit Makefile for Embarcadero C++ 
# Tested on Embarcadero C++ 7.30 
# Static and Shared DLL builds are possible.
# Lua recommends a DLL build for lua.exe (default).
# If you desire a static build, define STATIC on the 
# command line:
# 	make /f Make_blnd64.mak -DSTATIC=yes
#
#  Make sure the file lua54.def in BOR64 is present to build a dll.
#  For STATIC builds, the lua54.def file is not necessary.
#
CC = bcc64
LINK = ilink64
LIBR = tlib64

# Set the target. If not set on the command line, native is 
# set as default.
#
!ifndef CPUNR
CPUNR = native
!endif

# all CFLAGS options here are optional. Delete or change to
# suit your preferences.
#  Default CFLAGS are set for current CPUs which will
#  support 4 threads (--jobs=4), posix threads, and a native target
#
CFLAGS = --jobs=4 -pthread -target $(CPUNR)
LFLAGS = -c  -r -Gz
LBR_FLAGS = /a /C
TRGT = BOR64
SRC = .

BASE_OBJS = $(TRGT)\lapi.o $(TRGT)\lcode.o $(TRGT)\lctype.o $(TRGT)\ldebug.o \
	$(TRGT)\ldo.o $(TRGT)\ldump.o $(TRGT)\lfunc.o $(TRGT)\lgc.o \
	$(TRGT)\llex.o $(TRGT)\lmem.o $(TRGT)\lobject.o $(TRGT)\lopcodes.o \
	$(TRGT)\lparser.o $(TRGT)\lstate.o $(TRGT)\lstring.o $(TRGT)\ltable.o \
	$(TRGT)\ltm.o  $(TRGT)\lundump.o $(TRGT)\lvm.o $(TRGT)\lzio.o \
	$(TRGT)\lauxlib.o $(TRGT)\lbaselib.o $(TRGT)\lcorolib.o \
	$(TRGT)\ldblib.o $(TRGT)\liolib.o $(TRGT)\lmathlib.o $(TRGT)\loslib.o \
	$(TRGT)\lstrlib.o $(TRGT)\ltablib.o $(TRGT)\lutf8lib.o $(TRGT)\loadlib.o \
	$(TRGT)\linit.o

all : $(TRGT)\lua.exe 

!if "$(STATIC)"=="yes"
$(TRGT)\lua.exe : $(TRGT)\base.lib $(TRGT)\lua.o
	$(LINK) $(LFLAGS) -Tpe -ap c0x64 $(TRGT)\lua.o,$(TRGT)\lua,,cw64 import64 $(TRGT)\base.a
!else
$(TRGT)\lua.exe : $(TRGT)\lua54.dll $(TRGT)\lua.o
	$(LINK) $(LFLAGS) -Tpe -ap c0x64 $(TRGT)\lua.o,$(TRGT)\lua,,cw64 import64 $(TRGT)\lua54.a
!endif

$(TRGT)\base.lib : $(BASE_OBJS)
	$(LIBR) $(LBR_FLAGS) $(TRGT)\base.a $(BASE_OBJS) 

$(TRGT)\lua54.dll :: $(BASE_OBJS)
	@if not exist BOR64 @mkdir BOR64
	@if exist $(TRGT)\lua54.def @echo lua54.def is present and ready
	@if not exist $(TRGT)\lua54.def @echo Dll build fails. Download and place lua54.def in BOR64 directory
	$(LINK) $(LFLAGS) -Tpd -aa -c -Gi c0d64 $(BASE_OBJS),$(TRGT)\lua54.dll,,cw64mt import64,$(TRGT)\lua54.def

clean :
	del $(BASE_OBJS)
	del $(TRGT)\*.i??
	del $(TRGT)\base.a
	del $(TRGT)\lua54.a
	del $(TRGT)\lua54.dll
	del $(TRGT)\lua.exe

.SUFFIXES : .c .o .exe

{$(SRC)}.c{$(TRGT)}.o :
	$(CC) $(CFLAGS) -n$(TRGT)\ -c $<



