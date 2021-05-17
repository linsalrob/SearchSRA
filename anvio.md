# Using SearchSRA and Anvi'o

Most of this tutorial is built off the one written by Meren and co. available [on the anvi'o website](http://merenlab.org/2016/06/22/anvio-tutorial-v2/). _Note:_ you should make sure you use the latest version of the code!

Once your searchSRA run has completed, download the results and combine them into a single directory.

```bash
mkdir bam
for i in $(seq 1 45); do mv $i/* bam/; done
rmdir *
```

You will also need the reference file that you uploaded to searchSRA, and hopefully you have what anvi'o calls `simple ids` for your fasta file. Otherwise you may need to redo the search. (Often, you can just delete anything after the first space and anvi'o will be happy.)


Before you begin, note that anvi'o is currently limited to ~2,000 samples in a single profile. You should check out this twitter thread for why:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Didn&#39;t get the <a href="https://twitter.com/hashtag/anvio?src=hash&amp;ref_src=twsrc%5Etfw">#anvio</a> happy face today :( sqlite3.OperationalError: too many SQL variables<br><br>Probably shouldn&#39;t try to profile 11,000 bam files <a href="https://twitter.com/merenbey?ref_src=twsrc%5Etfw">@merenbey</a></p>&mdash; Rob Edwards (@linsalrob) <a href="https://twitter.com/linsalrob/status/1180242604958666752?ref_src=twsrc%5Etfw">October 4, 2019</a></blockquote> 

We have mechanisms to [filter](DownstreamAnalysis.md) your results to reduce the number of files. We recommend removing enough data so you get down to <500 files!


### Activate anvi'o and build a contigs database

Start by activating anvi'o and building a contigs db. My data is from _Xylella fastidiosa_. Also, I'm running this on a machine where I can use 30 threads!

```bash
source  /usr/local/virtual-envs/anvio-5.5/bin/activate
anvi-gen-contigs-database -f Xylella_fastidiosa_Temecula1.fasta -o X_fastidiosa.db -n 'Xylella fastidiosa Temecula1'
anvi-run-ncbi-cogs --num-threads 30 -c X_fastidiosa.db
```

If you want to profile _all_ your `.bam` files, `parallel` is the way to go. For example, this will run `anvi-profile` on all the `.bam` files. Note that you can do this independently from the ones that you visualize later on.

```bash
find bam -name \*bam -type f | parallel anvi-profile -i {} -c X_fastidiosa.db
```

If you have a small subset of those, you can use a similar command changing the name of the directory to look in.

Here, I move my `anvi-profiles` out of the folder that has the `.bam` and `.bai` files. This is just to organize a bit and is completely unnecessary. I use this `seq` loop because if I just use \*PROFILE I get an error that there are too many files. (You can also solve this with `xargs`, and I leave it to someone else to figure out which is faster).

```bash
mkdir anviprofiles
for i in $(seq 0 9); do echo $i; mv bam/SRA${i}*PROFILE anviprofiles/; done
for i in $(seq 0 9); do echo $i; mv bam/SRR${i}*PROFILE anviprofiles/; done
for i in $(seq 0 9); do echo $i; mv bam/DRR${i}*PROFILE anviprofiles/; done
mv bam/*PROFILE anviprofiles/
```

In this example, I indexed all the bam files (using the `parallel` command above), and so I'm going to make a directory with just those that have >1,000x minimum coverage (from my [downstream filtering](DownstreamAnalysis.md).

```bash
mkdir anviprofiles.1000
cd anviprofiles.1000
for F in $(find ../depth_normalized.1000/ -type f -printf "%f\n"); do O=$(echo $F | sed -e 's/.tsv/.bam-ANVIO_PROFILE/'); ln -s ../anviprofiles/$O .; done
cd ../
```

_Alternately_ if you have filtered the files by size, but not profiled all the bam files, you can create a new directory with symlinks like this:

```bash
mkdir bam.1000/
cd bam.1000/
for B in $(find ../depth_normalized.1000/ -type f -printf "%f\n" | sed -e 's/.tsv/.bam/'); do ln -s ../bam/$B ../bam/$B.bai .; done
cd ..
```

Then you can go ahead and profile each of these:
```bash
find bam -type f -name \*bam -printf "%f\n" | sed -e 's/.bam//' | parallel anvi-profile -i mapping/{}.bam  -c X_fastidiosa.db -o anvi-profiles/{}
```



### Merge the anvi'o profiles

```bash
anvi-merge anviprofiles.1000/*/PROFILE.db -o X_fastidiosa_profiles -c X_fastidiosa.db
```

and visualize the output:

```bash
anvi-visualize -p X_fastidiosa_profiles/PROFILE.db -c X_fastidiosa.db
```





