require 'coutil'
require 'colib'

require '~User/projects/jpanini2/cPada.ijs' 




coclass 'cDAtuFactory'
NB. manages lifecycle of cDAtu objects | destroys cDAtu objects created in destructor

NB. ---------------------------------------------------------
NB. imported verbs
log =: log_base_ 

create =: 3 : 0
 mRawData =: i.0  	 NB. array of prakruti | type indicator
 mDL =: i.0      NB. list of cDAtu objects created
)

NB. ---------------------------------------------------------
NB. destroy verb deletes instances created
destroy =: 3 : 0   
 log 'have to destroy local instances'
 for_o. mDL do.
   log ".('destroy__o ''''')
 end.
 codestroy ''
)


NB. ---------------------------------------------------------
NB. makeDL verb instantiates the objects based on input
NB.	
NB. usage: makeDL__ff q
makeDL =: 3 : 0
 log a =. mRawData =: y
 for_i. i. #a do.   NB. integer progression
  log oName =. 'cD',(":i)
  'D t' =.  ; i { a NB. parse to reform
  log cStr =.  oName,' =. (''',D,''';''',t,''') conew ''cDAtu'''
  o =. ". cStr
  log mDL =: mDL , (". oName) NB. print an object instance gives boxed instance id
 end.
)

NB. ---------------------------------------------------------
NB. attrib verb get the member variable 
NB.	
NB. usage: attrib__ff 'mPrakruti'
getAtr =: 3 : 0
 log pn =. y,'_' NB. attribute name
 NB. objects are glorified locales | locales are identified by numbers 
 cL =. pn&, L:0 mDL
 cL =. ,&'_' L:0 cL
 ". L:0 cL
)


NB. ---------------------------------------------------------
NB. apply verb applies function with 0 or 1 argument
NB.
NB. usage: '' apply__ff 'doAnupUrvi'
NB. usage: '1' apply__ff 'conl'
applyFn =: 4 : 0
 '' applyFn y
 :
 log fn =. y,,'_'      	NB. function to be applied as string - no arguments
 arg =. x
 if. ('' -: arg) do. arg =. '''''' end.
 arg =. '_ ',arg		NB. assume x is string formated correctly
 cL =.fn&, L:0 mDL
 cL =. ,&arg L:0 cL
 ". L:0 cL
)

 
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
NB. Test Area for verbs
cocurrent 'base'

NB. log =: [


hl0 =. 'क्लिदूँ';('0 0 1') NB. 0 0 0 0 0 0 0 0 0
hl11 =. 'बूञ्';('0 0 1') NB. 0 0 0 1 0
hl12 =. 'गाङ्';('0 0 1') NB. 0 0 0 1 0
tusm0 =. 'तस्';('1 1 0') NB. 0 0 0 (yes tusm)
tusm11 =. 'तिप्';('1 1 0') NB. 0 0 0 1 0  (no tusm)
tusm12 =.  'टक्';('0 1 0') NB. 0 1 0  (no tusm)
tusm13 =. 'घञ्';('0 1 0') NB. 0 1 0  (no tusm)


NB. Factory testing
ff =: '' conew 'cDAtuFactory'
q =. tusm13 ; tusm12; tusm11; tusm0;hl12;hl11;<hl0
makeDL__ff q
getAtr__ff 'mPrakruti'
'' applyFn__ff 'doAnupUrvi'
NB. apply0__ff 'doAnupUrvi'
getAtr__ff 'mAnupUrvi'
'' applyFn__ff 'display'
show__ff '' NB. build in verb!


destroy__ff ''

NB. coreset '' NB. destroy all created locales
NB. conl 1     NB. test that all are destroyed


