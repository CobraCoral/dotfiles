#!/usr/bin/env python3

'''
https://unicode-table.com/en/sets/
'''
import unicodedata as ucd
import sys

def dump_encoding(enc):
    for i in range(sys.maxunicode):
        u = chr(i)
        try:
            s = u.encode(enc)
        except UnicodeEncodeError:
            continue
        try:
            name = ucd.name(u)
        except:
            name = '?'
        print('U+%08X %25r %80s ==> %s'%(i, s, name, u))

if __name__ == "__main__":
    dump_encoding('utf-8')
