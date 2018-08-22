use MooseX::Declare;
use Method::Signatures::Simple;

class Test::File::Convert with (Logger, Test::Util) extends File::Convert  {

use FindBin qw($Bin);
use Test::More;

# Ints
has 'log'		=>  ( isa => 'Int', is => 'rw', default => 2 );  
has 'printlog'		=>  ( isa => 'Int', is => 'rw', default => 5 );

# Strings
has 'logfile'       => ( isa => 'Str|Undef', is => 'rw' );

####////}}

method testConvert () {
	diag("convert");
	
	#### SET LOG FILE
	my $logfile		=	"$Bin/outputs/parsejsonfile.log";
	$self->logfile($logfile);

	my $tests = [
		{
			name		=>	"opsfile jsonToYaml",
			from		=>	"json",
			to			=>	"yaml",
			inputfile	=>	"$Bin/inputs/agua.ops.json",
			outputfile	=>	"$Bin/outputs/agua.yaml",
			expectedfile=>	"$Bin/inputs/agua.ops.yaml",
		}
		,
		{
			name		=>	"opsfile yamlToJson",
			from		=>	"yaml",
			to			=>	"json",
			inputfile	=>	"$Bin/inputs/agua.ops.yaml",
			outputfile	=>	"$Bin/outputs/agua.json",
			expectedfile=>	"$Bin/inputs/agua.ops.json",
		}
	];

	foreach my $test ( @$tests ) {
		my $name		=	$test->{name};
		my $from		=	$test->{from};
		my $to			=	$test->{to};
		my $inputfile	=	$test->{inputfile};
		my $outputfile	=	$test->{outputfile};
		my $expectedfile=	$test->{expectedfile};
		
		$self->convert($inputfile, $outputfile, $from, $to);
		
		my $actual;
		my $expected;
		if ( $from eq "yaml" ) {
			$actual		=	$self->parseJsonFile($outputfile);
			$expected	=	$self->parseJsonFile($expectedfile);
		}
		else {
			$actual		=	$self->parseYamlFile($outputfile);
			$expected	=	$self->parseYamlFile($expectedfile);
		}
		
		$self->logDebug("actual", $actual);
		$self->logDebug("expected", $expected);
		
		is_deeply($actual, $expected, $name);
	}
}


}   #### END