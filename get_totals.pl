#get_totals.pl
#  takes output of xxx in multiple files

my $ttf_count = {};
my $df_count  = {};

#ocr:the 	 totalTF = 4,503,524,493 	 docFreq = 821,488
while(<>)
{
    
    chomp;
    my ($term, $ttf, $df)= split(/\t/,$_);
    $term =~s/^ocr\://;
    $ttf =~s/^\s*totalTF\s*\=\s*//;
    $ttf =~s/\,//g;
    $df  =~s/^\s*docFreq\s\=\s*//;
    $df =~s/\,//g; 

   # print STDERR "foo $term ttf=$ttf df=$df\n";
    
    $ttf_count->{$term} += $ttf;
    $df_count->{$term} += $df;
}
my $out;

# print header
my $header = "term\tttf\tdf\n";
print $header;

foreach my $term (sort (keys %$ttf_count))
{
    $out = "$term\t$ttf_count->{$term}\t$df_count->{$term}\n";
    print $out;
}
