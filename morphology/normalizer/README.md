### Installation/Usage


1. get the xfst software for your system from: http://web.stanford.edu/~laurik/.book2software/


2. compile with:
   xfst -f compile.xfst
  
3. analyse a Quechua text (on -nix systems):

  - guessing unknown words :
    cat your-text | ./lookup_guess.sh
    
  - no guessing of unknown words:
    cat your-text | ./lookup_noguess.sh
    
    
    on Windows: 
    
    guessing unknown words:
    type your-text | perl tokenize.pl | lookup -f lookup_guess.script -flags cKv29TT 
    
    no guessting of unknown words:
    type your-text | perl tokenize.pl | lookup -f lookup_noguess.script -flags cKv29TT 
    
    
    (test with test.txt, output should look like test.out)

    
    for feedback, suggestions or corrections, please write to:
    ariosATifi.uzh.ch

    All files are published under the GNU General Public License v3.