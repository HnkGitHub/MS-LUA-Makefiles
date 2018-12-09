# Use Embarcadero C 7.3 or greater to take advantage of GNU type CFLAGS!
# Tested on bcc32 ver. 7.30, bcc32 5.5.1
# Tested to build as STATIC or DYNAMIC: make /f Make_blnd.mak -DSTATIC=no
# Hack the lua.c sourcefile to enable the build as follows:
#     	#ifdef __BORLANDC__
#	#define _isatty isatty
#	#endif 
#    (insert the above 3 lines at around line 22 after "#include "lualib.h"
#
CC = bcc32
LINK = ilink32

# Notice the CFLAGS!
# Apparently, Embarcadero is using a GNU type C compiler. 
# So, Use Gnu type CFLAGS!
# Should effect the ASSEMBLY instructions for the CPU?
# Change the CFLAGS as you would for GNU gcc. 
# A warning will be emitted, if the flag is not supported.
!if $(__MAKE__) <= 0x520 	# Borland's 5.5.1 make
!message Make version $(__MAKE__)
CFLAGS = -6		 	# Pentium Pro!	
!elseif $(__MAKE__) >= 0x540 	# Embarcadero's 7.30 make version, 5.41
!message Make version $(__MAKE__)
CFLAGS = -march=native
!endif

!ifndef LFLAGS
LFLAGS = -c -r 
!endif

# DYNAMIC DLL Build as Default.
# Note DYNAMIC BUILD tested as not working on BCC32 5.5.1.
# It builds, but doesn't show any output. Something to do with isatty?
!ifndef STATIC
STATIC = no
!endif

SOURCE = .
TRGT = BOR

BASE_OBJS = $(TRGT)\lapi.obj $(TRGT)\lcode.obj $(TRGT)\lctype.obj $(TRGT)\ldebug.obj \
	$(TRGT)\ldo.obj $(TRGT)\ldump.obj $(TRGT)\lfunc.obj $(TRGT)\lgc.obj \
	$(TRGT)\llex.obj $(TRGT)\lmem.obj $(TRGT)\lobject.obj $(TRGT)\lopcodes.obj \
	$(TRGT)\lparser.obj $(TRGT)\lstate.obj $(TRGT)\lstring.obj $(TRGT)\ltable.obj \
	$(TRGT)\ltm.obj  $(TRGT)\lundump.obj $(TRGT)\lvm.obj $(TRGT)\lzio.obj \
	$(TRGT)\lauxlib.obj $(TRGT)\lbaselib.obj $(TRGT)\lcorolib.obj \
	$(TRGT)\ldblib.obj $(TRGT)\liolib.obj $(TRGT)\lmathlib.obj $(TRGT)\loslib.obj \
	$(TRGT)\lstrlib.obj $(TRGT)\ltablib.obj $(TRGT)\lutf8lib.obj $(TRGT)\loadlib.obj \
	$(TRGT)\linit.obj

all : lua.exe

!if "$(STATIC)"=="yes"
lua.exe : $(TRGT)\base.lib $(TRGT)\lua.obj 
	$(LINK) $(LFLAGS) -Tpe -ap c0x32 $(TRGT)\lua,$(TRGT)\lua,,cw32 import32 $(TRGT)\base.lib
!else
lua.exe : $(TRGT)\lua54.dll $(TRGT)\lua.obj 
	$(LINK) $(LFLAGS) -Tpe -ap c0x32 $(TRGT)\lua,$(TRGT)\lua,,cw32 import32 $(TRGT)\lua54.lib

!endif
$(TRGT)\base.lib : $(BASE_OBJS)
	tlib $(TRGT)\base /C +$(TRGT)\lapi.obj +$(TRGT)\lcode.obj +$(TRGT)\lctype.obj +$(TRGT)\ldebug.obj \
	+$(TRGT)\ldo.obj +$(TRGT)\ldump.obj +$(TRGT)\lfunc.obj +$(TRGT)\lgc.obj \
	+$(TRGT)\llex.obj +$(TRGT)\lmem.obj +$(TRGT)\lobject.obj +$(TRGT)\lopcodes.obj \
	+$(TRGT)\lparser.obj +$(TRGT)\lstate.obj +$(TRGT)\lstring.obj +$(TRGT)\ltable.obj \
	+$(TRGT)\ltm.obj +$(TRGT)\lundump.obj +$(TRGT)\lvm.obj +$(TRGT)\lzio.obj \
	+$(TRGT)\lauxlib.obj +$(TRGT)\lbaselib.obj +$(TRGT)\lcorolib.obj \
	+$(TRGT)\ldblib.obj +$(TRGT)\liolib.obj +$(TRGT)\lmathlib.obj +$(TRGT)\loslib.obj \
	+$(TRGT)\lstrlib.obj +$(TRGT)\ltablib.obj +$(TRGT)\lutf8lib.obj +$(TRGT)\loadlib.obj \
	+$(TRGT)\linit.obj

$(TRGT)\lua54.dll : $(BASE_OBJS)
	$(LINK) $(LFLAGS) -Tpd -aa -Gi c0d32 $(BASE_OBJS),$(TRGT)\lua54,,cw32mt import32,$(TRGT)\lua54.def

clean :
	del $(BASE_OBJS)
	del $(TRGT)\base.lib
	del $(TRGT)\lua.obj
	del $(TRGT)\*.i??
	if exist $(TRGT)\lua54.lib del $(TRGT)\lua54.lib
	if exist $(TRGT)\lua54.dll del $(TRGT)\lua54.dll
	del $(TRGT)\*.exe

{$(SOURCE)}.c{$(TRGT)}.obj :
	$(CC) $(CFLAGS) -c -o$(TRGT)\$& $&.c
