TEXT=$1
echo "$1" | perl translate.pm -d esqu -o prepdisamb > tmp/tmp2.xml
echo "Using Hinantin's IntraChunk Transfer"
perl /home/richard/Documents/squoia/MT_systems/eXist-db/esqu_intrachunk_transfer.pm --config-file /home/richard/Documents/squoia/MT_systems/eXist-db/ConfigFile.ini --input-file /home/richard/Documents/squoia/MT_systems/tmp/tmp2.xml | perl translate.pm -d esqu -i interTrans
echo "Using Squoia's INtraChunk Transfer"
echo "$1" | perl translate.pm -d esqu -o interTrans > tmp/tmp.xml
cat tmp/tmp.xml | perl translate.pm -d esqu -i interTrans
