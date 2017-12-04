#!/usr/bin/perl -w

package Tie::Scalar::Log;

# Tie::Scalar::Log.pm:
#
# Copyright (C) 2013-2017  Justin Lee  < justin at taiz dot me >
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3
# or higher as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
# USA.
#
###
#
# History:
#
#   2012-12-11: Coded.
#


use strict;
use warnings;

use Tie::Scalar::Time::Now;

tie(my $ts, 'Tie::Scalar::Time::Now', '%04d-%02d-%02d %02d:%02d:%02d');


sub DEFAULT_FILE(){ "$ts.log" }
sub DEFAULT_JOIN(){ ': ' }


sub TIESCALAR {
  my ($self, $file, $join, $clear) = @_;

  defined($file) or
    ($file = DEFAULT_FILE);

  defined($join) or
    ($join = DEFAULT_JOIN);

  open(my $f, ($clear ? '>' : '>>'), $file) or
    die $!;

  print $f "\n\tlog open ($ts)\n\n";

  close($f) or
    warn $!;

  return (bless {file => $file, join => $join},  $self);
}

sub FETCH {
  my ($log) = @_;

  ref($log) eq __PACKAGE__ or
    warn 'Bad usage';

  return ($$log);
}

sub STORE {
  my ($log, $data) = @_;

  ref($log) eq __PACKAGE__ or
    die 'Bad usage';

  open(my $f, '>>', $log->{file}) or
    die $!;

  if (ref($data) eq 'ARRAY') {
    print $f join($log->{join}, "($ts) :", 'ARRAY', $data);

    for (my $i = 0; $i < @{$data}; $i++) {
      if (!($i % 7)) {
        print $f "\n\t";
      }

      print $f "$data->[$i], ";
    }
  } elsif(ref($data) eq 'HASH') {
    print $f join($log->{join}, "($ts) :", 'HASH', $data);

    foreach my $k (keys(%{$data})) {
      print $f "\n\t$k => $data->{$k}";
    }
  } else {
    print $f join($log->{join}, "($ts) :", $data);
  }

  print $f "\n";

  close($f) or
    warn $!;
}

sub UNTIE {
  shift->DESTROY
}

sub DESTROY {
  my ($log) = @_;

  ref($log) eq __PACKAGE__ or
    die 'Bad usage';

  open(my $f, '>>', $log->{file}) or
    die $!;

  print $f "\n\tlog end ($ts)\n";

  close($f) or
    warn $!;
}


__PACKAGE__;

