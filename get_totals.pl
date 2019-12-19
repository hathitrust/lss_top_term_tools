#get_totals.pl

#  takes output of lucene.misc.HighFreqTerms -t  from one or more  files, adds up the totals and outputs counts sorted by term, total term frequency (ttf) and document frequency (df)

my $ttf_count = {};
my $df_count  = {};

my $out_file_basename = "top_terms";
my $filename;

$filename = $out_file_basename . "_by_term";
open ( my $term_fh,'>', $filename) or die "couldn't open input file $filename $!";

$filename = $out_file_basename . "_by_ttf";
open ( my $ttf_fh,'>', $filename) or die "couldn't open input file $filename $!";

$filename = $out_file_basename . "_by_df";
open ( my $df_fh,'>', $filename) or die "couldn't open input file $filename $!";




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
    $ttf_count->{$term} += $ttf;
    $df_count->{$term} += $df;
}


my $out;
my $header = "term\tttf\tdf\n";


print $term_fh $header;
foreach my $term (sort (keys %$ttf_count))
{
    $out = "$term\t$ttf_count->{$term}\t$df_count->{$term}\n";
    print $term_fh $out;
}

print $ttf_fh $header;
foreach my $term (sort { $ttf_count->{$b} <=> $ttf_count->{$a}} keys %{$ttf_count})
{
    $out = "$term\t$ttf_count->{$term}\t$df_count->{$term}\n";
    print $ttf_fh $out;
}

print $df_fh $header;
foreach my $term (sort { $df_count->{$b} <=> $df_count->{$a}} keys %{$df_count} )
{
    $out = "$term\t$ttf_count->{$term}\t$df_count->{$term}\n";
    print $df_fh $out;
}
