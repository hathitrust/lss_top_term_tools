# lss_top_term_tools

Update:  See https://tools.lib.umich.edu/confluence/display/HAT/Tuning+CommonGrams+and+the+cache-warming+queries.  New queries are in 2020cachewarming dir

## Summary
We use CommonGrams to allow queries with phrase queries containing common words to be processed effciently. (See https://tools.lib.umich.edu/confluence/display/HAT/Tuning+CommonGrams+and+the+cache-warming+queries for background)
In order to create CommonGrams we need a list of common words to be used in creating CommonGrams. These tools take the output of running  lucene.misc.HighFreqTerms on all shards, output totals for the entire index, and then facilitate processing that output to produce a "words" file for use in Solr CommonGrams.


TODO: add utilities to 
a) pull out commongrams
b) remove single character C and J and possibly two character strings too think about it


## Files

todo: add descriptions


* bin/commas
Simple utility for human readable viewing of files inserts commas in numbers.  Useful when counts are in the million to billion range.
* bin/get_totals.pl
Takes output of luncene.misc.HighFreqTerms -t and produces 3 tab delimited files with headers.
Each file contains the same information but is sorted by term (utf8 collation), total term frequences, or document frequency.

top_terms_by_term
top_terms_by_ttf
top_terms_by_df

* bin/split_out_commongrams.pl
Since we are working with an index that contains CommonGrams (example "of_the") and we only want to create new CommonGrams from normal words, we use this on the top_terms_by_ttf file to split out a file without the CommonGrams and a file with only the CommonGrams.  (no_common.tsv and common.tsv)  The file of CommonGrams, "no_common.tsv", is used for creating the most useful cache-warming queries.

* bin/remove_CJ_unigrams.pl
Since we are creating bigrams for Chinese and Japanese characters already using the solr.CJKBigramFilterFactory we don't need to make CommonGrams based on unigrams in those languages.  We run the output of split_out_commongrams.pl, common.tsv, to remove the Chinese and Japanese unigrams from the file.   Writes to STDOUT.   Statistics on C and J characters are written to STDERR.

* data
* reports
* test
