#!/bin/bash
set -x #echo on

FREELING_INCLUDE=/usr/local/include
FREELING_SRC=/home/richard/Downloads/01_Instaladores/freeling/FreeLing-4.0-beta1/src #freeling >= 4 source code 
SQUOIA_REPOSITORY=/home/richard/Documents/squoia #squoia repository
STD=gnu++0x # This standard may vary acconding to your operating system

# Compiling CRF module
rm -f output_crf.o
g++ -std=$STD -c -o output_crf.o output_crf.cc -I$FREELING_INCLUDE -I$SQUOIA_REPOSITORY/FreeLingModules/config_squoia

# Compiling the client
rm -f analyzer_client.o
g++ -c -o analyzer_client.o analyzer_client.cc -I$FREELING_INCLUDE -I$SQUOIA_REPOSITORY/FreeLingModules/config_squoia

# Compiling the server
rm -f server_squoia.o
g++ -std=$STD -c -o server_squoia.o server_squoia.cc -I$FREELING_INCLUDE -I$SQUOIA_REPOSITORY/FreeLingModules/config_squoia -I$FREELING_SRC/libfoma -I$FREELING_SRC/libtreeler

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
g++ -O3 -Wall -o server_squoia server_squoia.o output_crf.o -L/usr/local/lib -lfreeling -lboost_program_options -lboost_system -lboost_filesystem -lpthread

g++ -O3 -Wall -o analyzer_client analyzer_client.o -L /usr/local/lib -lfreeling 

export FREELINGSHARE=/usr/local/share/freeling
