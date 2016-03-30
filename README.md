### Hinantin

This version needs eXist-db to be installed in order for it to work appropriately. See the file <path_to_squoia>/eXist-db.md.

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

We assume that you have obtained a copy of AncoraLex and that it is located in `<SQUOIA_PATH>/ancoralex-2.0.3`

```
$ sudo bash /usr/share/eXist/bin/client.sh --no-gui -u admin -P admin
--no-gui -u admin -P admin
Using locale: en_US.UTF-8
eXist version 2.2 (master-5c5aadc), Copyright (C) 2001-2015 The eXist-db Project
eXist-db comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions; for details read the license file.


type help or ? for help.
exist:/db>mkcol HNTErrorCorpus
created collection.
exist:/db>cd HNTErrorCorpus
exist:/db/HNTErrorCorpus>mkcol cuz_simple_foma
exist:/db/HNTErrorCorpus>mkcol uni_simple_foma
exist:/db/HNTErrorCorpus>mkcol uni_extended_foma
exist:/db/HNTErrorCorpus>mkcol bol_myspell
exist:/db/HNTErrorCorpus>mkcol ec_hunspell
exist:/db/HNTErrorCorpus>quit
quit.
```
