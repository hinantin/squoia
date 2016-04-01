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

### Hinantin

This version needs eXist-db to be installed in order for it to work appropriately. See the file `<SQUOIA_PATH>/eXist-db.md`.

### Linguistic Resources used in this project

#### `<SQUOIA_PATH>`

`<SQUOIA_PATH>` is used throughout this manual to refer to the path where you have downloaded the contents of the squoia repository, in my case the path is `/home/richard/Documents/squoia`. You should change this to adjust it to your own environment.

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
$ sudo bash /usr/share/eXist/bin/client.sh -u admin -P admin

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



