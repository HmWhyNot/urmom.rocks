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
my $tabskip = 0;
my $tabs = '';
my $Results = 0;
my $SQLConnection = '';
my $SQLCommand = '';
my @SQLParameters = ();
my $paramCond = '';
my $CRUDCommand = '';
my $resultVar = '';
my $usingCount = 0;
my $skip = 0;
my @blockSkip = ();
my $Start = 0;
my $End = 0;
while (<$in>) {

  # Starts the process for object when try is hit
  if (/try/) {
    $tabcount = 0;
    $tabskip = 0;
    # while (/^ /) {
    #   $tabcount += 1;
    #   s/ //;
    # }
    $tabcount /= $tabsize;
    $End = $tabcount - 1;
    $Start = 1;
  }

  ###########################
  # Start of Object Process #
  ###########################
  if ($Start) {
    Tabs();
    # $tabs = ' ' x ($tabsize * $tabcount);

    # # increases tab for start of blocks
    # if (/{/g) {
    #   $tabcount += 1;
    # }
    # # decreases tabs for end of blocks
    # if (/}/g) {
    #   # if ($tabcount == $End) {
    #   #   $Start = 0;
    #   #   $End = 0;
    #   #   $usingCount = 0;
    #   #   $skip = 0;
    #   # }
    #   if ((@blockSkip > 0) && ($blockSkip[$#blockSkip] == $tabcount - 1)) {
    #     pop(@blockSkip);
    #     $paramCond = '';
    #     # $skip = 1;
    #     $skip = 2;
    #   }
    #   else {
    #     $tabcount -= 1;
    #   }
    #   $tabs = ' ' x ($tabsize * $tabcount);
    #   if ($tabcount == $End) {
    #     $Start = 0;
    #     $End = 0;
    #     $usingCount = 0;
    #     # $skip = 0;
    #   }
    # }

    # # deletes lines until skip = 0
    # if ($skip > 0) {
    #   if (/{/) {
    #     $tabcount -= 1;
    #     push(@blockSkip, ($tabcount - 1));
    #   }
    #   $skip -= 1;
    #   next;
    # }

    # sets tabs for line
    # s/^ */$tabs/;
    # s/^ *//;


    if (/}/g) {
      if ((@blockSkip > 0) && ($blockSkip[$#blockSkip] == $tabcount - 1)) {
        pop(@blockSkip);
        $paramCond = '';
        # $skip = 1;
        $skip = 2;
      }
    }

    # line skipping
    if ($skip > 0) {
      $skip -= 1;
      next;
    }

    #############
    # main code #
    #############

    if (/using \((.*)\)/) {

      if (/SqlConnection.*\("(.*)"\)/) {
        $SQLConnection = ${^CAPTURE[0]};
        # $skip = 1;
        $skip = 2;
      }
      if (/SqlCommand.*\(.*"(.*)".*\)/) {
        $SQLCommand = ${^CAPTURE[0]};
        # $skip = 1;
        $skip = 2;
      }
      else {
        #
      }
      $usingCount += 1;
      # next;
    }
    # if (/Command\.(.*)\(\)/) {
      if (/(?:var (.*) = )?Command\.(.*)\(\)/) {
      $resultVar = ${^CAPTURE[0]} || '';
      $CRUDCommand = ${^CAPTURE[1]};
      # ExecuteScalar = Create
      # ExecuteReader = Read
      # ExecuteNonQuery = Update/Delete
      print $CRUDCommand;
      print "\n";

      if ($CRUDCommand eq 'ExecuteScalar') { # Create
        Create();
      }
      if ($CRUDCommand eq 'ExecuteReader') { # Read
        Read();
      }
      if ($CRUDCommand eq 'ExecuteNonQuery') { # Update/Delete
        UpdateDelete();
      }
      # next;
      $skip = 1;
    }

    if ($usingCount == 2) {
      if (/if \((.*)\)/ && $CRUDCommand eq '') {
        $paramCond = ${^CAPTURE[0]};
        # $skip = 1;
        $skip = 2;
        # next;
      }
    }

    # s/Command\.Parameters\.AddWithValue\((.*)\);/new SqlParameter($1),/g;
    if (/Command\.Parameters\.AddWithValue\((.*)\);/) {
      my $param = "new SqlParameter(" . ${^CAPTURE[0]} . ")";
      if ($paramCond ne '') { $param = $paramCond . " ? " . $param . " : null" }
      push(@SQLParameters, $param . ",\n");
      # push(@SQLParameters, ${^CAPTURE[0]});
      # next;
      $skip = 2;
    }

    # simple substitutions

    # s/$resultVar/Result/g unless $resultVar eq '';
    # if ($Results) {
    #   s/DataReader\.GetValue\(DataReader\.GetOrdinal\(("[a-zA-Z_]*?")\)\)/r.GetValue($1)/g;
    # }
    # else {
    #   s/DataReader\.GetValue\(DataReader\.GetOrdinal\(("[a-zA-Z_]*?")\)\)/Result.GetValue($1)/g;
    # }
    # s/Convert\.(To[a-zA-Z0-9]*)\((.*?\))\)/$2.$1()/g;
    # s/\.ToInt32\(\)/.ToShort()/g;
    # s/\.ToInt64\(\)/.ToLong()/g;


    # deletes lines until skip = 0
    if ($skip > 0) {
      if (/{/) {
        $tabcount -= 1;
        push(@blockSkip, ($tabcount - 1));
      }
      $skip -= 1;
      next;
    }

    # s/^/$tabs/;
  }


  Replacements($_);
  print $out $_;
}

close $in or die "$in: $!";
close $out or die "$out: $!";
print "Done\n";



##################
# CRUD functions #
##################

sub Create {
  UpdateDelete("var Result = SQL.GetScalar");

  my @lines =[];
  while (<$in>) {
    Tabs();
    print $out $_;
  }
  print "poop";

  # if (/if/) {
  #   #
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
  # my $command = (@_) ? shift : "SQL.Execute";
  # print $out $tabs;
  # print $out $command . '("' . $SQLConnection . '", "' . $SQLCommand . '", new SqlParameter[] {' . "\n";

  # foreach (@SQLParameters) {
  #   print $out ' ' x $tabsize . $tabs;
  #   # print $out "new SqlParameter(", $_, "),\n";
  #   print $out $_;
  # }

  # print $out $tabs;
  # print $out "});\n";
}

sub PrintLine {
  #
}


# simple replacements
sub Replacements {
  s/$resultVar/Result/g unless $resultVar eq '';
  if ($Results) {
    s/DataReader\.GetValue\(DataReader\.GetOrdinal\(("[a-zA-Z_]*?")\)\)/r.GetValue($1)/g;
  }
  else {
    s/DataReader\.GetValue\(DataReader\.GetOrdinal\(("[a-zA-Z_]*?")\)\)/Result.GetValue($1)/g;
  }
  s/Convert\.(To[a-zA-Z0-9]*)\((.*?\))\)/$2.$1()/g;
  s/\.ToInt32\(\)/.ToShort()/g;
  s/\.ToInt64\(\)/.ToLong()/g;
}

sub Tabs {

  tabcount = 0;
  my $tabskip = @blockSkip;

  while (/^ /) {
    $tabcount += 1;
    s/^ /^/;
  }
  $tabcount /= $tabsize;
  $tabcount -= $tabskip;

  my $tab = ' ' x ($tabsize * $count);
  s/^/$tab/;
}


# sub Tabs {
#   $tabs = ' ' x ($tabsize * $tabcount);

#   # increases tab for start of blocks
#   if (/{/g) {
#     $tabcount += 1;
#   }
#   # decreases tabs for end of blocks
#   if (/}/g) {
#     # if ($tabcount == $End) {
#     #   $Start = 0;
#     #   $End = 0;
#     #   $usingCount = 0;
#     #   $skip = 0;
#     # }
#     if ((@blockSkip > 0) && ($blockSkip[$#blockSkip] == $tabcount - 1)) {
#       pop(@blockSkip);
#       $paramCond = '';
#       $skip = 1;
#       # $skip = 2;
#     }
#     else {
#       $tabcount -= 1;
#     }
#     $tabs = ' ' x ($tabsize * $tabcount);
#     if ($tabcount == $End) {
#       $Start = 0;
#       $End = 0;
#       $usingCount = 0;
#       $skip = 0;
#     }
#   }
#   s/^ */$tabs/;
# }


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