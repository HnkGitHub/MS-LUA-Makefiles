# Makefile for Microsoft Visual C: tested to work on VC++ 6.0 and up
CC = cl
LINK = link
LIBR = lib

# Check your compiler's options for valid values for your CPU. 
# Default value is SSE2. AVX or AVX2 available with recent
# compilers. VC++ 6.0 can use the Pentium Pro /G6 optimization.
# Define ARCH=Pro for VC6

!ifndef ARCH
ARCH = SSE2
!endif

!if "$(ARCH)" == "Pro"
CFLAGS = /G6 /O2 /nologo
LFLAGS = /MACHINE:X86 /SUBSYSTEM:CONSOLE /RELEASE /NOLOGO 
LB_FLAGS = /MACHINE:X86 /NOLOGO
!else
CFLAGS = /GL /MP4 /arch:$(ARCH) /Ox /nologo
LFLAGS = /LTCG:STATUS /MACHINE:X86 /SUBSYSTEM:CONSOLE /RELEASE /NOLOGO 
LB_FLAGS = /LTCG:STATUS /MACHINE:X86 /NOLOGO
!endif

SOURCE = src
TARGET = VC

BASE_OBJS = $(TARGET)\lapi.obj $(TARGET)\lcode.obj $(TARGET)\lctype.obj $(TARGET)\ldebug.obj $(TARGET)\ldo.obj \
	    $(TARGET)\ldump.obj $(TARGET)\lfunc.obj $(TARGET)\lgc.obj $(TARGET)\llex.obj \
	    $(TARGET)\lmem.obj $(TARGET)\lobject.obj $(TARGET)\lopcodes.obj $(TARGET)\lparser.obj \
	    $(TARGET)\lstate.obj $(TARGET)\lstring.obj $(TARGET)\ltable.obj $(TARGET)\ltm.obj \
	    $(TARGET)\lundump.obj $(TARGET)\lvm.obj $(TARGET)\lzio.obj $(TARGET)\lauxlib.obj \
	    $(TARGET)\lbaselib.obj $(TARGET)\lbitlib.obj $(TARGET)\lcorolib.obj \
	    $(TARGET)\ldblib.obj $(TARGET)\liolib.obj $(TARGET)\lmathlib.obj $(TARGET)\loslib.obj \
	    $(TARGET)\lstrlib.obj $(TARGET)\ltablib.obj $(TARGET)\lutf8lib.obj $(TARGET)\loadlib.obj \
	    $(TARGET)\linit.obj

	

all : $(TARGET)\lua.exe $(TARGET)\luac.exe

!if "$(STATIC)" == "yes"
$(TARGET)\lua.exe : $(TARGET)\base.lib $(TARGET)\lua.obj
	$(LINK) $(LFLAGS) /OUT:$(TARGET)\lua.exe $(TARGET)\lua.obj $(TARGET)\base.lib 
!else
$(TARGET)\lua.exe : $(TARGET)\lua53.dll $(TARGET)\lua.obj
	$(LINK) $(LFLAGS) /OUT:$(TARGET)\lua.exe $(TARGET)\lua.obj $(TARGET)\lua53.lib
!endif

$(TARGET)\lua53.dll : $(BASE_OBJS) 
	$(LINK) $(LFLAGS) /DLL /DEF:$(TARGET)\lua53.def /OUT:$(TARGET)\lua53.dll $(BASE_OBJS) 
 
$(TARGET)\luac.exe : $(TARGET)\base.lib $(TARGET)\luac.obj
	$(LINK) $(LFLAGS) /OUT:$(TARGET)\luac.exe $(TARGET)\luac.obj $(TARGET)\base.lib

$(TARGET)\base.lib : $(BASE_OBJS)
	$(LIBR) $(LB_FLAGS) /OUT:$(TARGET)\base.lib $(BASE_OBJS)


clean :
	del $(BASE_OBJS)
	del $(TARGET)\lua.obj
	del $(TARGET)\luac.obj

allclean : clean
	del $(TARGET)\*.exe
	del $(TARGET)\*.lib
	del $(TARGET)\lua53.dll
	del $(TARGET)\lua53.exp

.SUFFIXES : 

.SUFFIXES : .c .obj .exe

{$(SOURCE)}.c{$(TARGET)}.obj ::
	$(CC) $(CFLAGS) /c /Fo$(TARGET)\ $<
