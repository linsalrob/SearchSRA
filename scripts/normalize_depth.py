"""
Read a tab-separated depth file and normalize the counts based on the
maximum value in the file
"""

import os
import sys
import argparse
from roblib import bcolors
__author__ = 'Rob Edwards'





if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='normalize depth counts to the maximum depth in the file')
    parser.add_argument('-d', help='direcoty of input tab separated depth file with [contig, posn, depth]', required=True)
    parser.add_argument('-m', help='minimum read depth to save results', required=True, type=int)
    parser.add_argument('-o', help='output file', required=True)
    parser.add_argument('-v', help='verbose output', action='store_true')
    args = parser.parse_args()

    if not os.path.exists(args.o):
        os.mkdir(args.o)

    for fi in os.listdir(args.d):
        # read the file and find the max
        data = []
        maxv = 0
        with open(os.path.join(args.d, fi), 'r') as f:
            for l in f:
                p = l.strip().split("\t")
                p[1] = int(p[1])
                p[2] = int(p[2])
                if p[2] > maxv:
                    maxv = p[2]
                data.append(p)

        if maxv < args.m:
            continue

        with open(os.path.join(args.o, fi), 'w') as out:
            for d in data:
                d[2] = 1.0 * d[2] / maxv
                out.write("\t".join(map(str, d)) + "\n")





