package Nopaste::Web;
use Mojo::Base 'Mojolicious';
use Nopaste::DB;

sub startup {
    my $self = shift;
    my $config = $self->plugin('Config', { file => 'nopaste.conf' });
    $self->attr( db => sub { Nopaste::DB->new( $config->{db} ) } );
    my $r    = $self->routes;
    $r->get('/')->to('root#index');
    $r->post('/')->to('root#post');
    $r->route('/paste/:id')->to('root#entry');
}

1;
