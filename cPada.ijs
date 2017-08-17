require '~User/projects/jpanini2/matracode.ijs' 
require '~User/projects/jpanini2/pratyAhAr.ijs' 
require 'coutil'
require 'colib'

coclass 'cPada'

NB. ---------------------------------------------------------
NB. Load into current namespace

NB. imported verbs
log =: log_base_ 
ucp =: ucp_base_ 
ucpI =: ucp^:_1  
vlist =: vlist_base_ 
isSvara =: isSvara_base_
isVyanj =: isVyanj_base_



NB. NB. imported nouns
zV   =: V_base_,S_base_   NB.Vowels & Sonorants
zM   =: M_base_   NB. matras
zMV  =: MV_base_  NB. svara corresponding to matra
zAN  =: AN_base_  NB. AnuNasika matras
zpku =: K_base_   NB. pratyAhAra for कु
zpcu =: C_base_   NB. pratyAhAra for चु
zptu =: T_base_   NB. pratyAhAra for तु
zpwu =: W_base_  NB. pratyAhAra for टु

NB. static
tD 	=: 0 0 1 NB. type DAtu
tP 	=: 0 1 0 NB. type pratyaya
tV	=: 1 0 0 NB. type viBakti
tT	=: +/@:*. NB. type Test - returns boolean

NB. ---------------------------------------------------------
NB. create verb
NB. 	arg = rawWord; 3 boolean vector on dAtu-pratyaya-viBakti
NB. usage i =. arg conew 'cDatu'
create=: 3 : 0
 'p dpv' =. y
 mPrakruti =: p
 mIsDPV =: ". dpv NB. to take care of string based input
 mAnupUrvi =: i.0 
 mLopaAnupUrvi =: i.0
 mItMask =: i.0
 mAnupUrvi2 =: i.0 NB. After itsaMjYA
 mAnupUrvi3 =: i.0 NB. After sat-cat process
)

destroy =: codestroy



NB. ---------------------------------------------------------
NB. display verb displays member variables suitably boxed
display =: 3 : 0
 r =. 'name';'value' NB. header
 id =. {. conl 1
 r1 =. 'instanceid '; id  NB. numbered locale
 r2=. r ,: r1
 l=.  copathnl '' NB. gives list of names in instance o
 ll =. ". each l
 i =. -. ll e. a:
 v =. i#(l ,. ll)
 smoutput r2 , v
)

NB. ---------------------------------------------------------
NB. compare pattern of left side occuring on right side
nadCut =: 3 : '((isSvara + isVyanj)y)<;. 1 y' 


NB. ---------------------------------------------------------
NB. doAnupUrvi verb
NB.  	creates the anupUrvi of prakruti 
doAnupUrvi =: 3 : 0
 log w =. ucpI L:0 <"0 ucp mPrakruti
 t =. '्'
 log mi =. (w I.@:e. zM)          NB. indices to replace  
 if. 0 < $mi do.
  log m =. mi { w
NB.   rv =. (zM I.@:e. m) { zMV     NB. ... with vowels
  rv =. , (|: I. "1 |: ( zM =/ m)){zMV NB. ... with vowels including multiplicity
  if. 0 < $rv do.
   rvt =. t&, L:0 rv        	NB. ... add preceeding tail
   mv =. (rvt) (mi)} w 	NB. ... to get the right matra-vowel replacement
  else. mv =. w end.
  mAnup =. ucpI L:0 uw =. nadCut ucp ;mv NB. new mAnupUrvi to work with
 else. mAnup =.ucpI L:0 uw =. nadCut ucp ;w end.
 NB. for all the Vyanj that donot have following tail, 
 NB. do hidden 'अ' changes 
 NB. Index of a pattern of 2 Vyanjanas
 vj2 =. (<"0 (1,1)) I.@E. isVyanj L:0 uw =. <"0 ;uw  
 for_i. vj2 do.
  vj =. i { uw NB. this is the vyanjana that gets replaced
  NB. log vj 	
  nvjs =. ,&(2381,2309) L:0 vj
  NB. smoutput nvjs	
  uw =. (<;nvjs) (i)} uw
  NB. log uw
 end.
 mAnupUrvi =: ucpI L:0 nadCut ;uw
 log mItMask =: (#mAnupUrvi) $ 0
)

NB. ---------------------------------------------------------
NB. undoAnupUrvi verb
NB.  	gets back the word with matras
NB.	usage: undoAnupUrvi 'क्ष्व्इद्'
undoAnupUrvi =: 3 : 0
  w =. ucp ;mLopaAnupUrvi
  t =. '्'
  Mf =. a:,zM
  Vf =. 'अ';zMV
  tP =. (;w) e. ucp t 		NB. tail is present
  vP =. (;w) e. (;ucp L:0 Vf)	NB. Vowel is present
  tv =. (1,1) I.@E. tP + vP 		NB. check for 1 1 pattern for consecutive presence
  vl =. ((>:tv){ ucpI L:0 <"0 w)	NB. list of vowels
  vi =. ,(|: I. "1 |: (Vf =/ vl))	NB. indices of vowels
  ml =. vi {Mf			NB. array of matras 
  rl =. -. (1) (tv)} (#w)$0		NB. locations to box out
  nw =. rl <;.2 w			NB. boxed new word to be replaced with matras
  tv2 =. tv - i. (#tv)		NB. indices have to be reduced progressively!
  wm =. (ucp L:0 ml) (tv2)} nw	NB. replace with matra UCP
  mLopaPrakruti =: ; ucpI L:0 wm	
)


NB. ---------------------------------------------------------
NB. इत्संज्ञा(itsaMjYA) Set
NB. ---------------------------------------------------------


NB. ---------------------------------------------------------
NB. doAjanunAsika verb
NB. 1.3.2 - उपदेशेऽजनुनासिक इत्
doAjanunAsika =: 3 : 0
 if. 0 = mAnupUrvi do. doAnupUrvi '' end.
 log mAnupUrvi
 ac =. 'अ';zMV NB. all possible matras have to be accounted for
 NB.  ac =. vlist  'अच्'  NB. 'अच्' does not account for long vowels :(!
 n =. zAN
 acN =. i.0
 for_i. n do.	NB. creates combinations as required by 1.3.2
  log j =. ;i
  acN0 =. ,&j L:0 ac
  acN =. acN , acN0
 end.
 log mItMask =: mAnupUrvi e. acN
)

NB. ---------------------------------------------------------
NB. doHlNtusm verb
NB. 1.3.3 - हलन्त्यम्
NB. 1.3.4 - न विभक्तौ तुस्माः
doHlNtusm =: 3 : 0
 if. 0 = mAnupUrvi do. doAnupUrvi '' end.
 tail =. '्'
 check_hl =. ,&tail L:0 hl =. (vlist  'हल्') -. a:
 tusm =. zptu ,'स';'म'
 check_hlNTusm =. ,&tail L:0 hlNtusm =. hl -. tusm  NB. remove tusm for viBakti
 
 log ll =. {: mAnupUrvi
 if. 1 = {: mItMask do. return. end. NB. because of 1.3.2 
 if. 1 = (tV tT mIsDPV) do. it =. ll e. check_hlNTusm
 else. it =. ll e. check_hl end.
 log mItMask =: (it)(<:#mItMask)}mItMask NB. replace as required
)

NB. ---------------------------------------------------------
NB. doAdiYiwuqu verb
NB. 1.3.5 - आदिर्ञिटुदवः
doAdiYiwuqu=: 3 : 0
 Yiwuqu =. 'ञि';'टु';'डु'
 lAdi =. < ucpI 2 {. ucp mPrakruti NB. better to pick up from mPrakruti
 log lAdi e. Yiwuqu 
 if. 0 < lAdi e. Yiwuqu do. NB. first two letters in!
   mItMask =: (1)(0 1)}mItMask
 end.
 log mItMask 
)
NB.test set
NB. ywq1 =. 'ञिक्ष्विदाँ' ; '0 0 1'

NB. ---------------------------------------------------------
NB. doZPratyaya verb
NB. 1.3.6 - षः प्रत्ययस्य
NB. 	assume only first letter matters (all matras!)
doZPratyaya =: 3 : 0
 z =. 'ष'		
 lAdi =. < ucpI 1 {. ucp mPrakruti
 log zB=. lAdi e. z
 if. 1 = (tP tT mIsDPV)*. zB do. 
   mItMask =: (1)(0)}mItMask  NB. what happens to the svara?
 end. 
 log mItMask
)

NB. ---------------------------------------------------------
NB. doCWPratyaya verb
NB. 1.3.7 - चुटू
NB. 1.3.8 - लशक्वतद्धिते
doCWlSKPratyaya =: 3 : 0
 cW =. zpcu , zpwu	, 'ल' ; 'श'; zpku	
 lAdi =. < ucpI 1 {. ucp mPrakruti
 log zcW=. lAdi e. cW
 if. 1 = (tP tT mIsDPV)*. zcW do. 
   mItMask =: (1)(0)}mItMask 
 end. 
 log mItMask
)
NB. test set
NB. cw =. 'ण्यत्';'0 1 0'
NB. lsk =. 'क्त्वा' ; '0 1 0'

NB. ---------------------------------------------------------
NB. doIr verb
NB. इर इत्सञ्ज्ञा वाच्या 
doIr =: 3 : 0
 if. 0 = mAnupUrvi do. doAnupUrvi '' end.
 ir =. 'इ';'र्' 
 loc =. ir E. mAnupUrvi NB. locate if there is ir in the word
 l =. #mAnupUrvi
 if. (l - 2 )= loc do.  NB. l-1 is last index
  mItMask =: (1)((l-2),(l-1))}mItMask
 end.
 log mItMask
)
NB. test set
NB. ir =. 'दृशिर्';'0 0 1'

NB. ---------------------------------------------------------
NB. doItsaMjYA verb
NB. 	right sequence of calls
doItsaMjYA =: 3 : 0
 doAnupUrvi ''
 doAjanunAsika ''
 doHlNtusm ''
 doAdiYiwuqu ''
 doZPratyaya ''
 doCWlSKPratyaya ''
 doIr ''
 log mItMask
 NB. Apply it
 notIt =. I. -. mItMask
 mItAnupUrvi =: mLopaAnupUrvi =: (#mAnupUrvi) $ a:
 mLopaAnupUrvi =: (notIt { mAnupUrvi) (notIt)}mLopaAnupUrvi
 it =. I. mItMask
 mItAnupUrvi =: (it { mAnupUrvi) (it)}mItAnupUrvi
 undoAnupUrvi ''
)




NB. =========================================================
NB. Test Area for verbs

NB. ---------------------------------------------------------
NB. list2
frets2 =: '	' NB. <tab>
cutf2 =: 3 : '(y e. frets2) <;. _2 y' NB. LJ Chap 17.2.4 

NB. from a list of fret separate characters, create a formal ';' seperated array
list2 =: 3 : 0 NB. add '<>'; to each element, then form right array
 }:;''''&,@,&''';' L:0 cutf2 y
)
NB. ---------------------------------------------------------


]a =. 'क्लिदूँ'
]b =. ucpI L:0 <"0 ucp a
NB. ]c =. (b I.@:e. zM)  {. zMV

NB. flf1 =. 'क्लिदूँ	ञिक्ष्विदाँ	डिपँ	लुपँ	नृतीँ	रि	टुमस्जोँ	विद्लृँ	ह्नुङ्	इङ्	ऊर्णुञ्	ब्रूञ्	गाङ्	ञिष्वपँ	चकासृँ	णिनिँ	क्त	तस् 	णमुँल्	इनुँण्	ण्यत्	क्यप्	श्यन्	श्ना	तिप् 	टक्	घञ्	ङ्वनिँप्	नङ्	क्त्वा	क्तवतुँ	तव्य	अनीयर्	ध्वम् 	तृन्	मनिँन्	तुमुँन्	ल्युट्	तात् 	महिङ् 	इट् 	वस् 	आताम् 	थास् 	घ 	'
NB. ]fl1 =: (". list flf1) -. a: NB. for some reason there are empty boxes
NB. flt1 =. '0 0 1 	0 0 1 	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 1 0 	0 1 0 	1 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	1 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	1 1 0	0 1 0	0 1 0	0 1 0	0 1 0	1 1 0	1 1 0	1 1 0	1 1 0	1 1 0	1 1 0	0 1 0	'
NB. ]ft1 =: ". list2 flt1 NB. as strings!
NB. nfl =: <"1 fl1 ,. ft1 NB. normalized list of words with form <word> <type-boolean-string>

NB. =========================================================
NB. Test Area for objects


cocurrent 'base'
log =: ]

applyItS =: 3 : 0
 a =. y conew 'cPada'
 doItsaMjYA__a ''
 r =. (<mPrakruti__a) ; mAnupUrvi__a ; mItAnupUrvi__a ; mLopaAnupUrvi__a ;<mLopaPrakruti__a
 destroy__a ''
 ; L:1 r
)



a0 =. 'टुमस्जोँ';('0 0 1')
hl0 =. 'क्लिदूँ';('0 0 1') NB. 0 0 0 0 0 0 0 0 0
hl11 =. 'बूञ्';('0 0 1') NB. 0 0 0 1 0
hl12 =. 'गाङ्';('0 0 1') NB. 0 0 0 1 0
tusm0 =. 'तस्';('1 1 0') NB. 0 0 0 (yes tusm)
tusm11 =. 'तिप्';('1 1 0') NB. 0 0 0 1 0  (no tusm)
tusm12 =.  'टक्';('0 1 0') NB. 0 1 0  (no tusm)
tusm13 =. 'घञ्';('0 1 0') NB. 0 1 0  (no tusm)
ywq1 =. 'ञिक्ष्विदाँ' ; '0 0 1' NB.ywq
cw =. 'ण्यत्';'0 1 0' NB.  1 0 1 (hl + cw)
lsk =. 'क्त्वा' ; '0 1 0' NB.  1 0 1 (hl + cw [lsk])
uap1 =. 'अनीयर्' ; '0 1 0'
uap2 =. 'महिङ्' ; '1 1 0'
a1 =. 'लुपँ';'0 0 1' NB. test elimination of last 'अ'

]pl =: a0 ; hl0 ; hl12; tusm0 ; tusm11 ; tusm12 ;tusm13 ;ywq1 ;cw ;<lsk 



p =. tusm0 conew 'cPada' NB. check if there is no Matra!
doAnupUrvi__p ''
doAjanunAsika__p''
doItsaMjYA__p''
display__p ''
destroy__p ''

p =. ywq1 conew 'cPada' NB. check if there is no Matra!
mPrakruti__p 
doAnupUrvi__p ''
display__p ''
destroy__p ''

p =. tusm12 conew 'cPada' NB. check for chutu
mPrakruti__p 
doAnupUrvi__p ''
doAjanunAsika__p ''
doHlNtusm__p ''
doCWlSKPratyaya__p ''
display__p ''
destroy__p ''

p =. uap2 conew 'cPada' NB. check for undoAnupUrvi
mPrakruti__p 
doItsaMjYA__p ''
display__p ''
destroy__p ''

]f=:applyItS L:1 pl
;"1 ,. f

NB. Lesson 8 full set  (DAtu | prakriya | viBakti)
frets2 =: '	' NB. <tab>
cutf2 =: 3 : '(y e. frets2) <;. _2 y' NB. LJ Chap 17.2.4 

NB. from a list of fret separate characters, create a formal ';' seperated array
list2 =: 3 : 0 NB. add '<>'; to each element, then form right array
 }:;''''&,@,&''';' L:0 cutf2 y
)

NB. flf1 =. 'क्लिदूँ	ञिक्ष्विदाँ	डिपँ	लुपँ	नृतीँ	रि	टुमस्जोँ	विद्लृँ	ह्नुङ्	इङ्	ऊर्णुञ्	ब्रूञ्	गाङ्	ञिष्वपँ	चकासृँ	णिनिँ	क्त	तस् 	णमुँल्	इनुँण्	ण्यत्	क्यप्	श्यन्	श्ना	तिप् 	टक्	घञ्	ङ्वनिँप्	नङ्	क्त्वा	क्तवतुँ	तव्य	ध्वम् 	तृन्	मनिँन्	तुमुँन्	ल्युट्	तात् 	महिङ् 	इट् 	वस् 	आताम् 	थास् 	घ 	'
flf1 =. 'क्लिदूँ	ञिक्ष्विदाँ	डिपँ	लुपँ	नृतीँ	रि	टुमस्जोँ	विद्लृँ	ह्नुङ्	इङ्	ऊर्णुञ्	ब्रूञ्	गाङ्	ञिष्वपँ	चकासृँ	णिनिँ	क्त	तस् 	णमुँल्	इनुँण्	ण्यत्	क्यप्	श्यन्	श्ना	तिप् 	टक्	घञ्	ङ्वनिँप्	नङ्	क्त्वा	क्तवतुँ	तव्य	अनीयर्	ध्वम् 	तृन्	मनिँन्	तुमुँन्	ल्युट्	तात् 	महिङ् 	इट् 	वस् 	आताम् 	थास् 	घ 	'
]fl1 =: (". list flf1) -. a: NB. for some reason there are empty boxes
NB. flt1 =. '0 0 1 	0 0 1 	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 1 0 	0 1 0 	1 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	1 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	1 1 0	0 1 0	0 1 0	0 1 0	0 1 0	1 1 0	1 1 0	1 1 0	1 1 0	1 1 0	1 1 0	0 1 0	'
flt1 =. '0 0 1 	0 0 1 	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 0 1	0 1 0 	0 1 0 	1 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	1 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	0 1 0	1 1 0	0 1 0	0 1 0	0 1 0	0 1 0	1 1 0	1 1 0	1 1 0	1 1 0	1 1 0	1 1 0	0 1 0	'
]ft1 =: ". list2 flt1 NB. as strings!
nfl =: <"1 fl1 ,. ft1 NB. normalized list of words with form <word> <type-boolean-string>

log =: ]
]f=:applyItS L:1 nfl
;"1 ,. f




coreset ''