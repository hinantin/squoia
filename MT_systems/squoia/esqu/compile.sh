#!/bin/bash
set -x #echo on

# g++ -o outputSentences outputSentences.cpp -I/home/richard/Documents/kenlm -I/usr/include -I/home/richard/Downloads/01_Instaladores/freeling/FreeLing-4.0-beta1/src/libfoma/foma -DKENLM_MAX_ORDER=6 -L/home/richard/Documents/kenlm/build/lib -lkenlm
STD=gnu++0x # This standard may vary acconding to your operating system
CXX=${CXX:-g++}
CXXFLAGS+=" -I. -O3 -DNDEBUG -DKENLM_MAX_ORDER=6"

echo "$CXXFLAGS"

rm -f outputSentences outputSentences.o compile.log
# g++ -std=$STD -c -o outputSentences.o outputSentences.cpp -I/home/richard/Documents/kenlm -DKENLM_MAX_ORDER=6 -L/home/richard/Documents/kenlm/build/lib -lkenlm
$CXX -std=gnu++0x -o outputSentences outputSentences.cpp -I/home/richard/Documents/kenlm -I/usr/include -DKENLM_MAX_ORDER=6 -L/home/richard/Documents/kenlm/build/lib -L/home/richard/Documents/kenlm/build/lib/ -lkenlm -lkenlm_util -lkenlm_filter -lkenlm_builder -L/usr/local/lib/ -lfoma -lz -L/usr/lib -lboost_regex -L/home/richard/Documents/bzip2-1.0.6/ -lbz2 2>&1 | tee -a compile.log

# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# g++ -std=$STD -O3 -Wall -o outputSentences outputSentences.o -L/usr/local/lib -L/home/richard/Documents/kenlm/build/lib -lkenlm -lboost_regex /home/richard/Downloads/01_Instaladores/freeling/FreeLing-4.0-beta1/src/libfoma/.libs/libfoma.a -lz

# $CXX -o outputSentences outputSentences.cpp -I/home/richard/Documents/kenlm -I/home/richard/Documents/boost_1_60_0 -DKENLM_MAX_ORDER=6 -L/home/richard/Documents/kenlm/build/lib -L/home/richard/Documents/boost_1_60_0/stage/lib -lkenlm -lboost_regex /usr/local/lib/libfoma.a -lz 2>&1 | tee -a compile.log
