#!/bin/bash
set -x #echo on

FREELING=/usr/local
FREELING_SRC=/home/richard/Downloads/01_Instaladores/freeling/FreeLing-4.0-beta1/src #freeling >= 4 source code 
export DESRHOME=/home/richard/Documents/desr-1.4.2

rm desr_client desr_client.o desr_server.o desr_server

g++ -c -o desr_client.o desr_client.cc -I/home/richard/Downloads/01_Instaladores/freeling/freeling-3.1/src/main/sample_analyzer

g++ -O3 -Wall -o desr_client desr_client.o

g++ -c -o desr_server.o desr_server.cc -std=gnu++0x -I/home/richard/Downloads/01_Instaladores/freeling/freeling-3.1/src/main/sample_analyzer -I$DESRHOME/src/ -I/usr/include/python2.7/ -I$DESRHOME -I$DESRHOME/ixe/ -I$DESRHOME/classifier/

g++ -O3 -Wall -o desr_server desr_server.o $DESRHOME/src/libdesr.so  $DESRHOME/ixe/libixe.a

./desr_server -m /home/richard/Documents/desrinstall/models/spanish_es4.MLP --port 5678 2> logdesr_es4 &

echo "la madre se va. El padre se queda. El hijo duerme." | analyzer_client 8866 | ./desr_client 5678
