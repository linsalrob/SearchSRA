# Some tips and clues on downstream analysis

These are some tips and clues for downstream analysis of searchSRA data. When you get the results back, you get a zip file with several thousand indexed `bam` files set across 40 or so directories.

First, we combine all the results into a single directory and then start parsing those:

_Note:_ In this step, change 44 to the largest number. It is probably 44.

```bash
mkdir bam
for i in $(seq 1 44); do mv $i/* bam/; done
rmdir *
```

_Note:_ The rmdir will throw a couple of errors, but it should remove the directories 1-44. Do not force this, you just want to remove empty directories

Then I try and find a mid-sized `bam` file that I can test these scripts and commands with. Usually, I use

```bash
ls -lSr bam/ | tail -n 200 | head
```

### Calculate the dpeth across every sample

This command will make a new directory and create a single tsv file for each entry with the depth. Note that you could add a `-a` flag to depth to print out the positions with no coverage

```bash
mkdir depth
for BAM in $(find bam -name \*bam -type f | sed -E 's/\.?bam\/?//g'); do samtools depth bam/$BAM.bam > depth/$BAM.tsv; done
```


Make a depth histogram

```
python3.7 ~/GitHubs/SearchSRA/scripts/depth_histogram.py -d depth -o depth.hist
```

Now we can normalize some of those files based on the maximum depth in a file. Here we limit it to just files with a maximum sequencing depth of 1,000 reads

``bash
python3.7 ~/GitHubs/SearchSRA/scripts/normalize_depth.py -d depth -o depth_normalized.1000 -m 1000
```







