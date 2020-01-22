# replace with a utf8 safe file open

#See http://perldoc.perl.org/Encode.html#Handling-Malformed-Data
use Encode qw(:fallbacks);
$PerlIO::encoding::fallback = FB_WARN;
use open qw(:std :utf8);
binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';

my $counts = {};

while (<>)
{
    chomp;
    my ($word,$ttf,$df)=split(/\t/,$_);
    # remove leading and trailing spaces
    $word =~s/^\s+//g;
    $word =~s/\s+$//g;
    
    my $CJK= "FALSE";
    
    $counts->{all}++;
    eval
    {

        if ($word =~ /\p{Han}/)
        {
	    $CJK= "TRUE";
            $counts->{han}++;
	    #print "Han: $_\n";

	}
	if($word =~ /\p{Hiragana}/)
	{
	    $CJK= "TRUE";
	    $counts->{hirigana}++;
	    #print "Hirigana: $_\n";
	}
	
	if ($word =~ /\p{Katakana}/)
	{
	    $CJK= "TRUE";
	    $counts->{katakana}++;
	   # print "Katakana: $_\n";
	    
	}

	if ($CJK eq "TRUE")
	{
	    
	    $numChars=length($word);
	    if ($numChars <2)
	    {
		$counts->{CJ_Unigrams}++;
		# remove line if its a C or J unigram
		next;
	    }
	    else
	    {
		print "$_\n";
	    }
	    
	    #the following is for stats
	    if ($numChars == 2)
	    {
		$counts->{'CJ_KBigrams'}++;
	    }
	    if ($numChars > 2)
	    {
		$counts->{'CJ_not_bigrams_or_unigrams'}++;
	    }
	    
	}
	else
	{
	    print "$_\n";
	    $counts->{'not_CJ'}++;
	}
    };
    
    
    if ($@)
    {
        print STDERR "bad char $_\n";
    }
    
}

foreach my $key (sort keys %{$counts})
{
    print STDERR "$key\t$counts->{$key}\n";
}

