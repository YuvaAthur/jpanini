require '~User/projects/pg/wops.ijs' 
require '~User/projects/pg/matracode.ijs' 
require '~User/projects/pg/pratyAhAr.ijs' 
require 'coutil'
require 'colib'



coclass 'cDAtu'


NB. ---------------------------------------------------------
NB. imported verbs
log =: log_base_ 
ucp =: ucp_base_ 
ucpI =: ucp^:_1  
uAnup =: uAnup_base_  
vlist =: vlist_base_ 

NB. imported nouns
zuAnunk =: uAnunk_base_
zuSvara =: uSvara_base_
zpku =: K_base_  NB. pratyAhAra for कु
zpcu =: C_base_  NB. pratyAhAra for चु
zptu =: T_base_  NB. pratyAhAra for तु
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
 mItMask =: i.0
 mAnupUrvi2 =: i.0 NB. After itsaMjYA
 mAnupUrvi3 =: i.0 NB. After sat-cat process
  mSatCatInitF =: 0
)

destroy =: codestroy

NB. ---------------------------------------------------------
NB. doAnupUrvi verb
NB.  	creates the anupUrvi of prakruti
doAnupUrvi =: 3 : 0
 log mAnupUrvi =: ucpI L:0  uAnup mPrakruti
 mItMask =: (#mAnupUrvi) $ 0
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
 ac =. ucpI L:0 <"0 zuSvara
 NB.  ac =. vlist  'अच्'  NB. 'अच्' does not account for long vowels :(!
 n =. ucpI L:0 <"0 zuAnunk
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
 cW =. zpcu ; zpwu	; 'ल' ; 'श'; zpku	
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
)


NB. ---------------------------------------------------------
NB. सत्वादि चत्वारि(satvAdi catvAri) Set
NB. 	corresponds to transformations
NB. 	should be performed _after_ इत्संज्ञा completed
NB. ---------------------------------------------------------

NB. ---------------------------------------------------------
NB. doSatCatInit verb
NB.	complete इत्संज्ञा
NB. 	set the remainder anuPurvi 
doSatCatInit =: 3 : 0
 doItsaMjYA ''
 mAnupUrvi2 =: (-. mItMask)# mAnupUrvi
 mSatCatInitF =: 1
 log mAnupUrvi2
)

NB. ---------------------------------------------------------
NB. doYuvu verb
NB. 7.1.1 युवोरनाकौ 
doYuvu =: 3 : 0
 if. 0 = mSatCatInitF do. doSatCatInit '' end.
 yuvu =. 'यु'; 'वु'
 postIt =. ; mAnupUrvi2 NB. make it a word
 loc =. yuvu e. postIt
 if. 1 = (tP tT mIsDPV)*. ( +/ loc) do. 
  if. {. loc do. mAnupUrvi3 =: 'अन्'  NB. 'यु' transformation
  else. mAnupUrvi3 =: 'अक्' end.
 end.
 log mAnupUrvi3
)


NB. ---------------------------------------------------------
NB. doVa verb
NB. 6.1.67 वेरपृक्तस्य
doVa =: 3 : 0
 if. 0 = mAnupUrvi do. doAnupUrvi '' end.
 v =.'व्'
 rest =. (-. mItMask) # mAnupUrvi
 if. 1 = (tP tT mIsDPV)*. (v e. rest) do. 
  i =. 0 (I.@:E.) mItMask 
  assert. (1= #i) NB. there should be only 1!
  mItMask =: (1)(i)}mItMask
 log mItMask
)
NB. test 
NB. va =. 'क्विँप्' ; '0 1 0'




NB. ---------------------------------------------------------
NB. doZ verb
NB. 6.1.64 धात्वादेः षः सः 

NB. ---------------------------------------------------------
NB. doR verb
NB. 6.1.65 णो नः  

NB. ---------------------------------------------------------
NB. dIdit verb
NB. 7.1.58 इदितो नुम् धातोः  

NB. ---------------------------------------------------------
NB. doUpadaRV verb
NB. 8.2.78 उपधायां च  


NB. ---------------------------------------------------------
NB. display verb displays member variables suitably boxed
display =: 3 : 0
 r =. 'name';'value' NB. header
 log id =. {. conl 1
 r1 =. 'instanceid '; id  NB. numbered locale
 r2=. r ,: r1
 log l=.  copathnl '' NB. gives list of names in instance o
 log ll =. ". each l
 log i =. -. ll e. a:
 log v =. i#(l ,. ll)
 log r2 , v
)

NB. =========================================================

NB. =========================================================
NB. Test area for class
cocurrent 'base'
ac1 =. 'क्लिदूँ';'0 0 1' 
a =: ac1 conew 'cDAtu'
doAnupUrvi__a ''
doAjanunAsika__a ''
doHlNtusm__a ''
display__a ''
destroy__a ''


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

NB. new test
a =: ywq1 conew 'cDAtu'
doAnupUrvi__a ''
] mPrakruti =: mPrakruti__a
] mIsDPV =: mIsDPV__a
] mAnupUrvi =: mAnupUrvi__a
] mItMask =: mItMask__a

doAjanunAsika__a ''
mItMask__a 

doHlNtusm__a ''
mItMask__a 

doAdiYiwuqu__a ''
mItMask__a 

log =: smoutput

display__a ''
destroy__a ''

a =: cw conew 'cDAtu'
doHlNtusm__a ''
mItMask__a 

doCWlSKPratyaya__a ''
mItMask__a 

NB. display__a ''
NB. destroy__a ''


NB. coreset '' NB. destroy all created locales
NB. conl 1     NB. test that all are destroyed


