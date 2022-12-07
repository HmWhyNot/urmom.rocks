#!/usr/bin/perl
# use v5.36;
use feature "switch";
use strict;
# use warning;
# use Switch;

## To use:
## First argument is input file
## Second argument is optional output file
## If no second argument output file defaults to "(input filename)_out"


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
  # Tabs();
  TabCount();

  ###########################
  # Start of Object Process #
  ###########################
  if ($Start) {
    # # Tabs();

    if (/}/ && (@blockSkip > 0) && ($blockSkip[$#blockSkip] == $tabcount)) {
        # pop(@blockSkip);
        $paramCond = '';
        $skip = 1;
      }
    # }

    #############
    # main code #
    #############

    # if ($SQLCommand ne '' && $SQLConnection ne '') {
    #   $skip = 1;
    # }
    if (/using \((.*)\)/) {

      if (/SqlConnection.*\("(.*)"\)/) {
        $SQLConnection = $1;
        $skip = 2;
      }
      if (/SqlCommand.*\(.*"(.*)".*\)/) {
        $SQLCommand = $1;
        $skip = 2;
      }
      else {
        $skip = 2;
      }
    }
    if (/(?:var (.*) = )?Command\.(\w*)\(\)/) {
      $resultVar = $1 // '';
      $CRUDCommand = $2;
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
      # $skip ||= 1;
      next;
    }

    if (/if \((.*)\)\s*\{?\s*$/ && $CRUDCommand eq '' && $SQLCommand ne '') {
      $paramCond = $1;
      $skip = 2;
    }

    if (/Command\.Parameters\.AddWithValue\((.*)\);/) {
      my $param = "new SqlParameter(" . $1 . ")";
      if ($paramCond ne '') { $param = $paramCond . " ? " . $param . " : null" }
      push(@SQLParameters, $param . ",\n");
      $skip = 1;
    }

    # line skipping
    if ($skip > 0) {
      while (/{/g) {
        # push(@blockSkip, ($tabcount - 1));
        push(@blockSkip, $tabcount);
        # $tabcount -= 1;
      }

      # if ((/}/) && (@blockSkip > 0) && ($blockSkip[$#blockSkip] == ($tabcount))) {
      while (/}/g) {
        pop(@blockSkip);
        # $tabcount += 1;
      }
      $skip -= 1;
      next;
    }
  }

  PrintLine();
}

close $in or die "$in: $!";
close $out or die "$out: $!";
print "Done\n";



##################
# CRUD functions #
##################

sub Create {
  PrintCommand("var Result = SQL.GetScalar");

  my @lines = ();
  while (<$in>) {
    Tabs();

    if (s/$resultVar != null && $resultVar != DBNull.Value/$resultVar == null || $resultVar DBNull.Value/) {
      push(@lines, $_);
      $_ = <$in>;
      Tabs();
      push(@lines, $_);
      push(@blockSkip, ($tabcount));
      $_ = <$in>;
      Tabs();
    }

    if (/return new/ && ($blockSkip[$#blockSkip] == $tabcount)) {
      foreach (@lines) {
        PrintLine();
      }

      @lines = ();
      push(@lines, $_);
      $_ = <$in>;

      until (/return new/) {
        Tabs();
        push(@lines, $_);
        $_ = <$in>;
      }

      pop(@blockSkip);
      Tabs();
      $tabcount += 1;
      PrintLine();

      until (/};/) {
        $_ = <$in>;
        Tabs();
        $tabcount += 1;
        PrintLine();
      }

      $_ = pop(@lines);
      $tabcount -= 1;
      PrintLine();

      foreach (@lines) {
        print $out $_;
      }

      @lines = ();
      return;
    }

    PrintLine();
  }
}

sub Read {


  PrintCommand("var Result = SQL.GetResult");
  # until (/return /) {
  #   $_ = <$in>;
  # }

}

sub UpdateDelete {
  PrintCommand("SQL.Execute");
}

sub PrintCommand {
  my $command = shift;
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
    # $line = ' ' x ($tabsize * $tabcount);
    $line = ' ' x ($tabsize * ($tabcount - @blockSkip));
    s/^ *//;
  }
  
  Replacements();
  # print $out $.;
  # print $out ": ";
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

sub TabCount {
  $tabcount = 0;
  while (/^ /) {
    $tabcount += 1;
    s/^ //;
  }
  $tabcount /= $tabsize;
  # $tabcount -= @blockSkip;
}

# clear variables
sub Clear {
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