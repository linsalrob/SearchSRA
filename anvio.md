# Using SearchSRA and Anvi'o

Most of this tutorial is built off the one written by Meren and co. available [on the anvi'o website](http://merenlab.org/2016/06/22/anvio-tutorial-v2/). _Note:_ you should make sure you use the latest version of the code!

Once your searchSRA run has completed, download the results and combine them into a single directory.

```bash
mkdir bam
for i in $(seq 1 45); do mv $i/* bam/; done
rmdir *
```

You will also need the reference file that you uploaded to searchSRA, and hopefully you have what anvi'o calls `simple ids` for your fasta file. Otherwise you may need to redo the search. (Often, you can just delete anything after the first space and anvi'o will be happy.)




