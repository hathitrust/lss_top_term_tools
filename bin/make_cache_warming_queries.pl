#

use LWP;
use LWP::UserAgent;

my $TIMEOUT=60; 

$ua = LWP::UserAgent->new;
$ua->agent("SolrTesterQueryGen");
$ua->timeout($TIMEOUT);


# list of top N commongrams
#my $commongrams_file = "../tmp/common4caching"; # for 1000 commongrams
my $commongrams_file = "/htsolr/lss-dev/data/4/2020/tmp2/newCommon4caching";



my $CommonGrams = getCommonGrams($commongrams_file);


makeCommonGramsQueries($CommonGrams);


#----------------------------------------------------------------------
sub makeCommonGramsQueries{
    my $CommonGrams = shift;

    # will need to add most common word in non-English languages
    my @starters=('he','she','it','one','starting','quick','the','a');
    my @enders= ('new','best','kind','end','the');


    foreach my $word (@{$CommonGrams})
    {
        print STDERR "$word\n";
        my $phrase= getPhraseCommonGram($word,\@starters,\@enders);
        my $phraseQuery='"'. $phrase . '"';
        print "$phraseQuery\n";
        print STDERR "$phraseQuery\n";
    }
}

#----------------------------------------------------------------------
#
#  we need to find a combination of 3 words that occur in at least one document
#  if they do, then the boolean search will find at least 1 document and the processing of the
#  phrase will require loading the position lists for those words.
#
#
#Do boolean solr query for $starter commongram and/or commongram ender until we get at least one doc
#then return the words with the proper quotes

sub getPhraseCommonGram
{
    my ($commongram,$starters,$enders)=@_;
    my $phrase;
    
    my $FOUND=0;
    my $numDocs=0;
    
    $words=$commongram;
    $words=~s/\_/ /; 
    
    while (! $FOUND)
    {
        foreach my $startword (@{$starters})
        {

            $phrase = $startword . " " . $words;
            if (phraseWorks($phrase))
            {
                return $phrase;
            }
        }
        foreach my $endword (@{$enders})
        {
            $phrase = $words . " " . $endword;
            if (phraseWorks($phrase))
            {
                return $phrase;
            }

        }
    }
    
    return  (" could not find a phrase for $commongram\n");
}


sub getCommonGrams
{
    my $filename=shift;
    my $CommonGrams=[];
    
    open (my $FH, '<', $filename) or die "couldn't open file $filename $!";
    while (<$FH>)
    {
        chomp;
	push (@{$CommonGrams},$_);
    }
    
    return ($CommonGrams);
}


#----------------------------------------------------------------------

sub  phraseWorks
{
    my $phrase = shift;
    my $url = makeSolrQuery($phrase);
    my $numFound = getSolrResult($ua,$url);
    return ($numFound > 0)
}

#----------------------------------------------------------------------
sub makeSolrQuery
{
    my $phrase =shift;
    #note, we just take 3 words and use default Solr boolean AND
    # we are doing a boolean AND query not a phrase query
    my $url;

    #new shards
    my $SHARDS_PARAM= 'shards=solr-sdr-search-1:8081/solr/core-1x,solr-sdr-search-2:8081/solr/core-2x,solr-sdr-search-3:8081/solr/core-3x,solr-sdr-search-4:8081/solr/core-4x,solr-sdr-search-5:8081/solr/core-5x,solr-sdr-search-6:8081/solr/core-6x,solr-sdr-search-7:8081/solr/core-7x,solr-sdr-search-8:8081/solr/core-8x,solr-sdr-search-9:8081/solr/core-9x,solr-sdr-search-10:8081/solr/core-10x,solr-sdr-search-11:8081/solr/core-11x,solr-sdr-search-12:8081/solr/core-12x';
    
    my $start = 'http://solr-sdr-search-7:8081/solr/core-7x/select?q=';
    

    my $end ='&version=2.2&start=0&rows=10&indent=on&';# . $SHARDS_PARAM;
    
    $url = $start . $phrase . $end;
    return $url
}

#----------------------------------------------------------------------
sub getSolrResult
{
    my $ua = shift;
    my $url = shift;
    my $numFound=0;
    
    #
    my $res = $ua->get($url);
        
    # Check the outcome of the response
    if ($res->is_success) {
        my $content= $res->content;
        if ($content =~m, numFound=\"([^\"]+)",)
        {
            $numFound=$1;
        }
        if ($content =~m,QTime\">([^<]+)<,)
        {
            $Qtime=$1;
        }
        print STDERR "Found=$numFound\tTime= $Qtime\n";
    }
    else 
    {
        print $res->status_line, "\n";
    }
    return $numFound;
}

