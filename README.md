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

```
$ sudo bash /usr/share/eXist/bin/client.sh -u admin -P admin
--no-gui -u admin -P admin
Using locale: en_US.UTF-8
eXist version 2.2 (master-5c5aadc), Copyright (C) 2001-2015 The eXist-db Project
eXist-db comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions; for details read the license file.


type help or ? for help.
exist:/db>mkcol MT_Systems
exist:/db>cd MT_Systems
exist:/db/MT_Systems>mkcol ancoralex
exist:/db/MT_Systems>cd ancoralex
exist:/db/MT_Systems/ancoralex>mkcol 'verb-es'
exist:/db/MT_Systems/ancoralex>quit
```


