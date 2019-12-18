todo: convert to markup

1) run HighFreqTerms using existing solr on buzz
2) write up docs
3) determine name and

See 
https://tools.lib.umich.edu/confluence/display/HAT/Tuning+CommonGrams+and+the+cache-warming+queries
 for background and details.
 

On buzz
/l/local/solr-current-lss/server/solr-webapp/webapp/WEB-INF/lib
export LUCENE_LIB=/l/local/solr-current-lss/server/solr-webapp/webapp/WEB-INF/lib
export SOLR_LIB=/htsolr/lss-dev/solrs/solr6.6/common/lib

java

 the formula for these classes is lucene-class_name-lucene_version_number.jar  In this case 6.6.5
 the exception is the version of the icu4j library used by the current version of solr i.e. icu4j-56.1 isthe version used in Solr 6.6.5


Start by making sure the path resolves.  The following will just run the program with no arguments and should get the help text

java -Xms16G -Xmx16G -cp $LUCENE_LIB/lucene-core-6.6.5.jar:$LUCENE_LIB/lucene-codecs-6.6.5.jar:$LUCENE_LIB/lucene-misc-6.6.5.jar:$SOLR_LIB/HTPostingsFormatWrapper.jar:$SOLR_LIB/lucene-analyzers-icu-6.6.5.jar:$SOLR_LIB/icu4j-56.1.jar org.apache.lucene.misc.HighFreqTerms

java org.apache.lucene.misc.HighFreqTerms <index dir> [-t] [number_terms] [field]
	 -t: order by totalTermFreq

Once the path is correct, add the indexdir path and the -t flag

nohup java -Xms16G -Xmx16G -cp $LUCENE_LIB/lucene-core-6.6.5.jar:$LUCENE_LIB/lucene-codecs-6.6.5.jar:$LUCENE_LIB/lucene-misc-6.6.5.jar:$SOLR_LIB/HTPostingsFormatWrapper.jar:$SOLR_LIB/lucene-analyzers-icu-6.6.5.jar:$SOLR_LIB/icu4j-56.1.jar org.apache.lucene.misc.HighFreqTerms /htsolr/lss/cores/.snapshot/htsolr-lss_2019-12-10/1/core-1x/data/index -T 200000 ocr


commas
data
get_totals.pl
README.md
reports
temp
testdata
