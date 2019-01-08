# Searching the SRA

We're using the [Jetstream cloud](https://use.jetstream-cloud.org/) to search the [Sequence Read Archive](https://www.ncbi.nlm.nih.gov/sra/). 

This repository contains some of the scripts that we use and introductions to get started. It is not a comprehensive repository as we are still in a pre-alpha development mode with the code. I'm looking forward to deleting this line at some point in the future.

## Citing this repository

You can access this repository at [Zeonodo](http://www.zenodo.org/) with DOI:10.5281/zenodo.1043562 [![DOI](https://www.zenodo.org/badge/90091634.svg)](https://www.zenodo.org/badge/latestdoi/90091634)


## Getting Started

Before you can start using this code you will need an [XSEDE](https://www.xsede.org/web/site/for-users/getting-started) account and an allocation that allows you to use JetStream. If you are interested in going down this road, shoot [Rob](https://edwards.sdsu.edu/research/) an email and he'll help you get going. 

Don't clone this repository until you get the allocation set up!


## Preparing the data

Before you start, you will need:

1. A fasta file with the sequences that you want to search. Mine is called `genomes.fasta`
2. A list of SRA IDs that you want to search against. This easiest way to get this is to grep for WGS in [SRA_Metagenome_Types.tsv](https://raw.githubusercontent.com/linsalrob/partie/master/SRA_Metagenome_Types.tsv) from [PARTIE](https://github.com/linsalrob/partie). Currently this list is ~67,429 SRA files. Note that for this code, we just want the ID, and not the WGS part, so you may need to use: `grep WGS SRA_Metagenome_Types.txt | cut -f 1` to get just the ids.
3. A website where you can house the data.
4. The setup.sh, compare2sra.sh, and search_sra.sh from here.

We start by splitting the SRA ids file into as many files as you have Jetstream instances. For example, if you have 67,429 lines in your file and 10 instances, I would use: `split -l 6743 -d sra.ids`. This will give you 10 files x00, x01, x02, ... x09. 

Put those files and the fasta file to search on a website somewhere and make sure that they are publicly available.

For example, [here is an example data set I searched](https://edwards.sdsu.edu/redwards/SRA/genome_search/). 

The reason that we do this is that each instance will download a file and process it.

Please edit the search_sra.sh script and add that URL at line 10.

## Getting started searching the SRA

Now we have the data we need to get our jetstream instances ready. 

First, you need one or more Jetstram instances. I usually fire up 10 or 12 instances. On my to do list is work with the Jetstream API to burst a bunch of images at once, but I typically do this using the web interface above.

Create a list of your IPs separated by spaces. I also reserve one IP to test everything out. Once it runs for that IP everything should be good to go. I have also had issues where I complete break the test machine, and so I just delete it and fire up a new machine and everything works (this is usually while testing the setup.sh script!).

## The process to search SRA

To search the SRA we are going to:
0. copy the scripts over
1. install the software
2. run the search in the background using screen

We can test the code on a single instance. Change the IP address to the actual IP address.

```
IP=149.165.0.0 
scp compare2sra.sh search_sra.sh setup.sh $IP:
ssh $IP "~/setup.sh"
ssh $IP "~/search_sra.sh genomes.fasta x00"
```

Note that in the last line: genomes.fasta is the name of my fasta file (1, above). x00 is the name of the file from the split command.

If that completes successfully we can run the code for the other nodes. I have a file that I call `ips.txt` which has one IP address per line.

```
C=0; 
for IP in $(cat ips.txt)
do
	C=$((C+1));
	scp compare2sra.sh search_sra.sh setup.sh $IP:
	ssh $IP "~/setup.sh"
	ssh $IP "~/search_sra.sh x0$C"
done
```

# Get the results.

Once this is run, we just need to get the results. This code will access all the machines and synchronize the results into the search folder. You can run this as often as you like.

```
for IP in $(cat ips.txt)
do 
	OUT=$(rsync -avz $IP:search/ search/);
	COUNT=$(echo $OUT| sed -e 's/bam /bam\n/g' | wc -l)
	echo $IP  " :: "  $((COUNT-1)) " FILES"
done
```
