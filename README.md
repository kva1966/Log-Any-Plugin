# NAME

Log::Any::Plugin - Adapter-modifying plugins for Log::Any

# VERSION

version 0.008

# SYNOPSIS

    use Log::Any::Adapter;
    use Log::Any::Plugin;

    # Create your adapter as normal
    Log::Any::Adapter->set( 'SomeAdapter' );

    # Add plugin to modify its behaviour
    Log::Any::Plugin->add( 'Stringify' );

    # Multiple plugins may be used together
    Log::Any::Plugin->add( 'Levels', level => 'debug' );

# DESCRIPTION

Log::Any::Plugin is a method for augmenting arbitrary instances of
Log::Any::Adapters.

Log::Any::Plugins work much in the same manner as Moose 'around' modifiers to
augment logging behaviour of pre-existing adapters.

# MOTIVATION

Many of the Log::Any::Adapters have extended functionality, such as being
able to selectively disable various log levels, or to handle multiple arguments.

In order for Log::Any to be truly 'any', only the common subset of adapter
functionality can be used. Any specific adapter functionality must be avoided
if there is a possibility of using a different adapter at a later date.

Log::Any::Plugins provide a method to augment adapters with missing
functionality so that a superset of adapter functionality can be used.

# METHODS

## add ( $plugin, \[ %plugin\_args \] )

This is the single method for adding plugins to adapters. It works in a
similar function to Log::Any::Adapter->set()

- $plugin

    The plugin class to add to the currently active adapter. If the class is in
    the Log::Any::Plugin:: namespace, you can simply specify the name, otherwise
    prefix a '+'.

        eg. '+My::Plugin::Class'

- %plugin\_args

    These are plugin specific arguments. See the individual plugin documentation for
    what options are supported.

# SEE ALSO

[Log::Any](https://metacpan.org/pod/Log::Any), [Log::Any::Plugin::Levels](https://metacpan.org/pod/Log::Any::Plugin::Levels), [Log::Any::Plugin::Stringify](https://metacpan.org/pod/Log::Any::Plugin::Stringify)

# ACKNOWLEDGEMENTS

Thanks to Strategic Data for sponsoring the development of this module.

# AUTHOR

Stephen Thirlwall <sdt@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2019, 2017, 2016, 2015, 2014, 2013, 2011 by Stephen Thirlwall.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

# CONTRIBUTORS

- José Joaquín Atria <jjatria@gmail.com>
- Kamal Advani <kamal@namingcrisis.net>
