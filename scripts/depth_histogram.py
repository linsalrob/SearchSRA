"""
Create a histogram of max read depths
"""

import os
import sys
import argparse
from roblib import bcolors
__author__ = 'Rob Edwards'





if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='create a histogram of max read depths')
    parser.add_argument('-d', help='directory of tab separated files', required=True)
    parser.add_argument('-o', help='output file to write')
    parser.add_argument('-v', help='verbose output', action='store_true')
    args = parser.parse_args()

    count = {}
    for f in os.listdir(args.d):
        maxv = 0
        with open(os.path.join(args.d, f), 'r') as i:
            for l in i:
                p=l.strip().split("\t")
                if int(p[2]) > maxv:
                    maxv = int(p[2])
        count[maxv] = count.get(maxv, 0)+1

    with open(args.o, 'w') as out:
        for c in sorted(count.keys()):
            out.write(f"{c}\t{count[c]}\n")



