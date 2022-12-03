#!/usr/bin/perl
use v5.36;
use feature "switch";
# use strict;
# use warning;
# use Switch;


my $in;
my $out;
open($in, "< :encoding(UTF-8)", $ARGV[0]) or die "Can't open $ARGV[0]: $!. -> Stopped";
# open($out, ">> :encoding(UTF-8)", $ARGV[1]) or open($out, ">>", "$ARGV[0]_out");
# open($out, ">>", "$ARGV[0]_out") or die "Can't open $ARGV[0]_out: $!. -> Stopped";
if ($ARGV[1]) {
  open($out, ">", "$ARGV[1]") or die $!;
}
else {
  open($out, ">", "$ARGV[0]_out") or die $!;
}

my $tabsize = 4;
my $tabcount = 0;
my $tabs = '';
my $Results = 0;
my $SQLConnection = '';
my $SQLCommand = '';
my @SQLParameters = ();
my $paramCond = '';
my $CRUDCommand = '';
my $resultVar = '';
my $skip = 0;
my @blockSkip = ();
my $Start = 0;
while (<$in>) {

  # Starts the process for object when try is hit
  if (/^ *try/) {
    $Start = 1;
  }
  if (/^ *catch/) {
    Clear();
    $Start = 0;
  }
  Tabs();

  ###########################
  # Start of Object Process #
  ###########################
  if ($Start) {
    # # Tabs();

    if (/}/g && (@blockSkip > 0) && ($blockSkip[$#blockSkip] == $tabcount)) {
      # if ((@blockSkip > 0) && ($blockSkip[$#blockSkip] == $tabcount)) {
        pop(@blockSkip);
        $paramCond = '';
        $skip = 1;
      }
    # }

    #############
    # main code #
    #############

    if (/using \((.*)\)/) {

      if (/SqlConnection.*\("(.*)"\)/) {
        $SQLConnection = ${^CAPTURE[0]};
      }
      if (/SqlCommand.*\(.*"(.*)".*\)/) {
        $SQLCommand = ${^CAPTURE[0]};
      }
      else {
        #
      }
      $skip = 2;
    }
    if (/(?:var (.*) = )?Command\.(\w*)\(\)/) {
      $resultVar = ${^CAPTURE[0]} || '';
      $CRUDCommand = ${^CAPTURE[1]};
      # ExecuteScalar = Create
      # ExecuteReader = Read
      # ExecuteNonQuery = Update/Delete
      print $CRUDCommand;
      print "\n";

      my %Command = (
        'ExecuteScalar' => \&Create,
        'ExecuteReader' => \&Read,
        'ExecuteNonQuery' => \&UpdateDelete
      );
      ($Command{$CRUDCommand} || sub {})->();

      # if ($CRUDCommand eq 'ExecuteScalar') { # Create
      #   Create();
      # }
      # if ($CRUDCommand eq 'ExecuteReader') { # Read
      #   Read();
      # }
      # if ($CRUDCommand eq 'ExecuteNonQuery') { # Update/Delete
      #   UpdateDelete();
      # }
      $skip = $skip || 1;
    }

    if (/if \((.*)\)/ && $CRUDCommand eq '' && $SQLCommand ne '') {
      $paramCond = ${^CAPTURE[0]};
      $skip = 2;
    }

    # s/Command\.Parameters\.AddWithValue\((.*)\);/new SqlParameter($1),/g;
    if (/Command\.Parameters\.AddWithValue\((.*)\);/) {
      my $param = "new SqlParameter(" . ${^CAPTURE[0]} . ")";
      if ($paramCond ne '') { $param = $paramCond . " ? " . $param . " : null" }
      push(@SQLParameters, $param . ",\n");
      $skip = 1;
    }

    # line skipping
    if ($skip > 0) {
      if (/{/) {
        push(@blockSkip, ($tabcount - 1));
      }
      $skip -= 1;
      next;
    }
  }


  # Replacements($_);
  # print $out $_;
  PrintLine();
}

close $in or die "$in: $!";
close $out or die "$out: $!";
print "Done\n";



##################
# CRUD functions #
##################

sub Create {
  UpdateDelete("var Result = SQL.GetScalar");

  my @lines = ();
  my $next = 0;
  my $end = 0;
  while (<$in>) {
    Tabs();

    # if (/if \((.*)\)/) {
    #   s/$resultVar != null && $resultVar != DBNull.Value/$resultVar == null || $resultVar DBNull.Value/;
    # }
    if (s/$resultVar != null && $resultVar != DBNull.Value/$resultVar == null || $resultVar DBNull.Value/) {
      # $next = 2;
      
      push(@lines, $_);
      $_ = <$in>;
      Tabs();
      push(@lines, $_);
      push(@blockSkip, ($tabcount - 1));
    }
    if (/return new/ && ($blockSkip[$#blockSkip] == $tabcount)) {
      foreach (@lines) {
        PrintLine();
      }
      push(@lines, $_);
      until (/};/) {
        $_ = <$in>;
        Tabs();
        push(@lines, $_);
      }
    }

    # if ($next > 0) {
    #   if (/{/) {
    #     push(@blockSkip, ($tabcount - 1));
    #   }
    #   push(@lines, $_);
    #   print "push";
    #   print $_;
    #   print @lines;
    #   $next -= 1;
    #   next;
    # }
    if (/}/g && ($blockSkip[$#blockSkip] == $tabcount)) {
      $tabcount += 1;
      foreach (@lines) {
        print $_;
        PrintLine();
      }
      pop(@blockSkip);
      print $.;
      $end = 1;
    }

    # print $out $_;
    PrintLine();
    if ($end) { print $.; }
    return if ($end)
  }

  # if (/if \((.*)\)/) {
  #   s/$resultVar != null && $resultVar != DBNull.Value/poo/;
  #   s/Result != null && Result != DBNull.Value/poo/;
  #   PrintLine();
  # }

  # Replacements($_);
  # s/^/$tabs/;
  # print $out $_;
  # $_ = <$in>;
}

sub Read {
  #

  Replacements($_);
}

sub UpdateDelete {
  my $command = (@_) ? shift : "SQL.Execute";
  $_ = $command . '("' . $SQLConnection . '", "' . $SQLCommand . '", new SqlParameter[] {' . "\n";
  PrintLine();

  $tabcount += 1;
  foreach (@SQLParameters) {
    PrintLine();
  }
  $tabcount -= 1;

  $_ = "});\n";
  PrintLine();
}


#####################
# Utility functions #
#####################

# print line with tabs
sub PrintLine {
  my $line = '';
  if ($tabcount) {
    $line = ' ' x ($tabsize * $tabcount);
    s/^ *//;
  }
  
  Replacements($_);
  print $out $line . $_;
}


# simple replacements
sub Replacements {
  s/$resultVar/Result/g unless $resultVar eq '';
  if ($Results) {
    s/DataReader\.GetValue\(DataReader\.GetOrdinal\(("\w*?")\)\)/r.GetValue($1)/g;
  }
  else {
    s/DataReader\.GetValue\(DataReader\.GetOrdinal\(("\w*?")\)\)/Result.GetValue($1)/g;
  }
  s/Convert\.(To\w*)\((.*?\))\)/$2.$1()/g;
  s/\.ToInt32\(\)/.ToShort()/g;
  s/\.ToInt64\(\)/.ToLong()/g;
}

# set $tabcount
sub Tabs {
  $tabcount = 0;
  while (/^ /) {
    $tabcount += 1;
    s/^ //;
  }
  $tabcount /= $tabsize;
  $tabcount -= @blockSkip;

  $tabs = ' ' x ($tabsize * $tabcount);
  s/^/$tabs/;
}

# clear variables
sub Clear() {
  $tabs = '';
  $Results = 0;
  $SQLConnection = '';
  $SQLCommand = '';
  @SQLParameters = ();
  $paramCond = '';
  $CRUDCommand = '';
  $resultVar = '';
  $skip = 0;
  @blockSkip = ();
}


#using \(SqlCommand Command = new SqlCommand\("(.*?)", Connection\)\)
#replace to
#var Result = SQL.GetResult("PrimaryDB", "$1", new SqlParameter[] {

#Command\.Parameters\.AddWithValue\((.*)\);
#replace to
#new SqlParameter($1),

#TotalResults = Output.Count,
#replace to
#TotalResults = Results[0].GetValue("TotalResults").ToInt(),


#DataReader\.GetValue\(DataReader\.GetOrdinal\(("[a-zA-Z_]*?")\)\)
#replace to
#Result.GetValue($1)
#r.GetValue($1)

#Convert.ToInt32\((.*?\))\)
#replace to
#$1.ToShort()

#Convert.ToInt64\((.*?\))\)
#replace to
#$1.ToLong()

#Convert\.(To[a-zA-Z0-9]*)\((.*?\))\)
#replace to
#$2.$1()