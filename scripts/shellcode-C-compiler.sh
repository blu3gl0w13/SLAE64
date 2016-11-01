#!/bin/bash

gcc -ggdb -fno-stack-protector -z execstack $1.c -o $1
