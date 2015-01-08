#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

BEGIN { require Gtk3; }
unless (eval { Gtk3->import; 1 }) {
  my $error = $@;
  if (eval { $error->isa ('Glib::Error') &&
             $error->domain eq 'g-irepository-error-quark'})
  {
    BAIL_OUT ("OS unsupported: $error");
  } else {
    BAIL_OUT ("Cannot load Gtk3: $error");
  }
}

plan tests => 2;

SKIP: {
  diag (sprintf 'Testing against gtk+ %d.%d.%d',
        Gtk3::get_major_version (),
        Gtk3::get_minor_version (),
        Gtk3::get_micro_version ());

  @ARGV = qw(--help --name gtk2perl --urgs tree);
  skip 'Gtk3::init_check failed, probably unable to open DISPLAY', 2
    unless Gtk3::init_check ();
  Gtk3::init ();
  is_deeply (\@ARGV, [qw(--help --urgs tree)]);

  # Ensure that version parsing still works after the setlocale() done by
  # Gtk3::init().
  ok (defined eval 'use 5.8.0; 1');
}
