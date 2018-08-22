use MooseX::Declare;

class File::Convert with Util::Logger {

use YAML::Tiny;
use JSON;
use TryCatch;

# Strings
has 'from'     	=> ( isa => 'Str|Undef', is => 'rw' );
has 'to'       	=> ( isa => 'Str|Undef', is => 'rw' );
has 'inputfile'	=> ( isa => 'Str|Undef', is => 'rw' );
has 'outputfile'=> ( isa => 'Str|Undef', is => 'rw' );

####//}}}}

method convert ($inputfile, $outputfile, $from, $to) {
	$self->logDebug("inputfile", $inputfile);
	$self->logDebug("outputfile", $outputfile);
	$self->logDebug("from", $from);
	$self->logDebug("to", $to);
	
	#### CHECK INPUTS
	print "'from' not supported: $from\n" and return if not $from =~ /^(json|yaml)$/;
	print "'to' not supported: $to\n" and return if not $to =~ /^(json|yaml)$/;
	print "'from' $from and 'to' $to must differ\n" and return if $from eq $to;

	#### PARSE FILE
	if ( $from eq "json" ) {
		$self->convertJsonToYaml($inputfile, $outputfile);
	}
	elsif ( $from eq "yaml" ) {
		$self->convertYamlToJson($inputfile, $outputfile);
	}
}

#### YAML TO JSON
method convertYamlToJson ($inputfile, $outputfile) {
	$self->logDebug("inputfile", $inputfile);
	my $data = $self->parseYamlFile($inputfile);
	$self->logDebug("data", $data);
	$self->printJsonFile($outputfile, $data);
}

method parseYamlFile ($inputfile) {
	try {
		my $yaml = YAML::Tiny->read($inputfile);
		return $$yaml[0];
	}
	catch {
		 $self->logCritical("Can't open inputfile: $inputfile");
		 return undef
	}
}

method printJsonFile ($outputfile, $data) {
	$self->logDebug("outputfile", $outputfile);

	my $parser = JSON->new();
	try {
		my $contents = $parser->pretty->encode($data);
		return $self->printToFile($outputfile, $contents);
	}
	catch {
		$self->logError("Can't write to outputfile: $outputfile");
		return undef;
	}
}


#### JSON TO YAML
method convertJsonToYaml ($inputfile, $outputfile) {
	$self->logDebug("inputfile", $inputfile);
	my $data = $self->parseJsonFile($inputfile);
	$self->logDebug("data", $data);
	$self->printYamlFile($outputfile, $data);
}

method parseJsonFile ($inputfile) {
	$self->logDebug("inputfile", $inputfile);
	open(FILE, $inputfile) or die "Can't open inputfile: $inputfile\n";
	my $temp = $/;
	$/ = undef;
	my $contents = <FILE>;
	close(FILE) or die "Can't close inputfile: $inputfile\n";
	
	my $parser = JSON->new();
	try {
		return $parser->decode($contents);
	}
	catch {
		return undef;
	}
}

method printYamlFile ($outputfile, $data) {
	$self->logDebug("outputfile", $outputfile);
	my $yaml = YAML::Tiny->new();
	try {
		$$yaml[0] = $data;
		return $yaml->write($outputfile);
	}
	catch {
		$self->logError("Can't write to outputfile: $outputfile");
		return undef;
	}
}

method printToFile ($file, $contents) {
	open(OUT, ">$file") or die "Can't open file: $file\n";
	print OUT $contents;
	close(OUT) or die "Can't close file: $file\n";
}


} #### END
