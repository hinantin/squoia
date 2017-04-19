#!/bin/bash
set -x

########################################################
## ADAPT THESE PATH DECLARATIONS TO YOUR INSTALLATION ##
########################################################

# path to the compiled xfst analyzers, either from the git repository, or the package squoiaMorph from https://github.com/ariosquoia/squoia/releases
export NORMALIZER_DIR=/home/richard/Documents/Runa_Simi/06_Morphology/normalizer

# Path to your maltparser installation (get MaltParser from http://www.maltparser.org/download.html)
export MALTPARSER_DIR=/home/richard/Downloads/01_Instaladores/maltparser-1.8.1
#export WAPITI=/home/richard/Downloads/01_Instaladores/wapiti/wapiti-1.5.0/wapiti
export WAPITI=/home/richard/Documents/wapiti/wapiti
export WAPITI_DIR=/home/richard/Documents/wapiti
export TMP_DIR=/tmp
export PARSER=/home/richard/Documents/squoia/parsing

## Models to disambiguate words
MORPH1_MODEL=$PARSER/models/morph1.model
MORPH2_MODEL=$PARSER/models/morph2.model
MORPH3_MODEL=$PARSER/models/morph3.model
MORPH4_MODEL=$PARSER/models/morph4.model

# MaltParser model
MALTPARSER_MODEL=quzMaltParserModel

# EVID=aya -> ayacuchano, system will assume that every ambiguous -n is a 3. person marker, NOT the evidential -m/-n/-mi
# EVID=cuz -> system will disambiguate all ambiguous -n and decide whether they are person or evidential markers (normalized to -m)
EVID="cuz"    

# PISPAS=PAS -> text has only -pas as additive suffix: all ocurrences of -pis will be analyzed as sequence of -pi (locative) and -s (evidential)
# PISPAS=PIS -> additive suffix ocurrs as -pis in text: system will disambiguate all ocurrences of -pis and decide whether they are a combination of -pi and -s or the additive suffix (normalized to -pas)
PISPAS="pas"

RAW_FILE=$1

filename_w_ext=$(basename "$RAW_FILE")
filename_no_ext="${filename_w_ext%.*}"
TMPFILENAME=TMPNM$filename_no_ext

#echo "filename is $filename_no_ext"

# (1) XFST 
cat $RAW_FILE | perl $PARSER/splitSentences.pl | perl $NORMALIZER_DIR/tokenize.pl | /usr/bin/lookup -f $PARSER/lookup.script -flags cKv29TT > $TMP_DIR/$filename_no_ext.test.xfst

# (2) CRF before|after
cat $TMP_DIR/$filename_no_ext.test.xfst | perl $PARSER/cleanGuessedRoots.pl -$EVID -$PISPAS > $TMP_DIR/$TMPFILENAME.test_clean.xfst
cat $TMP_DIR/$TMPFILENAME.test_clean.xfst | perl $PARSER/xfst2wapiti_pos.pl -test > $TMP_DIR/$TMPFILENAME.pos.test

# /home/richard/Documents/wapiti/wapiti label --server -P 5556 -m /home/richard/Documents/squoia/parsing/models/morph1.model &
#perl $WAPITI_DIR/wapitiClient.pl --port 5556 --host 127.0.0.1 --file $TMP_DIR/$TMPFILENAME.pos.test > $TMP_DIR/$TMPFILENAME.morph1.result
$WAPITI label -m $MORPH1_MODEL $TMP_DIR/$TMPFILENAME.pos.test > $TMP_DIR/$TMPFILENAME.morph1.result

perl $PARSER/disambiguateRoots.pl $TMP_DIR/$TMPFILENAME.morph1.result $TMP_DIR/$TMPFILENAME.test_clean.xfst > $TMP_DIR/$TMPFILENAME.morph1.disamb

perl $PARSER/xfst2wapiti_morphTest.pl -1 $TMP_DIR/$TMPFILENAME.morph1.disamb > $TMP_DIR/$TMPFILENAME.morph2.test

# /home/richard/Documents/wapiti/wapiti label --server -P 5557 -m /home/richard/Documents/squoia/parsing/models/morph2.model &
#perl $WAPITI_DIR/wapitiClient.pl --port 5557 --host 127.0.0.1 --file $MORPH2_MODEL $TMP_DIR/$TMPFILENAME.morph2.test > $TMP_DIR/$TMPFILENAME.morph2.result
$WAPITI label -m $MORPH2_MODEL $TMP_DIR/$TMPFILENAME.morph2.test > $TMP_DIR/$TMPFILENAME.morph2.result

perl $PARSER/xfst2wapiti_morphTest.pl -2 $TMP_DIR/$TMPFILENAME.morph2.result > $TMP_DIR/$TMPFILENAME.morph3.test

# /home/richard/Documents/wapiti/wapiti label --server -P 5558 -m /home/richard/Documents/squoia/parsing/models/morph3.model &
#perl $WAPITI_DIR/wapitiClient.pl --port 5558 --host 127.0.0.1 --file $TMP_DIR/$TMPFILENAME.morph3.test > $TMP_DIR/$TMPFILENAME.morph3.result
$WAPITI label -m $MORPH3_MODEL $TMP_DIR/$TMPFILENAME.morph3.test > $TMP_DIR/$TMPFILENAME.morph3.result

perl $PARSER/xfst2wapiti_morphTest.pl -3 $TMP_DIR/$TMPFILENAME.morph3.result > $TMP_DIR/$TMPFILENAME.morph4.test

# /home/richard/Documents/wapiti/wapiti label --server -P 5559 -m /home/richard/Documents/squoia/parsing/models/morph4.model &
#perl $WAPITI_DIR/wapitiClient.pl --port 5559 --host 127.0.0.1 --file $TMP_DIR/$TMPFILENAME.morph4.test > $TMP_DIR/$TMPFILENAME.morph4.result
$WAPITI label -m $MORPH4_MODEL $TMP_DIR/$TMPFILENAME.morph4.test > $TMP_DIR/$TMPFILENAME.morph4.result

perl $PARSER/xfst2wapiti_morphTest.pl -4 $TMP_DIR/$TMPFILENAME.morph4.result > $TMP_DIR/$filename_no_ext.disamb.xfst

# (3) CONLL before|after
# convert xfst to conll
cat $TMP_DIR/$filename_no_ext.disamb.xfst | perl $PARSER/xfst2conll.pl > $TMP_DIR/$filename_no_ext.conll

# parse conll
# cd /home/richard/Documents/squoia/MT_systems/maltparser_tools/src
#java -cp /home/richard/Downloads/01_Instaladores/maltparser-1.8.1/maltparser-1.8.1.jar:. MaltParserServer 5560 /home/richard/Documents/squoia/parsing/quzMaltParserModel.mco -m parse 2> /home/richard/Documents/squoia/parsing/tmp/log.malt &
#perl $WAPITI_DIR/wapitiClient.pl --port 5560 --host 127.0.0.1 --file $TMP_DIR/$filename_no_ext.conll > $TMP_DIR/$filename_no_ext.parsed.conll
java -jar $MALTPARSER_DIR/maltparser-1.8.1.jar -c $MALTPARSER_MODEL -i $TMP_DIR/$filename_no_ext.conll -o $TMP_DIR/$filename_no_ext.parsed.conll -m parse

# (4) PML | TEXTREE | CONSTITUENT STRUCTURE
# convert conll to pml to view (and edit) trees in TrEd (see https://ufal.mff.cuni.cz/tred/)
perl $PARSER/quzconll2pml.pl -s $PARSER/quz_schema.xml -n $filename_no_ext -c $TMP_DIR/$filename_no_ext.parsed.conll -t $PARSER/quz_stylesheet #> $TMP_DIR/$filename_no_ext.pml 


