#!/usr/bin/perl
################################################################################
#                                                                              #
# ############################################################################ #
# # Title       : Tie::Scalar::Now.pm                                        # #
# # Description : Extremely basic module for fetching the date and/or time   # #
# #               with localtime(time).                                      # #
# # Coded by    : Justin "Snowed In" Lee                                     # #
# # License     : GNU General Public License v.2                             # #
# #               Copyright (C) 2008  Justin Lee  <kool.name at gmail.com>   # #
# ############################################################################ #
#                                                                              #
# ############################################################################ #
# # This program is free software; you can redistribute it and/or            # #
# # modify it under the terms of the GNU General Public License version 2    # #
# # as published by the Free Software Foundation.                            # #
# #                                                                          # #
# # This program is distributed in the hope that it will be useful,          # #
# # but WITHOUT ANY WARRANTY; without even the implied warranty of           # #
# # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            # #
# # GNU General Public License for more details.                             # #
# #                                                                          # #
# # You should have received a copy of the GNU General Public License        # #
# # along with this program; if not, write to the Free Software              # #
# # Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA            # #
# # 02110-1301, USA.  Or, see: <http://www.gnu.org/licenses/>                # #
# ############################################################################ #
#                                                                              #
################################################################################

package Tie::Scalar::Time::Now;

use strict;
use warnings;
use Carp;

## _flt :: fix localtime ##
## given the localtime array
## returns the useful bits
## in the reverse order
sub _flt (@) {
  if (@_ == 9) {
    $_[5] += 1900;
    $_[4] += 1;
    return reverse(@_[0..5]);
  } else {
    confess 'Localtime error';
  }
}

sub TIESCALAR {
  my $class = shift;
  my $format = shift;

  if (defined($format)) {
    return bless { FORMAT => $format }, $class;
  } else {
    return bless { FORMAT => '%4d-%02d-%02d %02d.%02d.%02d' }, $class;
  }
}

sub FETCH {
  my $self = shift;

  ref($self) or
    confess scalar(caller) . ': Reference error';

  return sprintf($self->{FORMAT},_flt(localtime(time)));
}

sub STORE {
  my $self = shift;

  ref($self) or
    confess scalar(caller) . ': Reference error';

  return sprintf($self->{FORMAT},_flt(localtime(time)));
}

sub UNTIE {
  my $self = shift;

  ref($self) or
    confess scalar(caller) . ': Reference error';

  undef($self);
}

sub DESTROY {
  my $self = shift;

  ref($self) or
    confess scalar(caller) . ': Reference error';

  undef($self);
}

'True!';
