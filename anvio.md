# Using SearchSRA and Anvi'o

Most of this tutorial is built off the one written by Meren and co. available [on the anvi'o website](http://merenlab.org/2016/06/22/anvio-tutorial-v2/). _Note:_ you should make sure you use the latest version of the code!

Once your searchSRA run has completed, download the results and combine them into a single directory.

```bash
mkdir bam
for i in $(seq 1 45); do mv $i/* bam/; done
rmdir *
```

You will also need the reference file that you uploaded to searchSRA, and hopefully you have what anvi'o calls `simple ids` for your fasta file. Otherwise you may need to redo the search. (Often, you can just delete anything after the first space and anvi'o will be happy.)


Before you begin, note that znvi'o is currently limited to ~2,000 samples in a single profile. You should check out this twitter thread for why:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Didn&#39;t get the <a href="https://twitter.com/hashtag/anvio?src=hash&amp;ref_src=twsrc%5Etfw">#anvio</a> happy face today :( sqlite3.OperationalError: too many SQL variables<br><br>Probably shouldn&#39;t try to profile 11,000 bam files <a href="https://twitter.com/merenbey?ref_src=twsrc%5Etfw">@merenbey</a></p>&mdash; Rob Edwards (@linsalrob) <a href="https://twitter.com/linsalrob/status/1180242604958666752?ref_src=twsrc%5Etfw">October 4, 2019</a></blockquote> 

We have mechanisms to [filter](DownstreamAnalysis.md) your results to reduce the number of files.
