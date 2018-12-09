CC = bcc32
LINK = ilink32

CFLAGS = -6 
LFLAGS = -c 

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

lua.exe : base.lib $(TRGT)\lua.obj 
	$(LINK) $(LFLAGS) -Tpe -aa c0x32 $(TRGT)\lua,$(TRGT)\lua,,cw32 import32 $(TRGT)\base.lib

base.lib : $(BASE_OBJS)
	tlib $(TRGT)\base /C +$(TRGT)\lapi.obj +$(TRGT)\lcode.obj +$(TRGT)\lctype.obj +$(TRGT)\ldebug.obj \
	+$(TRGT)\ldo.obj +$(TRGT)\ldump.obj +$(TRGT)\lfunc.obj +$(TRGT)\lgc.obj \
	+$(TRGT)\llex.obj +$(TRGT)\lmem.obj +$(TRGT)\lobject.obj +$(TRGT)\lopcodes.obj \
	+$(TRGT)\lparser.obj +$(TRGT)\lstate.obj +$(TRGT)\lstring.obj +$(TRGT)\ltable.obj \
	+$(TRGT)\ltm.obj +$(TRGT)\lundump.obj +$(TRGT)\lvm.obj +$(TRGT)\lzio.obj \
	+$(TRGT)\lauxlib.obj +$(TRGT)\lbaselib.obj +$(TRGT)\lcorolib.obj \
	+$(TRGT)\ldblib.obj +$(TRGT)\liolib.obj +$(TRGT)\lmathlib.obj +$(TRGT)\loslib.obj \
	+$(TRGT)\lstrlib.obj +$(TRGT)\ltablib.obj +$(TRGT)\lutf8lib.obj +$(TRGT)\loadlib.obj \
	+$(TRGT)\linit.obj

lua53.dll : $(BASE_OBJS)
	$(LINK) $(LFLAGS) -Tpd -aa -Gi c0d32 $(BASE_OBJS),$(TRGT)\lua53,,cw32mt import32,$(TRGT)\lua53.def

clean :
	del $(BASE_OBJS)
	del $(TRGT)\base.lib
	del $(TRGT)\lua.obj

{$(SOURCE)}.c{$(TRGT)}.obj :
	$(CC) $(CFLAGS) -c -o$(TRGT)\$& $&.c
