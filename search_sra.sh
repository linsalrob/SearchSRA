#!/bin/bash

IFS=$'\n'

# this script will install the software to run a search against 
# jetstream, and start the search running in detached mode.

# URL is the URL where we get all the pieces and parts from. Each of the files used here will be pulled from that URL
# you don't need the terminal /
URL='' ## ENTER YOUR URL HERE


# the sole argument is the file name for the list of SRR ids to search. This will be collected from URL
# so just use the base name

if [ -z $URL ];
then
	echo -e "FATAL ERROR: Please edit the script `basename $0` and add the URL where we can find all the files at line 10";
	exit $E_BADARGS
fi



if [ ! -n "$1" ] || [ ! -n "$2" ]
then
	echo -e "Usage: `basename $0` <query file name> <file with list of ids>\n(Note: the file should be located at $URL)";
	exit $E_BADARGS
fi
		
# get the file of DNA sequences to search
wget $URL/$1
bowtie2-build $1 query

# and the list of SRR IDs
wget $URL/$2
if [ ! -e $2 ]; then
	echo "WE DID NOT FIND \"$2\" LOCALLY"
	exit $E_BADARGS
fi


if [ ! -e query.1.bt2 ]; then 
	echo "WE DID NOT FIND THE BOWTIE INDEX \"query.1.bt2\" LOCALLY"
	exit $E_BADARGS
fi

if [ ! -e compare2sra.sh ]; then
	echo "WE DID NOT FIND \"compare2sra.sh\" LOCALLY"
	exit $E_BADARGS
fi

echo "STARTING THE SEARCH IN A DETACHED SCREEN"
screen -d -m $HOME/compare2sra.sh query $2





