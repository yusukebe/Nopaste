package Nopaste::DB::Schema;
use DBIx::Skinny::Schema;
use DateTime;
use DateTime::Format::Strptime;
use DateTime::Format::MySQL;

sub pre_insert_hook {
    my ( $class, $args ) = @_;
    $args->{created_on} = DateTime->now( time_zone => 'Asia/Tokyo' );
}

install_inflate_rule '^.+_on$' => callback {
    inflate {
        my $value = shift;
        my $dt = DateTime::Format::Strptime->new(
            pattern => '%Y-%m-%d %H:%M:%S',
            time_zone => container('timezone'),
        )->parse_datetime($value);
        return DateTime->from_object( object => $dt );
    };
    deflate {
        my $value = shift;
        return DateTime::Format::MySQL->format_datetime($value);
    };
};

install_table entry => schema {
    pk 'id';
    columns qw/id title body created_on/;
    trigger pre_insert => \&pre_insert_hook;
};

install_utf8_columns qw/title body/;

1;
