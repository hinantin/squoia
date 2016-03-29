//////////////////////////////////////////////////////////////////
//
//    based on FreeLing - Open Source Language Analyzers
//    created project SQUOIA November 2015
//    http://ariosquoia.github.io/squoia/
//
////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////
///  Auxiliary functions to print several analysis results
//////////////////////////////////////////////////////////

#include "freeling/morfo/util.h"
#include "freeling/morfo/configfile.h"
//#include "freeling/output/output_crf.h"
#include "output_crf.h"

using namespace std;
using namespace freeling;

#undef MOD_TRACENAME
#undef MOD_TRACECODE
#define MOD_TRACENAME L"OUTPUT_CONLL"
#define MOD_TRACECODE OUTPUT_TRACE

//---------------------------------------------
// empty constructor
//---------------------------------------------

output_crf::output_crf()  {}

//---------------------------------------------
// Constructor from config file
//---------------------------------------------

// output_crf::output_crf(const wstring &cfgFile) {
// 
//   enum sections {OUTPUT_TYPE,TAGSET,OPTIONS};
// 
//   config_file cfg(true);
//   cfg.add_section(L"Type",OUTPUT_TYPE);
//   cfg.add_section(L"TagsetFile",TAGSET);
//   cfg.add_section(L"Options",OPTIONS);
//   
//   if (not cfg.open(cfgFile))
//     ERROR_CRASH(L"Error opening file "+cfgFile);
//   
// 
//   wstring line; 
//   while (cfg.get_content_line(line)) {
//     
//     // process each content line according to the section where it is found
//     switch (cfg.get_section()) {
//       
//     case OUTPUT_TYPE: {
//       if (util::lowercase(line)!=L"crf")
//         ERROR_CRASH(L"Invalid configuration file for 'crf' output handler, "+cfgFile);
//       break;
//     }
// 
//     case TAGSET: { 
//       wstring path = cfgFile.substr(0,cfgFile.find_last_of(L"/\\")+1);
//       Tags = new tagset(util::absolute(line,path));
//       break;
//     }
// 
//     case OPTIONS: { 
//       wistringstream sin; sin.str(line);
//       wstring key,val;
//       sin >> key >> val;
//       val = util::lowercase(val);
//       bool b = (val==L"true" or val==L"yes" or val==L"y" or val==L"on");
//       break;
//     }
//       
//     default: break;
//     }
//   }
//   
//   cfg.close(); 
// }


//---------------------------------------------
// Destructor
//---------------------------------------------

output_crf::~output_crf() {}





//---------------------------------------------
// print the morfo-analysis in crf format
//---------------------------------------------
/* Spalten:
0:lowercased word
1:case(lc/uc),
2-3: lem/tag1
4-5: lemma/tag2
6-7: lemma/tag3
8-9:lemma/tag4
10-11:lemma/tag5
12-13:lemma/tag6
14-15:lemma/tag7
16-17:lemma/tag8
18: disambiguate yes/no
19: class
*/

//void output::PrintWordCRFMorf (wostream &sout, const word &w, bool first_nonpunct_word) {
void output_crf::freeling2crf(wostream &sout,  const freeling::sentence &s) const {
   
  
  const wchar_t* sep = L"\t";
  const wchar_t* dummy = L"ZZZ";
  const wchar_t* NPtag = L"NP";
  const wchar_t* VGtag = L"G0000";
  const wchar_t* VarGform = L"ando";
  const wchar_t* VarGform2 = L"ándo";
  const wchar_t* VierGform = L"endo";
  const wchar_t* VierGform2 = L"éndo";
  const wchar_t* ViMperative = L"VMM";
  
  bool first_nonpunct_word = false, found = false;
  for (sentence::const_iterator w = s.begin (); w != s.end (); w++) {
            if (found) {
              first_nonpunct_word = false;
            } else {
              first_nonpunct_word = (w->selected_begin()->get_tag().find(L"F")!=0);
              found = first_nonpunct_word;
         }
  }
  
  //wstring tags = L"";


  for (sentence::const_iterator w=s.begin(); w!=s.end(); w++) {
    
      wstring NPstr = L"";
      wstring notNPtag = L"";
            
      sout << w->get_lc_form(); // lowercased word form
    /*
      if (first_nonpunct_word) {
	sout << sep  << L"first";
      }
      else {
	sout << sep  << L"follow";
      }
    */
      if (std::iswupper(w->get_form().c_str()[0])) {
	sout << sep  << L"uc";
      }
      else {
	sout << sep  << L"lc";
      }

      word::const_iterator ait;

      word::const_iterator a_beg,a_end;
      a_beg = w->selected_begin();
      a_end = w->selected_end();

      //int lem_i = 0;
      //int tag_i = 0;
      //const int MAXLEM = 5;
      int i = 0;
      const int MAXTAG = 8;
      int nptag = 0;
      for (ait = a_beg; ait != a_end; ait++) {
// 	if (ait->is_retokenizable ()) {
// 	  sout << L"(is retokenizable)";
// 	  list <word> rtk = ait->get_retokenizable ();
// 	  list <analysis> la=printRetokenizable(sout, rtk, rtk.begin(), L"", L"");
// 	  for (list<analysis>::iterator x=la.begin(); x!=la.end(); x++) {
// 	    sout << L" " << x->get_lemma() << L" " << x->get_tag();
// 	    sout << L" " << ait->get_prob()/la.size();
// 	  }
// 	}
// 	else 
	//{
	  //sout << L"not retokenizable";
	  /*bool newlemma=true;
	  word::const_iterator lemit;
	  for (lemit = a_beg; lemit != ait; lemit++) {
	    if (lemit->get_lemma().compare(ait->get_lemma()) == 0) { // same lemmas
	      newlemma=false;
	      break;
	    }
	  }
	  if (newlemma) {
	    sout << sep << ait->get_lemma();
	    lem_i++;
	  }
	  //tags += sep + ait->get_tag();*/
	  std::size_t gerundtag = ait->get_tag().find(VGtag);
	  std::size_t gerundform1 = w->get_form().find(VarGform);
	  std::size_t gerundform2 = w->get_form().find(VarGform2);
	  std::size_t gerundform3 = w->get_form().find(VierGform);
	  std::size_t gerundform4 = w->get_form().find(VierGform2);
	  if ((gerundtag==2) and 
	      (gerundform1 != std::string::npos or gerundform2 != std::string::npos or gerundform3 != std::string::npos or gerundform4 != std::string::npos)) {
	    //wcerr << ait->get_lemma() << L" is a gerund form\n";
	    sout << sep << ait->get_lemma() << sep << ait->get_tag();
	    i++;
	    break;
	  }
	  std::size_t imperative = ait->get_tag().find(ViMperative);
	  if ((imperative == 0)) {
	  //if (imperative!= std::string::npos) {
	    wcerr << ait->get_lemma() << L" is an imperative form found at position"<< imperative << L"\n";
	    sout << sep << ait->get_lemma() << sep << ait->get_tag();
	    i++;
	    break;
	  }
	  std::size_t found = ait->get_tag().find(NPtag);
	  if ( first_nonpunct_word and (found==0) ) {	// found "NP" at beginning of tag
	    nptag++;
	    NPstr += sep + ait->get_lemma() + sep + ait->get_tag();
	  } else {
	    notNPtag = ait->get_tag();
	    sout << sep << ait->get_lemma() << sep << notNPtag;
	  }
	//}
	//tag_i++;
	i++;
      }
      if (nptag == i) {	// only NP tags...
	sout << NPstr;
      }
      else {	// other tags as NP tags
	if (nptag > 0)
	  i -= nptag;	// discard the NP tags
      }
    /*  while (lem_i < MAXLEM) {
	sout << sep << dummy;
	tags += sep; tags += dummy;
	lem_i++;
      }
      while (tag_i < MAXTAG) {
	tags += sep; tags += dummy;
	tag_i++;
      }*/
      while (i < MAXTAG) {
	sout << sep << dummy << sep << dummy;
	i++;
      }
      //sout << tags;
      sout << sep << bool(w->get_n_selected() > 1);
      if (a_beg->get_tag().compare(L"Z") != 0) {	// don't print tag "Z", don't force it because maybe it's a "DN"
	if (w->get_n_selected() == 1) {
	  sout << sep << a_beg->get_tag();
	}
	else if ((w->get_n_selected()-nptag) == 1) {	// after discarding NP tags there is one other tag left, the notNPtag
	  sout << sep << notNPtag;
	}
      }
      sout << endl;
  }
}


// ----------------------------------------------------------
// print document in crf format
// ----------------------------------------------------------

void output_crf::PrintResults(wostream &sout, const document &doc) const {


  
  // convert and print each sentence in the document
  for (document::const_iterator p=doc.begin(); p!=doc.end(); p++) {
    if (p->empty()) continue;

    for (list<sentence>::const_iterator s=p->begin(); s!=p->end(); s++) {      
      if (s->empty()) continue;

      freeling2crf(sout,*s);
       sout << endl;
     // cs.print_conll_sentence(sout, WordSpans, N_user);
    }
  }
}

//----------------------------------------------------------
// print list of sentences in crf format
//---------------------------------------------------------

void output_crf::PrintResults (std::wostream &sout, const list<freeling::sentence> &ls) const {

  for (list<freeling::sentence>::const_iterator s=ls.begin(); s!=ls.end(); s++) {
    if (s->empty()) continue;
    
    freeling2crf(sout,*s);
     sout << endl;
  }

}

//---------------------------------------------
// print retokenization combinations for a word
//---------------------------------------------

// list<analysis> output_crf::printRetokenizable(wostream &sout, const list<word> &rtk, list<word>::const_iterator w, const wstring &lem, const wstring &tag) {
//   
//   list<analysis> s;
//   if (w==rtk.end()) 
//     s.push_back(analysis(lem.substr(1),tag.substr(1)));
//       
//   else {
//     list<analysis> s1;
//     list<word>::const_iterator w1=w; w1++;
//     for (word::const_iterator a=w->begin(); a!=w->end(); a++) {
//       s1=printRetokenizable(sout, rtk, w1, lem+L"+"+a->get_lemma(), tag+L"+"+a->get_tag());
//       s.splice(s.end(),s1);
//     }
//   }
//   return s;
// } 

//----------------------------------------------------------
// print document in conll format
//----------------------------------------------------------

// void output_conll::PrintResults(wostream &sout, const document &doc) const {
// 
//   // Precompute coreference column if needed
//   map<wstring,wstring> openmention, closemention;
//   bool have_coref = (doc.get_num_groups()>0);
//   if (have_coref) openclosementions(doc, openmention, closemention);
//   
//   // convert and print each sentence in the document
//   for (document::const_iterator p=doc.begin(); p!=doc.end(); p++) {
//     if (p->empty()) continue;
// 
//     for (list<sentence>::const_iterator s=p->begin(); s!=p->end(); s++) {      
//       if (s->empty()) continue;
// 
//       conll_sentence cs;
//       freeling2conll(*s,cs);
// 
//       // add coreference information
//       map<wstring, wstring>::const_iterator p;
//       wstring sid = s->get_sentence_id();
//       for (sentence::const_iterator w=s->begin(); w!=s->end(); w++) {
//         int wpos = w->get_position();
//         wstring wid = sid + L"." + util::int2wstring(wpos+1);
//         wstring ocoref = L""; wstring ccoref = L"";
//         p = openmention.find(wid); if (p!=openmention.end()) ocoref = p->second;
//         p = closemention.find(wid); if (p!=closemention.end()) ccoref = p->second;
// 
//         wstring coref;
//         if (not ocoref.empty() and not ccoref.empty()) coref = ocoref+L"|"+ccoref;
//         else coref = ocoref+ccoref;
//         if (not coref.empty()) cs.set_value(wpos,conll_sentence::COREF, coref);
//       }
// 
//       cs.print_conll_sentence(sout, WordSpans, N_user);
//     }
//   }
// }

//---------------------------------------------
// Fill conll_sentence from freeling::sentence
//---------------------------------------------

// void output_conll::freeling2conll(const sentence &s, conll_sentence &cs) const {
// 
//   cs.clear();
// 
//   // if constituency parsing is available, precompute column
//   vector<wstring> openchunk(s.size(),L"");
//   vector<wstring> closechunk(s.size(),L"");
//   if (s.is_parsed())
//     openclosechunks(s.get_parse_tree().begin(), openchunk, closechunk);
// 
//   for (sentence::const_iterator w=s.begin(); w!=s.end(); w++) {
// 
//     // fill a vector with available fields for current word
//     vector<wstring> token;
// 
//     int id = w->get_position();
//     
//     // basic morpho stuff
//     token.push_back(util::int2wstring(id+1));
// 
//     token.push_back(w->get_form());
//     if (w->empty()) {
//       // only token info is available
//       cs.add_token(token,w->get_span_start(),w->get_span_finish(),w->user);
//       continue; 
//     }
// 
//     wstring lemma,tag;
//     if (w->selected_begin()->is_retokenizable()) {
//       const list <word> &rtk = w->selected_begin()->get_retokenizable();
//       list <analysis> la=compute_retokenization(rtk, rtk.begin(), L"", L"");
//       lemma = la.begin()->get_lemma();
//       tag = la.begin()->get_tag();
//     }
//     else {
//       lemma = w->get_lemma();
//       tag = w->get_tag();
//     }
//     token.push_back(lemma);
//     token.push_back(tag);
//     
//     if (Tags!=NULL) {
//       list<wstring> tgs=util::wstring2list(tag,L"+");
//       wstring shtag, msd;
//       for (list<wstring>::const_iterator t=tgs.begin(); t!=tgs.end(); t++) {
//         shtag += L"+" + Tags->get_short_tag(*t);
//         msd += L"+" + Tags->get_msd_string(*t);
//       }
//       token.push_back(shtag.substr(1));
//       token.push_back(msd.substr(1));
//     }
//     else {
//       token.push_back(L"-");
//       token.push_back(L"-");
//     }
//     
//     // NEC output, if any
//     wstring nec=L"-";
//     if (w->get_tag()==L"NP00SP0") nec=L"B-PER";
//     else if (w->get_tag()==L"NP00G00") nec=L"B-LOC";
//     else if (w->get_tag()==L"NP00O00") nec=L"B-ORG";
//     else if (w->get_tag()==L"NP00V00") nec=L"B-MISC";
//     token.push_back(nec);
//     
//     // WSD output, if any
//     wstring wsd=L"-";
// 
//     if (not w->get_senses().empty()) {
//       if (AllSenses) wsd = util::pairlist2wstring(w->get_senses(),L":",L"/");
//       else wsd = w->get_senses().begin()->first;
//     }
//     token.push_back(wsd);
// 
//     // constituency output, if any
//     wstring cst = L"";
//     if (s.is_parsed()) cst = openchunk[id] + closechunk[id];
//     if (cst.empty()) cst=L"-";
//     token.push_back(cst);
//     
//     // dependency, coref, and SRL, if any
//     wstring dhead=L"-";
//     wstring drel=L"-";
//     if (s.is_dep_parsed()) {
//       // dep head and func
//       dep_tree::const_iterator n = s.get_dep_tree().get_node_by_pos(id);
//       if (n.is_root() or n.get_parent()->get_label()==L"VIRTUAL_ROOT") dhead = L"0";
//       else dhead = util::int2wstring(n.get_parent()->get_word().get_position()+1);
//       
//       drel = n->get_label();
//     }
// 
//     token.push_back(dhead);
//     token.push_back(drel);
//     
//     // Add space for coref column. Document-level processing will fill it later if needed.
//     token.push_back(L"-");
//     
//     // predicates, if any
//     wstring prd=L"-";
//     if (not s.get_predicates().empty() and s.is_predicate(id)) 
//       prd = s.get_predicate_by_pos(id).get_sense();
//     token.push_back(prd);
//       
//     // print columns describing whether the word is an argument for other predicates
//     for (size_t np=0; np < s.get_predicates().size(); np++) {
//       wstring a = L"-";
//       const predicate &pred = s.get_predicate_by_number(np);
//       if (pred.has_argument(id)) a = pred.get_argument_by_pos(id).get_role();
//       token.push_back(a);
//     }
//   
//     // add line to sentence
//     cs.add_token(token, w->get_span_start(),w->get_span_finish(), w->user);
//   }
// }
// 
