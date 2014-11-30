package Map::Tube::Text::Table;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use Map::Tube::Text::Table::Utils qw(table);
use Readonly;
use Scalar::Util qw(blessed);

# Constants.
Readonly::Scalar our $CONNECTED_TO => q{Connected to};
Readonly::Scalar our $JUNCTIONS => q{Junctions};
Readonly::Scalar our $LINE => q{Line};
Readonly::Scalar our $STATION => q{Station};

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Map::Tube object.
	$self->{'tube'} = undef;

	# Process params.
	set_params($self, @params);

	# Check Map::Tube object.
	if (! defined $self->{'tube'}) {
		err "Parameter 'tube' is required.";
	}
	if (! blessed($self->{'tube'})
		|| ! $self->{'tube'}->does('Map::Tube')) {

		err "Parameter 'tube' must be 'Map::Tube' object.";
	}

	# Object.
	return $self;
}

# Print junctions.
sub junctions {
	my $self = shift;

	# Get data.
	my @data;
	my @title = ($STATION, $LINE, $CONNECTED_TO);
	my @data_len = map { length $_ } @title;
	my $nodes_hr = $self->{'tube'}->nodes;
	foreach my $node_name (sort keys %{$nodes_hr}) {
		if ($nodes_hr->{$node_name}->line =~ m/,/ms) {

			# Get data.
			my @links = map { $self->{'tube'}->get_node_by_id($_)->name }
				split m/,/ms, $nodes_hr->{$node_name}->link;
			my $data_ar = [
				$nodes_hr->{$node_name}->name,
				$nodes_hr->{$node_name}->line,
				(join ', ', sort @links),
			];
			push @data, $data_ar;

			# Maximum data length.
			foreach my $i (0 .. $#{$data_ar}) {
				if (length $data_ar->[$i] > $data_len[$i]) {
					$data_len[$i] = length $data_ar->[$i];
				}
			}
		}
	}
	map { $_++ } @data_len;

	# Print and return table.
	return table($JUNCTIONS, \@data_len, \@title, \@data);
}

# Print line.
sub line {
	my ($self, $line) = @_;

	# Get data.
	my @data;
	my @title = ($STATION, $CONNECTED_TO);
	my @data_len = map { length $_ } @title;
	my $nodes_hr = $self->{'tube'}->nodes;
	foreach my $node_name (sort keys %{$nodes_hr}) {
		if ($nodes_hr->{$node_name}->line =~ m/$line/ms) {

			# Get data.
			my @links = map { $self->{'tube'}->get_node_by_id($_)->name }
				split m/,/ms, $nodes_hr->{$node_name}->link;
			my $data_ar = [
				$nodes_hr->{$node_name}->name,
				(join ', ', sort @links),
			];
			push @data, $data_ar;

			# Maximum data length.
			foreach my $i (0 .. $#{$data_ar}) {
				if (length $data_ar->[$i] > $data_len[$i]) {
					$data_len[$i] = length $data_ar->[$i];
				}
			}
		}
	}
	map { $_++ } @data_len;

	# Print and return table.
	return table($LINE." '$line'", \@data_len, \@title, \@data);
}

# Print all.
sub print {
	my $self = shift;
	my $ret = $self->junctions."\n";
	# TODO
	return $ret;
}

1;

__END__
