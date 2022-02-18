#!/usr/bin/perl -w
#===============================================================================
#
# gen_cipher.pl - A Homophonic Cipher Generator
#
#   Copyright 2007, Michael F. Cole
# 
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
# 
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
# 
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#===============================================================================

use strict;

#===============================================================================
# PACKAGE: Letter - Plaintext Letter
#===============================================================================

package Letter;

sub new 
{
    my ($proto, $char) = @_;
    my $class = ref($proto) || $proto;
    my $self  = {};

    #
    # Initialize data
    #
    $self->{'sym_insts'}             = [];
    $self->{'syms'}                  = [];
    $self->{'target_sym_count'}      = 0;
    $self->{'init_target_sym_count'} = 0;
    $self->{'count'}                 = 0;
    $self->{'char'}                  = $char;

    bless ($self, $class);
    return $self;
}


sub get_char
{
    my $self = shift;
    return $self->{'char'};
}


sub incr_count
{
    my $self = shift;
    $self->{'count'}++;
}


sub get_count
{
    my $self = shift;
    return $self->{'count'};
}


sub add_sym_inst
{
    my ($self, $sym_inst) = @_;

    #
    # Add the symbol instance to the array of symbol instances
    #
    push @{ $self->{'sym_insts'} }, $sym_inst;
}


sub add_sym
{
    my ($self, $sym) = @_;
    push @{ $self->{'syms'} }, $sym;
}


sub get_syms
{
    my $self = shift;
    return $self->{'syms'};
}


sub set_target_sym_count
{
    my ($self, $count) = @_;
    $self->{'target_sym_count'} = $count;
}


sub get_target_sym_count
{
    my $self = shift;
    return $self->{'target_sym_count'};
}


sub set_init_target_sym_count
{
    my ($self, $count) = @_;
    $self->{'init_target_sym_count'} = $count;
}


sub get_init_target_sym_count
{
    my $self = shift;
    return $self->{'init_target_sym_count'};
}


sub get_random_sym
{
    my $self      = shift;
    my $refa_syms = $self->{'syms'};
    my $index     = int(rand(@$refa_syms));

    #
    # Return the symbol
    #
    return $refa_syms->[$index];
}

sub adjust_target_sym_count
{
    my ($self, $value) = @_;

    #
    # Calculate the proposed symbol count
    #
    my $proposed_count = $self->{'target_sym_count'} + $value;

    #
    # Is this adjustment legit?
    #
    if ($proposed_count <= 0) {
        #
        # Indicate failure
        #
        return 0;
    }

    #
    # We cannot have more symbols than the number of instances of our
    # letter
    #
    if ($proposed_count > $self->{'count'}) {
        return 0;
    }

    #
    # All is well, make the adjustment
    #
    $self->{'target_sym_count'} = $proposed_count;

    #
    # Indicate success
    #
    return 1;
}


sub fixup_syms
{
    my $self      = shift;
    my $refa_syms = $self->{'syms'};

    my @syms_assigned;
    my @syms_unassigned;

    #
    # Iterate over the symbols
    #
    foreach my $sym (@$refa_syms) {
        #
        # Put the symbol in the right array
        #
        if ($sym->get_count > 0) {
            push @syms_assigned, $sym;
        }
        else {
            push @syms_unassigned, $sym;
        }
    }

    #
    # While we have unassigned symbols remaining
    #
    while (@syms_unassigned) {
        #
        # Get one of the unassigned symbols
        #
        my $sym_unassigned = pop(@syms_unassigned);
        my $sym_steal;

        #
        # Find an assigned symbol from which we can steal an
        # assignment
        #
        do {
            #
            # Get the random index into the array
            #
            my $index = int(rand(@syms_assigned));
            
            #
            # Extract the symbol
            #
            $sym_steal = splice(@syms_assigned, $index, 1);

        } until ($sym_steal->get_count() > 1);

        #
        # Take one of the symbol instances
        #
        my $sym_inst = $sym_steal->pop_sym_inst();

        #
        # And give it to our neglected symbol
        #
        $sym_unassigned->push_sym_inst($sym_inst);

        #
        # Finally, update the symbol instance
        #
        $sym_inst->set_sym($sym_unassigned);
    }
}



#===============================================================================
# PACKAGE: Sym - Symbol
#===============================================================================

package Sym;

my @g_all_syms;
my $g_sym_id;
my $g_ascii_index = 48;

sub set_ascii_index
{
    my ($pkg, $value) = @_;
    $g_ascii_index    = $value;
}

sub get_all_syms
{
    return \@g_all_syms;
}

sub new 
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {};

    $self->{'count'}     = 0;
    $self->{'sym_insts'} = [];
    $self->{'id'}        = ++$g_sym_id;
    $self->{'ascii'}     = chr($g_ascii_index);
    $self->{'letter'}    = undef;

    #
    # Bump the ASCII index
    #
    $g_ascii_index++;

    #
    # Skip these troublesome characters in case we want to output to HTML
    #
    if ((chr($g_ascii_index) eq "<") || (chr($g_ascii_index) eq ">")) {
        $g_ascii_index++;
    }

    #
    # Save off this symbol
    #
    push @g_all_syms, $self;

    bless ($self, $class);
    return $self;
}


sub get_count
{
    my $self = shift;
    return scalar( @{ $self->{'sym_insts'} } );
}


sub push_sym_inst
{
    my ($self, $sym_inst) = @_;
    push @{ $self->{'sym_insts'} }, $sym_inst;
}


sub pop_sym_inst
{
    my $self = shift;
    return pop( @{ $self->{'sym_insts'} } )
}


sub set_letter
{
    my ($self, $letter) = @_;
    $self->{'letter'} = $letter;
}


sub get_letter
{
    my $self = shift;
    return $self->{'letter'};
}


sub get_id
{
    my $self = shift;
    return $self->{'id'};
}


sub get_ascii
{
    my $self = shift;
    return $self->{'ascii'};
}

#===============================================================================
# PACKAGE: SymInst - Symbol Instance
#===============================================================================

package SymInst;

sub new 
{
    my ($proto)  = @_;
    my $class  = ref($proto) || $proto;
    my $self   = {};

    #
    # Associate the symbol-instance with the given letter
    #
    $self->{'letter'} = undef;
    $self->{'sym'}    = undef;

    bless ($self, $class);
    return $self;
}

sub set_sym
{
    my ($self, $sym) = @_;
    $self->{'sym'} = $sym;
}


sub get_sym
{
    my $self = shift;
    return $self->{'sym'};
}


sub set_letter
{
    my ($self, $letter) = @_;

    #
    # Sanity check
    #
    die "SymInst already as a letter object" if defined($self->{'letter'});

    #
    # Connect the two up
    #
    $self->{'letter'} = $letter;
    $letter->add_sym_inst($self);
}

sub get_letter
{
    my $self = shift;
    return $self->{'letter'};
}


sub assign_sym_randomly
{
    my $self   = shift;
    my $letter = $self->{'letter'};

    #
    # Pick a symbol randomly
    #
    my $sym = $letter->get_random_sym();

    #
    # Connect 'em up
    #
    $self->{'sym'} = $sym;
    $sym->push_sym_inst($self);
}



#===============================================================================
# PACKAGE: Cipher
#===============================================================================

package Cipher;

sub new 
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {};

    #
    # These seems like a good defaults
    #
    $self->{target_length}    = 340;
    $self->{target_sym_count} =  60;
    $self->{cols}             =  17;
    
    #
    # An array for the symbol instances in the cipher
    #
    $self->{'sym_insts'} = [];

    #
    # A hash to map letters to their respective letter objects
    #
    $self->{'letters'} = {};

    #
    # An array for all of the letter objects in the cipher
    #
    $self->{'all_letters'} = [];

    bless ($self, $class);
    return $self;
}


sub set_target_length
{
    my ($self, $length) = @_;
    $self->{'target_length'} = $length;
}

sub get_target_length 
{
    my $self = shift;
    return $self->{'target_length'};
}

sub set_cols
{
    my ($self, $cols) = @_;
    $self->{'cols'} = $cols;
}

sub valid
{
    my ($c) = @_;
    
    if ($c =~ /^[a-zA-Z]$/) {
        return 1;
    }
}

sub done
{
    my $self = shift;

    #
    # Get the target length
    #
    my $target_length = $self->{'target_length'};

    #
    # This is the number of entries in the sym_insts array
    #
    my $actual_length = @{ $self->{'sym_insts'} };

    #
    # This should never get to be >, but just in case...
    #
    return ($actual_length >= $target_length);
}


sub get_or_make_letter
{
    my ($self, $char) = @_;

    #
    # Check to see if the letter object already exists
    #
    if (exists($self->{'letters'}->{$char})) {
        #
        # Letter object already exists
        #
        my $letter = $self->{'letters'}->{$char};

        #
        # Bump the count
        #
        $letter->incr_count();

        return $letter;
    }

    #
    # Letter object does not yet exist, create it...
    #
    my $letter = new Letter($char);

    #
    # Count this initial instance
    #
    $letter->incr_count();

    #
    # Put it into the letter hash for future reference
    #
    $self->{'letters'}->{$char} = $letter;

    #
    # We need a letter array also, so save it off
    #
    push @{ $self->{'all_letters'} }, $letter;

    #
    # And return it
    #
    return $letter;
}


sub get_all_letters
{
    my $self = shift;
    return $self->{'all_letters'};
}

sub add_sym_inst
{
    my ($self, $c) = @_;

    #
    # Get the letter object for this character
    #
    my $letter = $self->get_or_make_letter($c);

    #
    # Create the symbol instance
    #
    my $sym_inst = new SymInst;

    #
    # And set the letter
    #
    $sym_inst->set_letter($letter);

    #
    # Push it onto our array of symbol instances
    #
    push @{ $self->{'sym_insts'} }, $sym_inst;
}

sub process_char
{
    my ($self, $c) = @_;

    #
    # Is this a character we're interested in?
    #
    if (!&valid($c)) {
        return;
    }

    #
    # It's valid!  Get a new symbol instance for this letter
    #
    $self->add_sym_inst($c);
}

sub build_from_file
{
    my ($self, $file, $uppercase) = @_;

    open(FILE, $file) or die "Could not open '$file' : $!";

    #
    # Iterate over the lines of the file
    #

OUTER:
    while (<FILE>) {
        #
        # Get rid of the newline
        #
        chomp;

        #
        # Rename the line so it's not so cryptic (so to speak...)
        #
        my $line = $_;

        #
        # Get the length of the line
        #
        my $len = length($line);

        #
        # Consider each character
        #
        for (my $i=0; $i<$len; ++$i) {
            #
            # Extract the next character
            #
            my $char = substr($line, $i, 1);

            #
            # Fold the case
            #
            $char = $uppercase ? uc($char) : lc($char);
             
            #
            # And process it
            #
            $self->process_char($char);

            #
            # Are we done yet?
            #
            if ($self->done) {
                last OUTER;
            }
        }
    }
    
    #
    # Get the target length
    #
    my $target_length = $self->{'target_length'};

    #
    # Make sure we're done because we finished building the cipher
    #
    if (!$self->done) {
        die "Could not generate cipher of length $target_length from '$file'";
    }

    print "INFO: Text of length $target_length successfully read\n";
    
    #
    # All is well, close the file
    #
    close(FILE);
}


sub adjust_sym_count_randomly
{
    my ($self, $count, $value) = @_;

    #
    # While we're not done...
    #
    while ($count > 0) {
        #
        # Get a random letter
        #
        my $letter = $self->get_random_letter();

        #
        # Increment the target symbol count by 1.  If this would make
        # the symbol count > the letter count, the operation will fail
        # (e.g. a letter that occurs only once cannot have two
        # symbols). 
        #
        if ($letter->adjust_target_sym_count($value)) {
            #
            # Successful adjustment.  Decrement our remaining symbol
            # count.
            #
            $count--;
        }
    }
}


sub distribute_syms
{
    my ($self, $total_sym_count) = @_;

    #
    # Get the number of symbol instances
    #
    my $num_sym_insts = @{ $self->{'sym_insts'} };

    #
    # We want $total_sym_count symbols assigned across $num_sym_insts
    # symbol instances.  Obivously, there are different approaches we
    # could take here.  For now, let's do the following:
    #
    #   FRAC     = ($letter->get_count() / $num_sym_insts)
    #   NUM SYMS = FRAC * $total_sym_count
    # 

    #
    # Get all of the letter objects
    #
    my $refa_letters = $self->get_all_letters();

    #
    # Use this variable to keep track of how many symbols we have yet
    # to allocate
    #
    my $syms_remaining = $total_sym_count;

    #
    # Iterate over the letters
    #
    foreach my $letter (@$refa_letters) {
        #
        # Get the count for this letter
        #
        my $letter_count = $letter->get_count();

        #
        # Calculate the target symbol count for this letter.  Round down.
        #
        my $target_sym_count = int(($letter_count / $num_sym_insts) * $total_sym_count);

        #
        # Record this value for reporting
        #
        $letter->set_init_target_sym_count($target_sym_count);

        #
        # A given letter must have >= 1 symbols
        #
        $target_sym_count = 1 if ($target_sym_count == 0);

        #
        # Subtract these symbols from our total
        #
        $syms_remaining -= $target_sym_count;

        #
        # And record the calculated value
        #
        $letter->set_target_sym_count($target_sym_count);
    }

    #
    # We were mostly rounding down, so we probably have some left over
    # symbols.  However, if we have a lot of letters with a single
    # occurrence, I suppose it's possible we have exceeded our symbol
    # target.  Therefore, support adjustements in either direction.
    #
    if ($syms_remaining != 0) {
        #
        # Do we have to add symbols or take them away?
        #
        my $adjustment = ($syms_remaining > 0) ? 1 : -1;

        #
        # Now make the number of symbols to process a positive number
        #
        $syms_remaining = abs($syms_remaining);

        #
        # And do it...
        #
        $self->adjust_sym_count_randomly($syms_remaining, $adjustment);
    }
}    

#
# PRECONDITION
#
#  (1) Symbol counts have already been distributed
#
sub allocate_syms
{
    my ($self, $total_sym_count) = @_;

    #
    # Allocate $total_sym_count symbols
    #
    for (my $i=0; $i<$total_sym_count; ++$i) {
        my $sym = new Sym;
    }

    #
    # Get the letters and the symbols
    #
    my $refa_letters = $self->get_all_letters();
    my $refa_syms    = Sym->get_all_syms();

    #
    # Work on a copy of the syms
    #
    my @syms = @$refa_syms;

    #
    # Iterate over the letters
    #
    foreach my $letter (@$refa_letters) {
        #
        # Get the number of symbols that we need for this letter
        #
        my $count = $letter->get_target_sym_count();

        #
        # Allocate $count symbols
        #
        for (my $j=0; $j<$count; ++$j) {
            #
            # Get a random symbol
            #
            my $index = int(rand(@syms));
            my $sym1  = splice(@syms, $index, 1);

            #
            # Add the symbol to the letter
            #
            $letter->add_sym($sym1);
            
            #
            # Tell the symbol about its letter
            #
            $sym1->set_letter($letter);
        }
    }

    #
    # We should have exactly 0 symbols left at this point
    #
    die "Corrupted state!" if (@syms != 0);
}
    

sub assign_syms
{
    my $self = shift;

    #
    # Get the symbol instances
    #
    my $refa_sym_insts = $self->{'sym_insts'};

    #
    # And iterate over them
    #
    foreach my $sym_inst (@$refa_sym_insts) {
        #
        # The symbol instance knows how to assign it's symbol
        #
        $sym_inst->assign_sym_randomly();
    }

    my $refa_letters = $self->get_all_letters();
    foreach my $letter (@$refa_letters) {
        #
        # Fix up any symbol that has no assignments
        #
        $letter->fixup_syms();
    }
}


sub print_plaintext
{
    my ($self, $FH)    = @_;
    my $refa_sym_insts = $self->{'sym_insts'};
    my $cols           = $self->{'cols'};
    my $i;

    #
    # Iterate over the symbol instances
    #
    foreach my $sym_inst (@$refa_sym_insts) {
        #
        # Output the character
        #
        print $FH $sym_inst->get_letter->get_char;

        #
        # Track the columns
        #
        $i++;
        if ($i % $cols == 0) {
            print $FH "\n";
        }
    }
}


sub print_ciphertext
{
    my ($self, $use_ids, $FH) = @_;
    my $refa_sym_insts        = $self->{'sym_insts'};
    my $cols                  = $self->{'cols'};
    my $i;

    #
    # Iterate over the symbol instances
    #
    foreach my $sym_inst (@$refa_sym_insts) {
        #
        # Get the symbol identifier in either ascii or numeric ID form
        #
        my $id = $use_ids ? 
            sprintf("%4d", $sym_inst->get_sym->get_id) :
            sprintf("%s",  $sym_inst->get_sym->get_ascii);

        #
        # And print it
        #
        print $FH $id;

        #
        # Track columns...
        #
        $i++;
        if ($i % $cols == 0) {
            print $FH "\n";
        }
    }

    print $FH "\n";
}


sub calc_ic
{
    my ($self) = @_;

    #
    # Use this variable for calculating the numerator
    #
    my $num = 0.0;

    #
    # Get the letter objects for the letters that are used in this cipher
    #
    my $refa_letters = $self->get_all_letters();

    #
    # Iterate over all of the letters
    #
    foreach my $letter (@$refa_letters) {
        #
        # Get the count for this letter
        #
        my $count = $letter->get_count;

        #
        # Get the numerator contribution for this letter
        #
        my $term = 1.0 * $count * ($count - 1);

        #
        # And add it in...
        #
        $num += $term;
    }

    #
    # Get the length of the cipher
    #
    my $len = $self->get_target_length();

    #
    # Assume N = 26 for our alphabet...
    #
    my $denom = (1.0 * $len * ($len - 1)) / 26.0;

    #
    # Final division
    #
    my $ic = $num / $denom;

    #
    # Return it...
    #
    return $ic;
}


sub print_report
{
    my ($self, $use_ids, $FH) = @_;

    #
    # If no file was given, use stdout
    #
    $FH = \*STDOUT if !defined($FH);

    #
    # Get all of the letters
    #
    my $refa_letters = $self->get_all_letters();

    #
    # Sort the letters lexigraphically
    #
    my @letters = sort {$a->get_char cmp $b->get_char} @$refa_letters;

    #
    # Calculate the Index of Coincidence
    #
    my $ic = $self->calc_ic();

    #
    # Output the IC
    #
    printf $FH "\nIndex of Coincidence: %8.4f\n\n", $ic;

    #
    # Print out the header
    #
    print $FH "                  Init     Adj\n";
    print $FH "Letter   Count   Target   Target             Symbols\n";
    print $FH "======   =====   ======   ======    ========================\n";

    foreach my $letter (@letters) {
        my $refa_syms = $letter->get_syms;
        my $str;
        
        #
        # Sort the symbols
        #
        my @syms = sort {$a->get_id <=> $b->get_id} @$refa_syms;

        #
        # Build up the symbol ids
        #
        foreach my $sym (@syms) {
            $str .= $use_ids ? 
                sprintf("%4d", $sym->get_id) :
                sprintf("%3s", $sym->get_ascii);
        }

        #
        # Output the line
        #
        printf( $FH " %5s    %4d       %2d       %2d   %s\n", 
                $letter->get_char, 
                $letter->get_count,
                $letter->get_init_target_sym_count,
                $letter->get_target_sym_count,
                $str);
    }

    print $FH "\n";
}


sub get_random_letter
{
    my $self = shift;
    
    #
    # Get the 'all letters' array
    #
    my $refa_all_letters = $self->get_all_letters();

    #
    # Get a random index into the array
    #
    my $index = int(rand(@$refa_all_letters));
    
    #
    # And return the corresponding entry
    #
    return $refa_all_letters->[$index];
}


sub fill_to_row_end
{
    my $self = shift;

    #
    # Extract the data
    #
    my $refa_sym_insts = $self->{'sym_insts'};
    my $cols           = $self->{'cols'};

    #
    # Get all the symbols
    #
    my $refa_syms = Sym->get_all_syms();

    #
    # Figure out how many we have
    #
    my $num_sym_insts = @$refa_sym_insts;

    #
    # Calculate the number of symbol instances are needed to fill out
    # the row 
    #
    my $needed = $cols - ($num_sym_insts % $cols);

    #
    # Add this number of randomly chosen symbols at the end of the
    # cipher 
    #
    for (my $i=0; $i<$needed; ++$i) {
        #
        # Get a random symbol
        #
        my $index = int(rand(@$refa_syms));
        my $sym   = $refa_syms->[$index];
        
        #
        # Create a new symbol instance with this symbol
        #
        my $sym_inst = new SymInst;

        #
        # Get the letter object from our selected symbol
        #
        my $letter = $sym->get_letter();

        #
        # Connect 'em up!
        #
        $sym_inst->set_letter($letter);
        $sym_inst->set_sym($sym);
        $letter->add_sym_inst($sym_inst);

        #
        # Push the new symbol instance onto our array
        #
        push @{ $self->{'sym_insts'} }, $sym_inst;

        #
        # NOTE: We're not adjusting the letter counts.  These extra
        # symbols will not affect IC, reported letter counts, etc.
        #
    }
}

#===============================================================================
# PACKAGE: main - Script entry point
#===============================================================================

package ::main;

use Getopt::Long;

my $g_opt_ascii_base = 48;
my $g_opt_ciphertext;
my $g_opt_cols       = 17;
my $g_file_handle    = \*STDOUT;
my $g_opt_file;
my $g_opt_fill;
my $g_opt_ids;
my $g_opt_len        = 340;
my $g_opt_output;
my $g_opt_plaintext;
my $g_opt_rand;
my $g_opt_report;
my $g_opt_seed       =  1;
my $g_opt_syms       = 63;
my $g_opt_uppercase;

#
# Process the options
#
&GetOptions('h|help'             => \&usage_and_exit,
            '-a|ascii-base=i'    => \$g_opt_ascii_base,
            '-c|ciphertext'      => \$g_opt_ciphertext,
            '-cols=i'            => \$g_opt_cols,
            '-f|file=s'          => \$g_opt_file,
            '-fill'              => \$g_opt_fill,
            '-i|ids'             => \$g_opt_ids,
            '-l|len=i'           => \$g_opt_len,
            '-o|output=s'        => \$g_opt_output,
            '-p|plaintext'       => \$g_opt_plaintext,
            '-r|rand'            => \$g_opt_rand,
            '-rl|report-letters' => \$g_opt_report,
            '-seed=i'            => \$g_opt_seed,
            '-s|syms=i'          => \$g_opt_syms,
            '-u|uppercase'       => \$g_opt_uppercase,
            );

#
# Make sure we've got a valid set of options
#
&process_option_state();

#
# All is well, build the cipher
#
my $cipher = &build_cipher();

#
# Generate the requested outputs
#
&gen_outputs($cipher);

#
# And we're done...
#
&wrap_up();


#===============================================================================
# SUBROUTINES
#===============================================================================

sub usage_and_exit
{
    print <<END_OF_USAGE;

Usage:

  % $0 -f FILE [options]

  -a|ascii-base BASE  Encode printable ASCII starting at BASE [$g_opt_ascii_base]
  -c|ciphertext       Print the ciphertext of the cipher
  -cols COLS          Set the number of columns [$g_opt_cols]
  -f|file FILE        Use FILE as the plaintext input
  -fill               Fill last row to end using random symbols
  -i|ids              Use symbol ids instead of ASCII for ciphertext
  -l|len LEN          Construct a cipher of length LEN [$g_opt_len]
  -o|output FILE      Send output to FILE [STDOUT]
  -p|plaintext        Print the plaintext of the cipher
  -r|rand             Randomize results by choosing a random seed
  -rl|-report-letters Report letter-based cipher information
  -seed SEED          Seed the random number generator with SEED [$g_opt_seed]
  -s|syms COUNT       Construct a cipher with COUNT symbols [$g_opt_syms]
  -u|uppercase        Map characters to upper case, not lower case
  -h|help             Print this usage 

END_OF_USAGE

  exit(0);
}

sub process_option_state
{
    #
    # Make sure the user gave us a file to process
    #
    &fatal("Must specify '-f FILE'") if !defined($g_opt_file);

    #
    # Okay, we've got a file; but is it readable?
    #
    &fatal("Unable to read '$g_opt_file'") if (!-r $g_opt_file);

    #
    # Make sure the user is doing something
    #
    &fatal("No output specified.  Please select some combiniation of: -c, -p, -rl") 
        if (!$g_opt_plaintext && !$g_opt_ciphertext && !$g_opt_report);

    #
    # You can't have more symbols than instances (of course!)
    #
    &fatal("Too many symbols!") if ($g_opt_syms > $g_opt_len);

    #
    # Even this is too lenient (base would need to be adjusted)
    #
    &fatal("Too many symbols for printable ASCII representation") if (!$g_opt_ids && $g_opt_syms > 90);

    #
    # Initialize the ASCII index to the base value.  Not doing any
    # extra checking here.  Feel free to shoot yourself in the foot.
    #
    Sym->set_ascii_index($g_opt_ascii_base);
    
    #
    # Initialize to the command-line option.  This may be overwritten.
    #
    my $seed = $g_opt_seed;

    #
    # Did the user explicitly request randomization?
    #
    $seed = $$ ^ time if (defined($g_opt_rand));

    #
    # And finally, seed the random number generator
    #
    print "INFO: Random-number seed: $seed\n";
    srand($seed);

    #
    # If an output file was requested, open it
    #
    if (defined($g_opt_output)) {
        #
        # Open the file
        #
        open(OUTPUT, ">$g_opt_output") or die "Could not open '$g_opt_output' : $!";
        
        #
        # Assign it to our global variable
        #
        $g_file_handle = \*OUTPUT;
    }
}

sub build_cipher
{
    my $cipher = new Cipher;
    
    #
    # Set some configuration state
    #
    $cipher->set_target_length($g_opt_len);
    $cipher->set_cols($g_opt_cols);

    #
    # Read the plaintext and generate the symbol instances
    #
    $cipher->build_from_file($g_opt_file, $g_opt_uppercase);

    #
    # Figure out how to split up the requested symbols amongst the
    # different plaintext letters
    #
    $cipher->distribute_syms($g_opt_syms);
    $cipher->allocate_syms($g_opt_syms);

    #
    # Assign the symbols to specific symbol instances
    #
    $cipher->assign_syms();

    #
    # Does the user want the last row filled to the end?
    #
    $cipher->fill_to_row_end() if $g_opt_fill;

    #
    # Done!
    #
    print "INFO: Cipher successfully constructed\n";
    return $cipher
}

sub open_file
{
    my ($ext) = @_;

    if (!defined($g_opt_output)) {
        #
        # No output file base specified
        #
        return undef;
    }

    #
    # Construct the file name
    #
    my $filename = "$g_opt_output.$ext";

    #
    # Open the file
    #
    open(FILE, ">$filename") or die "Could not open '$filename' : $!";

    #
    # And return it
    #
    return \*FILE;
}

sub gen_outputs
{
    my $cipher = shift;

    #
    # Output the plaintext of the cipher
    #
    if ($g_opt_plaintext) {
        #
        # Generate the plaintext
        #
        $cipher->print_plaintext($g_file_handle);
    }

    #
    # Output the ciphertext of the cipher
    #
    if ($g_opt_ciphertext) {
        #
        # Generate the cipher text in the requested format
        #
        $cipher->print_ciphertext($g_opt_ids, $g_file_handle);
    }

    #
    # Output the symbol-mapping report
    #
    if ($g_opt_report) {
        #
        # Generate the cipher report
        #
        $cipher->print_report($g_opt_ids, $g_file_handle);
    }
}

sub wrap_up
{
    if ($g_file_handle != \*STDOUT) {
        #
        # Close the output file
        #
        close($g_file_handle);
    }
}

sub fatal
{
    print "FATAL: @_\n";
    usage_and_exit();
}
