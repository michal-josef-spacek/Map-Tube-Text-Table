package Map::Tube::Text::Table::Utils;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use List::Util qw(sum);
use Readonly;
use Text::UnicodeBox;
use Text::UnicodeBox::Control qw(:all);

# Constants.
Readonly::Array our @EXPORT_OK => qw(table);
Readonly::Scalar our $SPACE => q{ };

# Version.
our $VERSION = 0.01;

# Print table.
sub table {
	my ($title, $data_len_ar, $title_ar, $data_ar) = @_;
	my $t = Text::UnicodeBox->new;

	# Table title.
	$t->add_line(
		BOX_START('bottom' => 'light', 'top' => 'light'),
		# XXX Co to je za vypocet?
		_column_left($title, sum(@{$data_len_ar})
			+ @{$data_len_ar} * 2 - 2),
		BOX_END(),
	);

	# Legend.
	$t->add_line(
		BOX_START('bottom' => 'light', 'top' => 'light'),
		_columns($title_ar, $data_len_ar),
	);

	# Data.
	while (my $row_ar = shift @{$data_ar}) {
		$t->add_line(
			BOX_START(
				@{$data_ar} == 0 ? ('bottom' => 'light') : (),
			),
			_columns($row_ar, $data_len_ar),
		);
	}

	# Render to output.
	return $t->render;
}

# Column text with left align.
sub _column_left {
	my ($text, $width) = @_;
	my $text_len = length $text;
	return $SPACE.$text.($SPACE x ($width - $text_len));
}

# Get Text::UnicodeBox columns.
sub _columns {
	my ($data_ar, $data_len_ar) = @_;
	my @ret;
	my $i = 0;
	foreach my $item (@{$data_ar}) {
		push @ret, _column_left($item, $data_len_ar->[$i++]);
		if (@{$data_ar} > $i) {
			push @ret, BOX_RULE;
		} else {
			push @ret, BOX_END;
		}
	}
	return @ret;
}

1;

__END__
