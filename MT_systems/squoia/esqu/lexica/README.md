```
$ time cat es-quz.dix | perl count_dix_entries.pl
section
no r's: 
total number of lemmas in section numbers: 30
number of entries with at least one translation: 30
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section ordinals: 32
number of entries with at least one translation: 32
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section months: 24
number of entries with at least one translation: 24
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section Verb-aux: 4
number of entries with at least one translation: 4
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section prepositions: 118
number of entries with at least one translation: 118
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section interjections: 74
number of entries with at least one translation: 74
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section conjunctions: 37
number of entries with at least one translation: 37
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section determiners: 63
number of entries with at least one translation: 63
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section pronouns: 77
number of entries with at least one translation: 77
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section adverbs: 166
number of entries with at least one translation: 166
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section participles: 105
number of entries with at least one translation: 105
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section verbs: 10582
number of entries with at least one translation: 5588
number of entries with no translation: 4994
section
no r's: 
total number of lemmas in section nouns: 74009
number of entries with at least one translation: 12222
number of entries with no translation: 61787
section
no r's: 
total number of lemmas in section kinship_terms: 48
number of entries with at least one translation: 47
number of entries with no translation: 1
section
no r's: 
total number of lemmas in section animals_gender: 13
number of entries with at least one translation: 13
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section gender_sensitive_roots: 85
number of entries with at least one translation: 85
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section conjunctions_unknown: 4
number of entries with at least one translation: 0
number of entries with no translation: 4
section
no r's: 
total number of lemmas in section interjections_spanish: 113
number of entries with at least one translation: 113
number of entries with no translation: 0
section
no r's: 
total number of lemmas in section adverbs_unknown: 79
number of entries with at least one translation: 0
number of entries with no translation: 79
total number of lemmas in dix: 85663
number of entries with at least one translation: 18798
number of entries with no translation: 66865

cat es-quz.dix  0.00s user 0.01s system 1% cpu 0.746 total
perl count_dix_entries.pl  398.66s user 126.97s system 83% cpu 10:32.52 total
```

```
<query>
<total totalentries="85663" totalunspecified="66865" totaltranslated="18798"/>
<results>
<result section="numbers" entries="30" unspecified="0" translated="30"/>
<result section="ordinals" entries="32" unspecified="0" translated="32"/>
<result section="months" entries="24" unspecified="0" translated="24"/>
<result section="Verb-aux" entries="4" unspecified="0" translated="4"/>
<result section="prepositions" entries="118" unspecified="0" translated="118"/>
<result section="interjections" entries="74" unspecified="0" translated="74"/>
<result section="conjunctions" entries="37" unspecified="0" translated="37"/>
<result section="determiners" entries="63" unspecified="0" translated="63"/>
<result section="pronouns" entries="77" unspecified="0" translated="77"/>
<result section="adverbs" entries="166" unspecified="0" translated="166"/>
<result section="participles" entries="105" unspecified="0" translated="105"/>
<result section="verbs" entries="10582" unspecified="4994" translated="5588"/>
<result section="nouns" entries="74009" unspecified="61787" translated="12222"/>
<result section="kinship_terms" entries="48" unspecified="1" translated="47"/>
<result section="animals_gender" entries="13" unspecified="0" translated="13"/>
<result section="gender_sensitive_roots" entries="85" unspecified="0" translated="85"/>
<result section="conjunctions_unknown" entries="4" unspecified="4" translated="0"/>
<result section="interjections_spanish" entries="113" unspecified="0" translated="113"/>
<result section="adverbs_unknown" entries="79" unspecified="79" translated="0"/>
</results>
</query>
Query returned 1 item(s) in 3.52s
```
