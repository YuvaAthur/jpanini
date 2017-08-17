NB. get all possible matra ticks as unicode numbers

NB. क का कि की कु कू  के कै को कौ कं कः कृ क्रू
NB. Also check http://tdil-dc.in/san/transliteration/table.html 


require '~User/projects/pg/slp1code.ijs' 

NB.commonly occuring in धातु
m_A =: 'ा'		NB. 2366 
m_i =: 'ि'		NB. 2367 
m_I =: 'ी'		NB. 2368 
m_u =: 'ु'		NB. 2369 
m_U =: 'ू'		NB. 2370 
m_e =: 'े'		NB. 2375 
m_E =: 'ै'		NB. 2376   
m_o =: 'ो'		NB. 2379 
m_O =: 'ौ'		NB. 2380 
m_f =: 'ृ'		NB. 2371
m__ =: '्'		NB. 2381

NB. anunAsika 
m_C =: 'ँ'		NB. 2305  NB. '~'
m_M =: 'ं'		NB. 2306  NB. 'M'
m_H =: 'ः'		NB. 2307  NB. 'H'

NB. additional ones : https://en.wikipedia.org/wiki/Devanagari_(Unicode_block)
m_F =: 'ॄ'
m_c =: 'ॅ'
m_x =: 'ॢ'
m_X =: 'ॣ'

NB. list of matras
M  =: ". }: ; 'm_'&,@,&';' L:0 <"0 'AiIuUeEoOfxCMH' 
NB. list of matras svaras
MV =: 'आ';'इ';'ई';'उ';'ऊ';'ए';'ऐ';'ओ';'औ';'ऋ';'ऌ';'अँ';'अं';'अः'				NB. Anusarga / Visarga
AN =:  'ँ'; 'ं';'ः'

NB. consonants ==> ucp e. [2325,2361]

NB. matras ucp e. [2366,2371],[2375,2376],[2379,2380],2306,2307,2402 
NB. vowel-marks : M H : 2306 2307
NB. consonants ==> ucp e. [2325,2361]
NB. vowels : [2309,2316],[2319,2320],[2323,2324]


uMatra =: 2366 2367 2368 2369 2370 2375 2376 2379 2380 2371 2402 2306 2307 
uSvara =: 2309 2310 2311 2312 2313 2314 2315 2316 2319 2320 2323 2324
uVyanj =: 2325 + i.37
uAnunk =: 2304 2305 2306 NB. anunAsika

isMatra =: 3 :'y e. uMatra'
isSvara =: 3 :'y e. uSvara'
isVyanj =: 3 :'y e. uVyanj'
isAnunk =: 3 :'y e. uAnunk'

NB. स is 2360
NB. =========================================================
NB. Test Area for definitions/verbs

NB. Matra-Vowel map
]V2 =: (}. V),(0 2 { S),A NB. complete list of vowels
]MV2 =: M ,: V2
(isSvara;isVyanj;isMatra; isAnunk) ucp 'इनुँण्' NB. applies the tests in parallel



