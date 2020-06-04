#!/usr/bin/perl
package Admingraph;

use strict;
use parent 'dbcore';
use POSIX qw(strftime);

my $localyear   = strftime "%Y", localtime;
my $localmonth  = strftime "%m", localtime;

sub new {
  my ($class, $db, $admin, $CONF) = @_;
  
  my $self = {
    db    => $db,
    admin => $admin,
    conf  => $CONF
  };

  bless($self, $class);

  return $self;
}

sub district_connection {

  my $self = shift;
  my ($attr) = @_;

  my $one_year_ago  = $localyear - 1;
  my $date          = $one_year_ago . "-" . $localmonth . "%"; 

  $self->query("SELECT districts.name AS rayon, COUNT(*) AS count  FROM users
    LEFT JOIN users_pi ON users.uid = users_pi.uid     
    LEFT JOIN  builds ON builds.id = users_pi.location_id 
    LEFT JOIN streets ON streets.id = builds.street_id
    LEFT JOIN districts ON districts.id = streets.district_id      
    WHERE registration like '$date' GROUP BY rayon;", 
    undef, { LIST2HASH => 'rayon, count' }
  );

  return $self->{list_hash};
}

1;
