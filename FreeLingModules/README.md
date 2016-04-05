### Freeling analyzer with crf output format for wapiti:

Locate where the `/usr/local/include/freeling` is:

local:
g++ -c -o output_crf.o output_crf.cc -I/home/richard/Downloads/01_Instaladores/freeling/freeling_github/src/include -I/home/richard/Documents/squoia/FreeLingModules/config_squoia/
kitt:
g++ -c -o output_crf.o output_crf.cc -I/opt/matxin/local/include/ -I/mnt/storage/hex/projects/clsquoia/arios_squoia_git/FreeLingModules/config_squoia/


lokal:
g++ -c -o analyzer_client.o analyzer_client.cc -I/home/richard/Downloads/01_Instaladores/freeling/freeling_github/src/include -I/home/richard/Documents/squoia/FreeLingModules/config_squoia/ 
kitt:
g++ -c -o analyzer_client.o analyzer_client.cc -I/opt/matxin/local/include/ -I/mnt/storage/hex/projects/clsquoia/arios_squoia_git/FreeLingModules/config_squoia/

lokal:
g++ -std=gnu++11 -c  -o server_squoia.o server_squoia.cc -I/home/richard/Downloads/01_Instaladores/freeling/freeling_github/src/include -I/home/richard/Documents/squoia/FreeLingModules/config_squoia/ -I/home/richard/Downloads/01_Instaladores/freeling/freeling_github/src/libfoma -I/home/richard/Downloads/01_Instaladores/freeling/freeling_github/src/libtreeler

kitt:
g++ -std=gnu++11 -c  -o server_squoia.o server_squoia.cc -I/opt/matxin/local/include/ -I/mnt/storage/hex/projects/clsquoia/arios_squoia_git/FreeLingModules/config_squoia/

hinantin:
g++ -std=gnu++0x -c -o server_squoia.o server_squoia.cc -I/usr/local/include -I/home/richard/Documents/squoia/FreeLingModules/config_squoia/ -I/home/richard/Downloads/01_Instaladores/freeling/FreeLing-4.0-beta1/src/libfoma -I/home/richard/Downloads/01_Instaladores/freeling/FreeLing-4.0-beta1/src/libtreeler

lokal:
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/squoia/lib
g++ -O3 -Wall -o server_squoia server_squoia.o output_crf.o -L/opt/squoia/lib -lfreeling -lboost_program_options -lboost_system -lboost_filesystem -lpthread 
kitt:
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/matxin/local/lib
g++ -O3 -Wall -o server_squoia server_squoia.o output_crf.o -L/opt/matxin/local/lib -lfreeling -lboost_program_options -lboost_system -lboost_filesystem -lpthread 



für analyzer_client
lokal:
g++ -O3 -Wall -o analyzer_client analyzer_client.o -L /opt/squoia/lib -lfreeling
kitt:
g++ -O3 -Wall -o analyzer_client analyzer_client.o -L /opt/matxin/local/lib -lfreeling


export FREELINGSHARE=/opt/squoia/share/freeling/
export FREELINGSHARE=/opt/matxin/local/share/freeling/

# start the server
./server_squoia -f /opt/squoia/squoia/FreeLingModules/es_squoia.cfg  --server --port=8844 2> logtagging &

echo "eso  es mi test" |./analyzer_client 8844 

link client and server in MT_systems/bin
cd /mnt/storage/hex/projects/clsquoia/arios_squoia_git/MT_systems/bin
ln -s ../../FreeLingModules/analyzer_client analyzer_client
ln -s ../../FreeLingModules/server_squoia server_squoia



