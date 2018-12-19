
* How was the PARTIE segregation used in defining SRA runs to include? In general, I am still noticing some amplicon studies creeping in to the results, although I have currently only filtered for mapping quality and number. I noticed that of the 111,155 runs provided, 8509 were assigned as "AMPLICON" according to the PARTIE "SRA\_Metagenome\_Types.tsv" file available on GitHub. 4714 runs were “OTHER”, 11 “NO DATA”, and an additional 1335 were not found in the file at all. Are these just new SRA additions not included in the PARTIE file? And why are PARTIE-defined amplicon studies included in the list (or non-WGS)?


There are a few amplicon data sets that are included in searchsra because of random reasons - for example people asked for them (I don't know why). I typically don't remove data sets/

* Were the 100,000 SRA reads from each metagenome preprocessed in anyway (filtered)?

The reads were only filtered by fastq dump and there was no other filtering. The fastq-dump command we use is:

```bash
fastq-dump --outdir fastq --gzip --skip-technical  --readids --read-filter pass --dumpbase --split-3 --clip  -N 5000 -X 105000 SRR_ID
```

(see [this page for more information](https://edwards.sdsu.edu/research/fastq-dump/)).

* Do paired end reads count as a single read in the 100,000 read subsample? I noticed mappings with >100,000 unique mapped reads with only different appendages at the end of the sequence name (e.g. SRRxxxxx.###.1 and SRRxxxxx.###.2). These happened to be from amplicon studies with all reads mapping to the 16S rRNA gene.

The paired end reads actually have 2x the reads. The left and right pairs were concatenated (not merged or joined, just one fastq file then the other). This is not optimal and I need a better solution for this.

* Any ideas on how to partition Metatranscriptomes from the data?

We've thought about pulling metatranscriptomes but its not clear how to distinguish those from metagenomes. I have a student who is trying to identify some and see if we can make a ML algorithm do this. Any thoughts?




