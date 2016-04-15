
g++ -std=gnu++0x -c -o squoia_xfer_lex.o squoia_xfer_lex.cc -I/usr/local/include/lttoolbox-3.2 -I/usr/local/lib/lttoolbox-3.2/include -I/usr/include/libxml2
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
g++ -O3 -Wall -o squoia_xfer_lex squoia_xfer_lex.o -L/usr/local/lib -llttoolbox3 -lxml2 -lpcre


lttoolboxinstall/bin/lt-comp lr squoia-read-only/MT_systems/esqu/lexica/es-quz.dix squoia-read-only/MT_systems/esqu/lexica/es-quz.bin

cat /media/sf_RCastroq/Dropbox/2015/RunaSimi/mttest/tmp.xml | /home/richard/Documents/squoia/MT_systems/bin/squoia-xfer-lex /home/richard/Documents/squoia/MT_systems/squoia/esqu/lexica/es-quz.bin


