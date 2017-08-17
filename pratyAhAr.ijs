NB. this is a file that holds the encoding description of 
NB. Panini Grammar

NB. Sanskrit from english typing: http://sanskrit.indiatyping.com/

NB. pratyAhAr (प्रत्याहार ) = code that is built out of माहेश्वर सूत्राणि

require '~User/projects/pg/slp1code.ijs' 

NB. 14 sutras based on phonemes
s_aR =: ". list 'अ इ उ ण् ' NB. needs trailing space for list to work right
s_fk =: ". list 'ऋ लृ क् ' NB. r lru k	
s_eN =: ". list 'ए ओ ङ् ' NB. e O N
s_EC =: ". list 'ऐ औ च् ' NB. Ai Au c
s_hw =: ". list 'ह य व र ट् ' 
s_lR =: ". list 'ल ण् '
s_Ym =: ". list 'ञ म ङ ण न म्' 
s_JY =: ". list 'झ भ ञ् '
s_Gz =: ". list 'घ ढ ध ष् '
s_jS =: ". list 'ज ब ग ड द श् '
s_Kv =: ". list 'ख फ छ ठ थ च ट त व् '
s_ky =: ". list 'क प य् '
s_Sr =: ". list 'श ष स र् '
s_hl =: ". list 'ह ल् '


s_frets =: ". list 'ण् क् ङ् च् ट् म् ञ् ष् श् व् य् र् ल् '

]s_all =: s_aR,s_fk,s_eN,s_EC,s_hw,s_lR,s_Ym,s_JY,s_Gz,s_jS,s_Kv,s_ky,s_Sr,s_hl 

]s_tusm =: T ,'स';'म'  	NB. for 1.3.4 - न विभक्तौ तुस्माः

NB. =========================================================
NB.
NB. ---------------------------------------------------------
NB. vlist verb varna list from pratyAhAr (without trailing '्')
NB. 	cuts froms mAhesvara sutra list
NB. 	direct view of devanagiti as j array causes error
NB. 	note that there is no without trailing '्'
NB. usage:  vlist 'अक्'
vlist =: 3 : 0
 s =. {. < {.&.ucp y NB. take first occurance only for double 'ह' case
 f =. < }.&.ucp y
 a =. (s_all i. f) {. (s_all i. s) }. s_all NB. contains frets inbetween
 ~.(-. a e. s_frets)#a NB. remove any intermediate frets
)

NB. =========================================================
NB. test area for verbs
]ak =. vlist  'अक्'
]hl =. vlist  'हल्'