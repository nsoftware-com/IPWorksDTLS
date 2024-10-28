#
# IPWorks DTLS 2024 C++ Edition - Sample Project
#
# This sample project demonstrates the usage of IPWorks DTLS in a 
# simple, straightforward way. It is not intended to be a complete 
# application. Error handling and other checks are simplified for clarity.
#
# www.nsoftware.com/ipworksdtls
#
# This code is subject to the terms and conditions specified in the 
# corresponding product license agreement which outlines the authorized 
# usage and restrictions.
#

ifeq ($(shell uname -s), Darwin) # MACOS
R_PATH=-Wl,-rpath,../../lib64/,-rpath,.

FRAMEWORK = -framework Carbon -framework Security
LD_FLAGS = -lipworksdtls.24.0 -L../../lib64/ -lresolv
LD_FLAGS_SRC = -lz -lresolv
OS_CFLAGS = -D UNIX -arch arm64
MACOS = "darwin% Darwin% macos%"

all:
	g++ $(OS_CFLAGS) -D UNIX -o dtlsserver dtlsserver.cpp  -I../../include/ $(LD_FLAGS) $(FRAMEWORK) $(R_PATH)

src: ../../src/ipworksdtls.o
	g++ $(OS_CFLAGS) -o dtlsserver ../../src/ipworksdtls.o dtlsserver.cpp  $(LD_FLAGS_SRC) $(FRAMEWORK)

../../src/ipworksdtls.o:
	g++ -c -fno-exceptions -fno-rtti -fPIC -arch arm64 -o ../../src/ipworksdtls.o ../../src/ipworksdtls.cpp

else # LINUX
CPU=$(shell uname -m)
# Assumed that a product is always built for Windows-x64 platform
ifeq ($(CPU), $(filter $(CPU), i386 i686))
  LIB=lib
endif
ifeq ($(LIB),)
  LIB=lib64
endif

R_PATH=-Wl,-rpath,../../$(LIB)/,-rpath,.
LD_FLAGS = -lipworksdtls  -L../../$(LIB)/ 
LD_FLAGS_SRC = -lz 

all:
	g++ -D UNIX  -o dtlsserver dtlsserver.cpp  -I../../include/ $(LD_FLAGS) $(R_PATH)

src: ../../src/ipworksdtls.o
	g++ -D UNIX -o dtlsserver ../../src/ipworksdtls.o dtlsserver.cpp  -I../../include/ $(LD_FLAGS_SRC)

../../src/ipworksdtls.o:
	g++ -c -fno-exceptions -fno-rtti -fPIC -o ../../src/ipworksdtls.o ../../src/ipworksdtls.cpp

clean:
	rm -f ../../src/*.o
	rm -f dtlsserver *.o
endif