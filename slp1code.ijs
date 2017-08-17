NB. Phonetic encoding : Peter Schraf 
NB. https://en.wikipedia.org/wiki/SLP1

NB. helper functions
NB. =========================================================
NB. ---------------------------------------------------------
NB. cut using frets as seperators
frets =: ' 	' NB. <space> <tab>
cutf =: 3 : '(y e. frets) <;. _2 y' NB. LJ Chap 17.2.4 

NB. from a list of fret separate characters, create a formal ';' seperated array
list =: 3 : 0 NB. add '<>'; to each element, then form right array
 }:;''''&,@,&''';' L:0 cutf y
)

Note
 k0 =. 'क	 ख	ग	घ	ङ '
 k1 =. list k0
 NB. verify and cut paste into script

 
NB. ---------------------------------------------------------
NB. ucp(unicode code point) http://code.jsoftware.com/wiki/Vocabulary/uco 
NB. Note: also parses upto letters --> need additional work to split into sound + vowel 
ucp=: 3 u: 7 u: ]
ucpI =: ucp^:_1
NB. ---------------------------------------------------------
NB. =========================================================

NB. m__ =: '्'		NB. 2381
NB. correct transliteration table between devanagiri & slp1
trT =: 4 : 'a, x ,: ucp L:0 a =.(,&''्'') L:0 y' 

V =: 'अ';'आ';'इ';'ई';'उ';'ऊ';'ए';'ऐ';'ओ';'औ' 	NB. Vowels
cV =: 'a';'A';'i';'I';'u';'U';'e';'E';'o';'O' 	NB. SPL1 code
tV =: V , cV ,: ucp L:0 V			NB. table for Vowels | Code | ucp

S =: 'ऋ';'ॠ';'ऌ';'ॡ'			NB. Sonorants
cS =: 'f';'F';'x';'X'			NB. SPL1 code
tS =: S , cS ,: L:0 S 			NB. table for Sonorants | Code \ ucp

A =: 'अं';'अः'				NB. Anusarga / Visarga
cA =: 'M';'H'				
tA =: A , cA ,: L:0 A

K =: 'क';'ख';'ग';'घ';'ङ'			NB. Velar Consonants
cK =: 'k';'K';'g';'G';'N'
tK =: cK trT K

C =: 'च';'छ';'ज';'झ';'ञ'			NB. Palatal
cC =: 'c';'C';'j';'J';'Y'			
tC =: cC trT C

W =: 'ट';'ठ';'ड';'ढ';'ण'			NB. Retroflex
cW =: 'w';'W';'q';'Q';'R'		
tW =: cW trT W 

T =: 'त';'थ';'द';'ध';'न'			NB. Dental
cT =: 't';'T';'d';'D';'n'
tT =: cT trT T

P =: 'प';'फ';'ब';'भ';'म'			NB. Labial
cP =: 'p';'P';'b';'B';'m'		
tP =: cP trT P

Y =: 'य';'र';'ल';'व'			NB. Semi-vowel
cY =: 'y';'r';'l';'v'
tY =: cY trT Y

F =: 'श';'ष';'स';'ह'			NB. Fricative
cF =: 'S';'z';'s';'h'
tF =: cF trT F


