#!/usr/bin/perl -w

#### TEST MODULES
use Test::More  tests => 35; #qw(no_plan);

#### EXTERNAL MODULES
use FindBin qw($Bin);
BEGIN
{
    my $installdir = $ENV{'installdir'} || "/a";
    unshift(@INC, "$installdir/extlib/lib/perl5");
    unshift(@INC, "$installdir/extlib/lib/perl5/x86_64-linux-gnu-thread-multi/");
    unshift(@INC, "$installdir/lib");
    unshift(@INC, "$installdir/lib/external/lib/perl5");
    unshift(@INC, "$installdir/t/unit/lib");
    unshift(@INC, "$installdir/t/common/lib");
}

#### CREATE OUTPUTS DIR
my $outputsdir = "$Bin/outputs";
`mkdir -p $outputsdir` if not -d $outputsdir;

use Getopt::Long;

#### INTERNAL MODULES
use Test::File::Convert;

#### SET LOG
my $log     =   0;
my $printlog    =   4;
my $logfile = "$Bin/outputs/version.log";

#### GET OPTIONS
my $login;
my $token;
my $keyfile;
my $help;
GetOptions (
    'log=i'         => \$log,
    'printlog=i'    => \$printlog,
    'help'          => \$help
) or die "No options specified. Try '--help'\n";
usage() if defined $help;

my $object = new Test::File::Convert(
    log			=>	$log,
    printlog    =>  $printlog,
    logfile     =>  $logfile
);

$object->testConvert();

sub usage {
    print qq{
        
OPTIONS:

--log       Print to STDOUT increasing log info (1 to 5)
--printlog  Print to logfile increasing log info (1 to 5)
};

}