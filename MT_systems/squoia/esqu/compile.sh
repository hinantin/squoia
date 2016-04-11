#!/bin/bash
set -x #echo on

STD=gnu++0x # This standard may vary acconding to your operating system
CXX=${CXX:-g++}

rm -f outputSentences outputSentences.o compile.log

# --- Compiling 
# --- Linking the shared libraries (For linking <path_to_shared_object>/lib{name}.so write -L<path_to_shared_object>/ -l{name}) and static libraries (For linking <path_to_static_lib>/lib{name}.a write -L<path_to_static_lib>/ -l{name})
$CXX -std=$STD -o outputSentences outputSentences.cpp -I/home/richard/Documents/kenlm -I/usr/include -DKENLM_MAX_ORDER=6 -L/home/richard/Documents/kenlm/build/lib -L/home/richard/Documents/kenlm/build/lib/ -lkenlm -lkenlm_util -lkenlm_filter -lkenlm_builder -L/usr/local/lib/ -lfoma -lz -L/usr/lib -lboost_regex -L/home/richard/Documents/bzip2-1.0.6/ -lbz2 2>&1 | tee -a compile.log

# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# --- Testing
# ./outputSentences -l -m /home/richard/Documents/squoia/MT_systems/models/all_morph_5grams_interpolated_unigr.lm -n 3 -i /home/richard/Documents/squoia/MT_systems/tmp/tmp.morph -f /home/richard/Documents/squoia/MT_systems/squoia/esqu/morphgen_foma/unificadoTransfer.fst

