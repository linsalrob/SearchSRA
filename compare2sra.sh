#!/bin/bash

IFS='
'

if [ ! -n "$1" ] || [ ! -n "$2" ]
then
        echo "Usage: `basename $0` <bowtie index base name> <file name with list of SRA IDs>";
        exit $E_BADARGS
fi


DIR=fastq$$
ODIR=search
if [ ! -e $ODIR ]; then mkdir $ODIR; fi

for i in $(cat $2); do 
	if [ ! -e $ODIR/$i.bam ]; then
		echo $i;
		fastq-dump --outdir $DIR --skip-technical  --readids --read-filter pass --dumpbase --split-files --clip -N 0 -X 100000 $i
		READS=$(ls $DIR/* | tr \\n \, | sed -e 's/,$//')
		bowtie2 -p 6 -q --no-unal -x $1 -U $READS | samtools view -bS - | samtools sort - $ODIR/$i
		samtools index $ODIR/$i.bam
		rm -rf $DIR
		rm -f $HOME/ncbi/public/sra/$i.sra*
	fi
done
