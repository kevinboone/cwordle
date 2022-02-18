# Makefile for cwordle 

# This is for building on Linux using Aztec C and a CP/M emulator
# Please note that the lack of organization of the source is a consequence
# of working with CP/M, which does not understand directories.
# 
# Kevin Boone, February 2022

# Set the path to the CP/M emulator. 
# Obtain it from here: https://github.com/jhallen/cpm
CPM=cpm
TARGET=cwordle.com
NAME=cwordle

# Set the path to the zipfile containing Aztec C 1.06d. Get this
# from https://www.aztecmuseum.ca/compilers.htm#cpm
AZTECZIP=~/Downloads/az80106d.zip

CFLAGS=-DCPM

all: $(TARGET) 

# Note: using a Makefile allows some control of which components need to be
#   compiled/assembled/linked. However, the CP/M emulator will not return 
#   an exit code to Linux that indicates whether a compile, etc., succeeded
#   or failed. If in doubt, do a "make clean" first -- the whole thing only
#   takes a few seconds to compile.

# Note: run "make prepare" to unpack the Aztec binaries from the download
#   bundle into the working directory. 

prepare:
	unzip -joq $(AZTECZIP) AZ80106D/BIN80/AS.COM
	unzip -joq $(AZTECZIP) AZ80106D/BIN80/CC.COM
	unzip -joq $(AZTECZIP) AZ80106D/BIN80/CC.MSG
	unzip -joq $(AZTECZIP) AZ80106D/BIN80/LN.COM
	unzip -joq $(AZTECZIP) AZ80106D/LIB/C.LIB
	unzip -joq $(AZTECZIP) AZ80106D/INCLUDE/STDIO.H
	unzip -joq $(AZTECZIP) AZ80106D/INCLUDE/FCNTL.H

_main.asm: main.c defs.h 
	$(CPM) CC $(CFLAGS) -DNAME=\"$(NAME)\" -o _main.asm main.c

main.o: _main.asm
	$(CPM) AS -o main.o _main.asm

_string.asm: string.c defs.h 
	$(CPM) CC $(CFLAGS) -DNAME=\"$(NAME)\" -o _string.asm string.c

string.o: _string.asm
	$(CPM) AS -o string.o _string.asm

conio.o: conio.asm
	$(CPM) AS -o conio.o conio.asm

rand.o: rand.asm
	$(CPM) AS -o rand.o rand.asm

$(TARGET): main.o conio.o rand.o string.o
	$(CPM) ln -o $(TARGET) rand.o main.o conio.o string.o c.lib

clean:
	rm -f $(TARGET) _*.asm *.o *.deps

unprepare:
	rm -f AS.COM LN.COM CC.COM CC.MSG *.LIB *.H


