# ###############################################################
# Borland Makefile: Works with Borland C++ 5.5.1 or greater 	#
# STATIC Builds work with 5.5.1, not Dynamic. Dynamic (DLL)		#
# builds work with Embarcadero 7.3. Make sure that lua53.def    #
# exists in the BOR directory. Make the BOR directory, if it	#
# does not exist.												#
# Borland C++ 5.3 will build a Dynamic version :)				#
# Set STATIC=yes when using Borland C++ 5.5.1; i.e., 			#
# 																#
#        make -DSTATIC=yes										#
# 																#
# However, with all Borland compilers tested, you should hack	#
# the file lua.c or one											#
# of its headers so that _isatty is defined as follows before	#
# it is called in lua.c:										#
# 	#ifdef __BORLANDC__											#
# 	#define _isatty isatty										#
# 	#endif 														#
#																#
#	CC can be set with bcc32 									#
#	or as bcc32c, the CLanguage compiler with Embarcader >=7.3	#
#################################################################
CC = bcc32
LINK = ilink32
LIBR = tlib 

CFLAGS = -6 -O2 
LFLAGS =  -c  

SRC = src
TRGT = BOR

BASE_OBJS = $(TRGT)\lapi.obj $(TRGT)\lcode.obj $(TRGT)\lctype.obj $(TRGT)\ldebug.obj \
	$(TRGT)\ldo.obj $(TRGT)\ldump.obj $(TRGT)\lfunc.obj $(TRGT)\lgc.obj \
	$(TRGT)\llex.obj $(TRGT)\lmem.obj $(TRGT)\lobject.obj $(TRGT)\lopcodes.obj \
	$(TRGT)\lparser.obj $(TRGT)\lstate.obj $(TRGT)\lstring.obj $(TRGT)\ltable.obj \
	$(TRGT)\ltm.obj  $(TRGT)\lundump.obj $(TRGT)\lvm.obj $(TRGT)\lzio.obj \
	$(TRGT)\lauxlib.obj $(TRGT)\lbaselib.obj $(TRGT)\lbitlib.obj $(TRGT)\lcorolib.obj \
	$(TRGT)\ldblib.obj $(TRGT)\liolib.obj $(TRGT)\lmathlib.obj $(TRGT)\loslib.obj \
	$(TRGT)\lstrlib.obj $(TRGT)\ltablib.obj $(TRGT)\lutf8lib.obj $(TRGT)\loadlib.obj \
	$(TRGT)\linit.obj
 
all : $(TRGT)\lua.exe $(TRGT)\luac.exe

!if ("$(STATIC)"=="yes")
$(TRGT)\lua.exe : $(TRGT)\base.lib $(TRGT)\lua.obj
	$(LINK) $(LFLAGS) -Tpe -ap c0x32 $(TRGT)\lua,$(TRGT)\lua,$(TRGT)\,cw32 import32 $(TRGT)\base.lib
!else
$(TRGT)\lua.exe : $(TRGT)\lua53.dll $(TRGT)\lua.obj
	$(LINK) $(LFLAGS) c0x32 $(TRGT)\lua,$(TRGT)\lua,$(TRGT)\,cw32 import32 $(TRGT)\lua53
!endif

$(TRGT)\luac.exe : $(TRGT)\base.lib $(TRGT)\luac.obj
	$(LINK) $(LFLAGS) -Tpe -ap c0x32 $(TRGT)\luac,$(TRGT)\luac,$(TRGT)\,cw32 import32 $(TRGT)\base.lib

$(TRGT)\base.lib : $(BASE_OBJS)
	$(LIBR) /C $(TRGT)\base.lib /u $(BASE_OBJS)

$(TRGT)\lua53.dll : $(BASE_OBJS) 
	$(LINK) $(LFLAGS) -Tpd -ap -Gi c0d32 $(BASE_OBJS),$(TRGT)\lua53,$(TRGT)\,cw32mt import32,$(TRGT)\lua53

clean :
	del $(BASE_OBJS) 
	del $(TRGT)\*.i??
	del $(TRGT)\lua.obj
	del $(TRGT)\luac.obj

allclean : clean
	del $(TRGT)\*.exe
	del $(TRGT)\*.lib
	del $(TRGT)\lua53.dll

{$(SRC)}.c{$(TRGT)}.obj :
	$(CC) $(CFLAGS) -n$(TRGT) -c $<
