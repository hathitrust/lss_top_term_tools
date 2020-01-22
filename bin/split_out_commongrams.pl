#
my $filename;

$filename ="no_common.tsv";
open ( my $no_common_fh,'>', $filename) or die "couldn't open input file $filename $!";

 $filename ="common.tsv";
open ( my $common_fh,'>', $filename) or die "couldn't open input file $filename $!";


while (<>){
    
    my ($term,$ttf,$df) = split(/\t/,$_);
    if ($term =~/\S+_\S+/)
    {
	print $common_fh $_;
    }
    else
    {
	print $no_common_fh $_;
    }
}
