# lss_top_term_tools

## Summary
We use CommonGrams to allow queries with phrase queries containing common words to be processed effciently. (See https://tools.lib.umich.edu/confluence/display/HAT/Tuning+CommonGrams+and+the+cache-warming+queries for background)
In order to create CommonGrams we need a list of common words to be used in creating CommonGrams. These tools take the output of running  lucene.misc.HighFreqTerms on all shards and output totals for the entire index.


TODO: add utilities to 
a) pull out commongrams
b) remove single character C and J and possibly two character strings too think about it


## Files

todo: add descriptions

* bin
* bin/commas
* bin/get_totals.pl
* data
* reports
* test
