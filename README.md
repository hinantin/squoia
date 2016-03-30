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


