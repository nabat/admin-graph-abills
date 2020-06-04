#!/usr/bin/perl
package JSON;

use strict;
use warnings FATAL => 'all';

use Abills::Base;
use Admingraph::db::Admingraph;
use JSON;
use Data::Dumper;

my $admin;
my $db;
my $conf;


my $json        = JSON->new()->utf8(0);

sub connection_district {
  ($admin, $db, $CONF)=@_;
  print Dumper $db;
  
  my $Admingraph  = Admingraph->new($admin, $db, $CONF);
  
  my (@district_connection_array) = ();
  my $district_connection = $Admingraph->district_connection();           # Подключенные по районам (Круг)
  for my $key (sort keys %{$district_connection}){
    push @district_connection_array, {
      district_connection  => $district_connection->{$key} + 0,
      date                 => $key,
    };
  }
  my $data = $json->encode(\@district_connection_array);

  return \@district_connection_array;
}

1
