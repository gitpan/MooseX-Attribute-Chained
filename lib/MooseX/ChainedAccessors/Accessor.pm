#
# This file is part of MooseX-Attribute-Chained
#
# This software is copyright (c) 2012 by Moritz Onken.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
package MooseX::ChainedAccessors::Accessor;
{
  $MooseX::ChainedAccessors::Accessor::VERSION = '1.0.1';
}
# ABSTRACT: DEPRECATED
use strict;
use warnings;
use base 'Moose::Meta::Method::Accessor';

sub _inline_post_body {
    return 'return $_[0] if (scalar(@_) >= 2);' . "\n";
}
1;

__END__
=pod

=head1 NAME

MooseX::ChainedAccessors::Accessor - DEPRECATED

=head1 VERSION

version 1.0.1

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

