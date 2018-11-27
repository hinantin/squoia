### The Squoia Repository

The contents of this repository were forked from the Squoia Repository, you can cite the original work as following:

```
@phdthesis{rios2015basic,
  title={A Basic Language Technology Toolkit for Quechua},
  author={Rios, Annette},
  year={2015},
  school={University of Zurich}
}
```

### How to install 

#### STEP 1: Cloning the repository

```
$ git clone https://github.com/hinantin/squoia
```
##### `<SQUOIA_PATH>`

`<SQUOIA_PATH>` is used throughout this manual to refer to the path where you have downloaded the contents of the squoia repository, in my case the path is `/home/richard/Documents/squoia`. You should change this to adjust it to your own environment.

#### STEP 2: 

Modify the configuration file 

```
$ vim <SQUOIA_PATH>/MT_systems/squoia/esqu/es-qu.cfg
```

Define where to look (path) for grammar file for the translation:

```
GRAMMAR_DIR=/home/hinantin/squoia/MT_systems/squoia/esqu/grammar
SQUOIA_DIR=/home/hinantin/squoia/MT_systems
```

### Hinantin

As of today the objective of this version of the Squoia repository is to improve the performance of the certain scripts when querying an XML document, for this purpuse we are replacing gradually the use of the `XML::LibXML` perl library for eXist-db (needles to say this version needs eXist-db to be installed in order for it to work appropriately. See the file `<SQUOIA_PATH>/eXist-db.md` for installation details).

Another objective is to increase and correct certain issues we had with the Normalizer tool, by increasing its lexicon and rules.

### Linguistic Resources used in this project

#### Lexica

Note on the semantic dictionaries for Spanish used in this project:

The list of nouns with their corresponding semantic tags has been extracted from the Spanish Resource Grammar in september 2012, and it is located `<SQUOIA_PATH>/MT_systems/materiales.txt`.
 
Montserrat Marimon, Natalia Seghezzi and Núria Bel.
  An Open-source Lexicon for Spanish, Procesamiento del Lenguaje Natural, n. 39, pp. 131-137. Septiembre, 2007. ISSN 1135-5948.

The original files are available from: 
http://www.upf.edu/pdi/iula/montserrat.marimon/spanish_resource_grammar.html

The lexicon of verb frames has been taken from AncoraLex Spanish 2.0.3:
http://clic.ub.edu/corpus/en/ancora-descarregues

see also:
Taulé, M., M.A. Martí, M. Recasens (2009). 
  AnCora: Multilevel Annotated Corpora for Catalan and Spanish. Proceedings of 6th International Conference on language Resources and Evaluation.
  
Unfortunately, Ancora is not freely available, you have to register to download the resource. 
Every verb comes in its own xml file, in order to read them into a hash, import them into eXist-db:

We assume that you have obtained a copy of AncoraLex and that it is located in `<SQUOIA_PATH>/ancoralex-2.0.3`, so let's proceed to log into eXist-db create the collections as follos and import all .xml files within `<SQUOIA_PATH>/ancoralex-2.0.3/ancora-verb-es` folder.

Create the collection

```
$ sudo bash /usr/share/eXist/bin/client.sh -ouri=xmldb:exist://host:8081/exist/xmlrpc -u admin -P admin

exist:/db>mkcol MT_Systems
exist:/db>cd MT_Systems
exist:/db/MT_Systems>mkcol ancoralex
exist:/db/MT_Systems>cd ancoralex
exist:/db/MT_Systems/ancoralex>mkcol 'verb-es'
exist:/db/MT_Systems/ancoralex>quit
```

Importing files from the command line:

```
$ sudo bash /usr/share/eXist/bin/client.sh -u admin -P admin -m /db/MT_Systems/ancoralex/verb-es -p <SQUOIA_PATH>/ancoralex-2.0.3/ancora-verb-es
```

and then use the scripts located in the path `<SQUOIA_PATH>/MT_systems/utilities` to store the list of nouns and verbs into a hash file.

In order to obtain the noun hash file run the folowing command:

```
$ perl <SQUOIA_PATH>/MT_systems/utilities/readInSemanticDix.pl <SQUOIA_PATH>/MT_systems/materiales.txt
```

To get the verb hash file run this command:

```
$ perl <SQUOIA_PATH>/MT_systems/utilities/readInSemanticDixFromeXistdb.pl 
```

### Importing the dictionaries into eXist-db

Create the collection

```
$ sudo bash /usr/share/eXist/bin/client.sh -u admin -P admin

exist:/db>cd MT_Systems
exist:/db/MT_Systems>mkcol squoia
exist:/db/MT_Systems>cd squoia
exist:/db/MT_Systems/squoia>mkcol esqu
exist:/db/MT_Systems/squoia>cd esqu
exist:/db/MT_Systems/squoia/esqu>mkcol lexica
exist:/db/MT_Systems/squoia/esqu>quit
```
Import the dictionary

```
$ sudo bash /usr/share/eXist/bin/client.sh -u admin -P admin -m /db/MT_Systems/squoia/esqu/lexica -p <SQUOIA_PATH>/MT_systems/squoia/esqu/lexica/es-quz.dix
```

Testing the dictionary

```
$ sudo bash /usr/share/eXist/bin/client.sh -F <SQUOIA_PATH>/MT_systems/squoia/esqu/lexica/count_dix_entries.xq
```

### WordNet:

Download the necessary files from `http://adimen.si.ehu.es/web/MCR`:

```
spaWN/wei_spa-30_to_ili.tsv
data/wei_ili_record.tsv
spaWN/wei_spa-30_variant.tsv
```

### Start the 3 servers

#### Wapiti

Please download this Wapiti version `https://github.com/rcastromamani/Wapiti`, for the official version does not support a server mode as of today.

```
$ git clone https://github.com/rcastromamani/Wapiti
$ cd Wapiti
$ ./wapiti label --server -P 8888 --force -m /home/richard/Documents/squoia/MT_systems/models/3gram_enhancedAncora.model
```

#### Squoia Freeling modules

```
$ git clone https://github.com/TALP-UPC/FreeLing
$ cd FreeLing/

# --- Compiling Freeling
# --- autoreconf -i 
$ sudo apt-get install autoconf autoconf2.13
$ sudo apt-get install libboost-dev libboost-regex-dev libicu-dev libboost-system-dev libboost-program-options-dev libboost-thread-dev zlib1g-dev
$ sudo apt-get install libtool automake libtool zlib1g-dev libboost-dev  libboost-test-dev libboost-system-dev libboost-thread-dev

$ 
$ mkdir m4
$ ./autogen.sh
$ make install

# --- Running server_squoia 
$ cd /home/richard/Documents/squoia/FreeLingModules
$ export FREELINGSHARE=/usr/local/share/freeling
$ ./server_squoia -f /home/richard/Documents/squoia/FreeLingModules/es_squoia.cfg --server --port=8844 2> logtagging &
```

#### MaltParser

```
$ cd /home/richard/Documents/squoia/MT_systems/maltparser_tools/src
$ java -cp /home/richard/Downloads/01_Instaladores/maltparser-1.8.1/maltparser-1.8.1.jar:. MaltParserServer 1234 /home/richard/Documents/squoia/MT_systems/models/splitDatesModel.mco 2> /home/richard/Documents/squoia/MT_systems/logs/log.malt &
```

#### Testing the translation system

```
$ cd /home/richard/Documents/squoia/MT_systems
$ echo "El tiempo nos gana." | perl translate.pm -d esqu -c /home/richard/Documents/squoia/MT_systems/squoia/esqu/es-qu.cfg
```

#### Matxin

Possible error:

```
* TRANS-STEP 12)  [-o lextrans] lexical transfer
/home/richard/Documents/squoia/MT_systems/bin/squoia-xfer-lex: error while loading shared libraries: liblttoolbox3-3.2.so.0: cannot open shared object file: No such file or directory
Empty Stream at translate.pm line 958
```

Compile:

```
$ cd ~/Documents/squoia/MT_systems/matxin-lex
$ g++ -std=gnu++0x -c -o squoia_xfer_lex.o squoia_xfer_lex.cc -I/usr/local/include/lttoolbox-3.2 -I/usr/local/lib/lttoolbox-3.2/include -I/usr/include/libxml2
$ export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
$ g++ -O3 -Wall -o squoia_xfer_lex squoia_xfer_lex.o -L/usr/local/lib -llttoolbox3 -lxml2 -lpcre
```

#### Checking shared library availability

```
$ ldconfig -p|grep libboost_regex
	libboost_regex.so.1.46.1 (libc6,x86-64) => /usr/lib/libboost_regex.so.1.46.1
	libboost_regex.so (libc6,x86-64) => /usr/lib/libboost_regex.so
```

```
# --- Compiled boost library 1.6
# --- The following directory should be added to compiler include paths:
# --- /home/richard/Documents/boost_1_60_0
# --- The following directory should be added to linker library paths:
# --- /home/richard/Documents/boost_1_60_0/stage/lib
$ g++ -o test test.cpp -I/home/richard/Documents/boost_1_60_0 -L/home/richard/Documents/boost_1_60_0/stage/lib -lboost_regex
# --- Compiled executables
$ LD_LIBRARY_PATH=/home/richard/Documents/boost_1_60_0/stage/lib
$ export LD_LIBRARY_PATH
$ ./executable
# --- Boost library installed by default
$ g++ -o test test.cpp -I/usr/include -L/usr/lib -lboost_regex
```

#### Manual

https://hinantin.gitbooks.io/squoia/content/
