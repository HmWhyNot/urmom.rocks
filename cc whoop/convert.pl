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
my @retSkip = ();
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
  TabCount();

  ###########################
  # Start of Object Process #
  ###########################
  if ($Start) {

    if (/}/ && (@blockSkip > 0) && ($blockSkip[$#blockSkip] == $tabcount)) {
        $paramCond = '';
        $skip = 1;
      }

    #############
    # main code #
    #############

    if (/using \((.*)\)/) {

      if (/SqlConnection.*\("(.*)"\)/) {
        $SQLConnection = $1;
        $skip = 2;
      }
      elsif (/SqlCommand.*\(.*"(.*)".*\)/) {
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
      $skip ||= 1;
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

    Skip();
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

    if (s/$resultVar != null && $resultVar != DBNull.Value/$resultVar == null || $resultVar DBNull.Value/) {
      push(@lines, $_);
      $_ = <$in>;
      push(@lines, $_);
      $_ = <$in>;
      TabCount();
      push(@blockSkip, ($tabcount));
    }
    else {
      TabCount();
    }

    if (/return new/ && ($blockSkip[$#blockSkip] == $tabcount)) {
      pop(@blockSkip);
      my $tc = $tabcount;
      foreach (@lines) {
        TabCount();
        PrintLine();
      }

      @lines = ();
      $tabcount = $tc - 1;
      SetTabs();
      push(@lines, $_);
      $_ = <$in>;

      until (/return new/) {
        TabCount();
        $tabcount -= 1;
        SetTabs();
        push(@lines, $_);
        $_ = <$in>;
      }

      TabCount();
      $tabcount += 1;
      PrintLine();

      until (/};/) {
        $_ = <$in>;
        TabCount();
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

  $_ = <$in>;
  push(@blockSkip, $tabcount);
  $tabcount += 1;
  my @bs = @blockSkip;
  my @lines = ();
  my $rType = '';
  $resultVar = 'Result';
  while (<$in>) {
    while (/{/g) {
      push(@blockSkip, $tabcount);

      $tabcount += 1;
    }
    while (/}/g) {
      pop(@blockSkip);
      $tabcount -= 1;
    }

    if (s/if \(DataReader\.HasRows\)/' ' x $tabsize . 'if (Result != null && Result.Count > 0)'/e) {
      push(@lines, $_);
      $_ = <$in>;
      s/^/' ' x $tabsize/e;
    }
    if (/List<(.*)> Output = new List<\1>\((.*)\);/) {
      $Results = 1;
      $resultVar = 'Results';
      $rType = $1;
      $_ = <$in>;
    }
    if (/while \(DataReader\.Read\(\)\)/) {
      push(@blockSkip, $tabcount);
      push(@bs, $tabcount);
      $_ = <$in>;
      last;
    }
    push(@lines, $_);
  }
  

  $tabcount += 1;
  PrintCommand("var " . $resultVar . " = SQL.Get" . $resultVar);
  @blockSkip = @bs;

  foreach (@lines) {
    TabCount();
    PrintLine();
  }
  if ($Results) {
    $_ = <$in>;
    $tabcount += 1;
    PrintLine();
  }
  $skip = 0;
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
  if ($tabcount) {
    my $tc = $tabcount;
    SetTabs();
    $tabcount = $tc;
  }
  
  Replacements();
  print $out $_;
}


# simple replacements
sub Replacements {
  # if ($resultVar eq 'Results') {
  if ($Results) {
    # s/$resultVar/Results/g unless $resultVar eq '';
    s/DataReader\.GetValue\(DataReader\.GetOrdinal\(("\w*?")\)\)/r.GetValue($1)/g;
  }
  else {
    s/$resultVar/Result/g unless $resultVar eq '';
    s/DataReader\.GetValue\(DataReader\.GetOrdinal\(("\w*?")\)\)/Result.GetValue($1)/g;
  }
  s/Convert\.(To\w*)\((.*?\))\)/$2.$1()/g;
  s/\.ToInt32\(\)/.ToShort()/g;
  s/\.ToInt64\(\)/.ToLong()/g;
}

# set $tabcount
sub Skip {
  if ($retSkip[$#retSkip] == $tabcount) {
    pop (@retSkip);
    until (/};/) {
      $_ = <$in>;
    }
    $skip = 1;
  }
  if ($skip > 0) {
    while (/{/g) {
      push(@blockSkip, $tabcount);
    }

    while (/}/g && (@blockSkip > 0) && ($blockSkip[$#blockSkip] == ($tabcount))) {
      pop(@blockSkip);
    }
    $skip -= 1;
    next;
  }
}

sub SkipRet {
  #
}

sub TabCount {
  $tabcount = 0;
  while (/^ /) {
    $tabcount += 1;
    s/^ //;
  }
  $tabcount /= $tabsize;
}

sub SetTabs {
  $tabs = ' ' x ($tabsize * ($tabcount - @blockSkip));
  s/^ */$tabs/;
  $tabcount = 0;
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