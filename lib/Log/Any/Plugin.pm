package Log::Any::Plugin;
# ABSTRACT: Adapter-modifying plugins for Log::Any

use strict;
use warnings;

use Log::Any 1.00;
use Log::Any::Plugin::Util  qw( get_class_name  );

use Class::Load qw( try_load_class );
use Carp qw( croak );

sub add {
    my ($class, $plugin_class, %plugin_args) = @_;

    my $adapter_class = ref Log::Any->get_logger(category => caller());

    $plugin_class = get_class_name($plugin_class);

    my ($loaded, $error) = try_load_class($plugin_class);
    die $error unless $loaded;

    $plugin_class->install($adapter_class, %plugin_args);
}

1;

__END__

=pod

=head1 SYNOPSIS

    use Log::Any::Adapter;
    use Log::Any::Plugin;

    # Create your adapter as normal
    Log::Any::Adapter->set( 'SomeAdapter' );

    # Add plugin to modify its behaviour
    Log::Any::Plugin->add( 'Stringify' );

    # Multiple plugins may be used together
    Log::Any::Plugin->add( 'Levels', level => 'debug' );

=head1 DESCRIPTION

Log::Any::Plugin is a method for augmenting arbitrary instances of
Log::Any::Adapters.

Log::Any::Plugins work much in the same manner as Moose 'around' modifiers to
augment logging behaviour of pre-existing adapters.

=head1 MOTIVATION

Many of the Log::Any::Adapters have extended functionality, such as being
able to selectively disable various log levels, or to handle multiple arguments.

In order for Log::Any to be truly 'any', only the common subset of adapter
functionality can be used. Any specific adapter functionality must be avoided
if there is a possibility of using a different adapter at a later date.

Log::Any::Plugins provide a method to augment adapters with missing
functionality so that a superset of adapter functionality can be used.

=head1 METHODS

=head2 add ( $plugin, [ %plugin_args ] )

This is the single method for adding plugins to adapters. It works in a
similar function to Log::Any::Adapter->set()

=over

=item * $plugin

The plugin class to add to the currently active adapter. If the class is in
the Log::Any::Plugin:: namespace, you can simply specify the name, otherwise
prefix a '+'.

    eg. '+My::Plugin::Class'

=item * %plugin_args

These are plugin specific arguments. See the individual plugin documentation for
what options are supported.

=back


=head1 PLUGIN DEVELOPMENT

=head2 Build Tools

=over

=item * You must have L<cpanm|https://metacpan.org/pod/App::cpanminus> installed.

=item * Then install L<Dist::Zilla|http://dzil.org/> via C<cpanm Dist::Zilla>. This is
        a L<Dist::Zilla>-managed project.

=back


=head2 Setup Dependencies

On initial check out of the project, set-up the required dependencies as follows:

    # Get dependencies
    dzil authordeps --missing | cpanm
    dzil listdeps --author | cpanm

Next run a basic test suite:

    dzil test

Install the necessary missed dependencies as needed via C<cpanm> and rerun
tests till they execute successfully.

For example, there's a L<known issue|https://rt.cpan.org/Public/Bug/Display.html?id=98689>
requiring explicit installation of L<Module::Build::Version>.

See the error logs as directed in the C<cpanm> output.


=head2 Development

A plugin's entry point is via its C<install> method which has the signature:

    install($class, $adapter_class, %args)

C<$adapter_class> is the L<Log::Any::Adapter> adapter class to be used, e.g.
C<Stderr>.

C<%args> is a hash of arguments to configure or customise the plugin.

Plugins add new facilities or augment existing facilities, so it's hard to
define confines of their scope. This module packages in several use-case
driven plugins that may serve as examples E<mdash> check the
L<SEE ALSO|"SEE ALSO"> section.

Once a plugin is implemented, and tests added, re-run the L<Setup Dependencies|"Setup Dependencies">
steps to get any new required dependencies.

Next, run the full suite of tests through a sequence of:

    dzil test
    dzil test --author
    dzil test --release

Finally to remove any temporarily generated artifacts, run:

    dzil clean



=head1 SEE ALSO

L<Log::Any>, L<Log::Any::Plugin::Levels>, L<Log::Any::Plugin::Stringify>

=head1 ACKNOWLEDGEMENTS

Thanks to Strategic Data for sponsoring the development of this module.

=cut
