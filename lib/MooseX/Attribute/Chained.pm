#
# This file is part of MooseX-Attribute-Chained
#
# This software is copyright (c) 2012 by Moritz Onken.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
package MooseX::Attribute::Chained;
{
  $MooseX::Attribute::Chained::VERSION = '1.0.1';
}

# ABSTRACT: Attribute that returns the instance to allow for chaining
use Moose::Util;
Moose::Util::meta_attribute_alias(
    Chained => 'MooseX::Traits::Attribute::Chained' );

package MooseX::Traits::Attribute::Chained;
{
  $MooseX::Traits::Attribute::Chained::VERSION = '1.0.1';
}
use Moose::Role;

override accessor_metaclass => sub {
    'MooseX::Attribute::Chained::Method::Accessor';
};

package MooseX::Attribute::Chained::Method::Accessor;
{
  $MooseX::Attribute::Chained::Method::Accessor::VERSION = '1.0.1';
}
use Carp qw(confess);
use Try::Tiny;
use base 'Moose::Meta::Method::Accessor';

sub _generate_accessor_method_inline {
    my $self = shift;
    my $attr = $self->associated_attribute;
    my $clone
        = $attr->associated_class->has_method("clone")
        ? '$_[0]->clone'
        : 'bless { %{$_[0]} }, ref $_[0]';

    if ( $Moose::VERSION >= 1.9900 ) {
        return try {
            $self->_compile_code(
                [   'sub {',
                    'if (@_ > 1) {',
                    $attr->_inline_set_value( '$_[0]', '$_[1]' ),
                    'return $_[0];',
                    '}',
                    $attr->_inline_get_value('$_[0]'),
                    '}',
                ]
            );
        }
        catch {
            confess "Could not generate inline accessor because : $_";
        };
    }
    else {
        return $self->next::method(@_);
    }
}

sub _generate_writer_method_inline {
    my $self = shift;
    my $attr = $self->associated_attribute;
    my $clone
        = $attr->associated_class->has_method("clone")
        ? '$_[0]->clone'
        : 'bless { %{$_[0]} }, ref $_[0]';
    if ( $Moose::VERSION >= 1.9900 ) {
        return try {
            $self->_compile_code(
                [   'sub {', $attr->_inline_set_value( '$_[0]', '$_[1]' ),
                    '$_[0]', '}',
                ]
            );
        }
        catch {
            confess "Could not generate inline writer because : $_";
        };
    }
    else {
        return $self->next::method(@_);
    }
}

sub _inline_post_body {
    return 'return $_[0] if (scalar(@_) >= 2);' . "\n";
}

1;


__END__
=pod

=head1 NAME

MooseX::Attribute::Chained - Attribute that returns the instance to allow for chaining

=head1 VERSION

version 1.0.1

=head1 SYNOPSIS

  package Test;
  use Moose;

  has debug => (
      traits => [ 'Chained' ],
      is => 'rw',
      isa => 'Bool',
  );

  sub complex_method
  {
      my $self = shift;
    
      #...
    
      print "helper message" if $self->debug;
    
      #...
  }


  1;

Which allows for:

    my $test = Test->new;
    $test->debug(1)->complex_method;

    $test->debug(1); # returns $test
    $test->debug;    # returns 1

=head1 DESCRIPTION

MooseX::Attribute::Chained is a Moose Trait which allows for method chaining 
on accessors by returning $self on write/set operations.

=head1 AUTHORS

=over 4

=item *

Moritz Onken <onken@netcubed.de>

=item *

David McLaughlin <david@dmclaughlin.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Moritz Onken.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

