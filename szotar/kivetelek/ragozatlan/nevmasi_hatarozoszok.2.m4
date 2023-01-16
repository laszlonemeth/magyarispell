# 
#  Személyes névmások, névmási határozószók
#
#  2003.05.20. tövek
#  1999.10.14. +iránt+után
#  1999.09.11.

#   1    2   345 6
# alap  aeáé oua rag
#            eüe

# XXX LEMMA_PRESENT KELL!

# elavult, népies kell? Pl. elejbem

define(nevmas_rag,
$1$2m$7	$1$2[noun_pron]+[SG_1]+$5
én$1$2m$7	$1$2[noun_pron]+[SG_1]+$5+[EMPH]
$1$2d$7	$1$2[noun_pron]+[SG_2]+$5
te$1$2d$7	$1$2[noun_pron]+[SG_2]+$5+[EMPH]
`ifelse(regexp('$7`,.),-1,
$1$2$7	$1$2[noun_pron]+[SG_3]+$5,
$1$2$7	$1$2[noun_pron]+[SG_3]+$5)'
ő$1$2$7	$1$2[noun_pron]+[SG_3]+$5+[EMPH]
`ifelse(regexp('$2`,[áé]),-1,
$1$4nk$7	$1$2[noun_pron]+[PL_1]+$5
mi$1$4nk$7	$1$2[noun_pron]+[PL_1]+$5+[EMPH]
$1$2t$3k$7	$1$2[noun_pron]+[PL_2]+$5
ti$1$2t$3k$7	$1$2[noun_pron]+[PL_2]+$5+[EMPH]
$1$4k$7	$1$2[noun_pron]+[PL_3]+$5
ő$1$4k$7	$1$2[noun_pron]+[PL_3]+$5+[EMPH]
,
$1$2j$6$7	$1$2[noun_pron]+[SG_3]+$5
ő$1$2j$6$7	$1$2[noun_pron]+[SG_3]+$5+[EMPH]
$1$2nk$7	$1$2[noun_pron]+[PL_1]+$5
mi$1$2nk$7	$1$2[noun_pron]+[PL_1]+$5+[EMPH]
$1$2t$3k	$1$2[noun_pron]+[PL_2]+$5
ti$1$2t$3k	$1$2[noun_pron]+[PL_2]+$5+[EMPH]
$1$2j$4k$7	$1$2[noun_pron]+[PL_3]+$5
ő$1$2j$4k$7	$1$2[noun_pron]+[PL_3]+$5+[EMPH])'
)

define(nevmas_uto,
$1$2m$7	$1$2[noun_pron]+[POSTP($1$5)]+[SG_1]$8
én$1$2m$7	$1$2[noun_pron]+[POSTP($1$5)]+[SG_1]+[EMPH]$8
$1$2d$7	$1$2[noun_pron]+[POSTP($1$5)]+[SG_2]$8
te$1$2d$7	$1$2[noun_pron]+[POSTP($1$5)]+[SG_2]+[EMPH]$8
`ifelse(regexp('$7`,.),-1,
$1$2$7	$1$2[noun_pron]+[POSTP($1$5)]+[SG_3]$8,
$1$2$7	$1$2[noun_pron]+[POSTP($1$5)]+[SG_3]$8)'
ő$1$2$7	$1$2[noun_pron]+[POSTP($1$5)]+[SG_3]+[EMPH]$8
`ifelse(regexp('$2`,[áé]),-1,
$1$4nk$7	$1$2[noun_pron]+[POSTP($1$5)]+[PL_1]$8
mi$1$4nk$7	$1$2[noun_pron]+[POSTP($1$5)]+[PL_1]+[EMPH]$8
$1$2t$3k$7	$1$2[noun_pron]+[POSTP($1$5)]+[PL_2]$8
ti$1$2t$3k$7	$1$2[noun_pron]+[POSTP($1$5)]+[PL_2]+[EMPH]$8
$1$4k$7	$1$2[noun_pron]+[POSTP($1$5)]+[PL_3]$8
ő$1$4k$7	$1$2[noun_pron]+[POSTP($1$5)]+[PL_3]+[EMPH]$8
,
$1$2j$6$7	$1$2[noun_pron]+[POSTP($1$5)]+[SG_3]$8
ő$1$2j$6$7	$1$2[noun_pron]+[POSTP($1$5)]+[SG_3]+[EMPH]$8
$1$2nk$7	$1$2[noun_pron]+[POSTP($1$5)]+[PL_1]$8
mi$1$2nk$7	$1$2[noun_pron]+[POSTP($1$5)]+[PL_1]+[EMPH]$8
$1$2t$3k	$1$2[noun_pron]+[POSTP($1$5)]+[PL_2]$8
ti$1$2t$3k	$1$2[noun_pron]+[POSTP($1$5)]+[PL_2]+[EMPH]$8
$1$2j$4k$7	$1$2[noun_pron]+[POSTP($1$5)]+[PL_3]$8
ő$1$2j$4k$7	$1$2[noun_pron]+[POSTP($1$5)]+[PL_3]+[EMPH]$8)'
)


# kivételek 

én	én[noun_pron]{+[SG_1]+[NOM]}
te	én[noun_pron]+[SG_2]+[NOM]
ő	én[noun_pron]+[SG_3]+[NOM]
mi	én[noun_pron]+[PL_1]+[NOM]
ti	én[noun_pron]+[PL_2]+[NOM]
ők	én[noun_pron]+[PL_3]+[NOM]

engem	én[noun_pron]+[SG_1]+[ACC]
engemet/&	én[noun_pron]+[SG_1]+[ACC]
téged	én[noun_pron]+[SG_2]+[ACC]
tégedet/&	én[noun_pron]+[SG_2]+[ACC]
őt	én[noun_pron]+[SG_3]+[ACC]
minket	én[noun_pron]+[PL_1]+[ACC]
titeket	én[noun_pron]+[PL_2]+[ACC]
őket	én[noun_pron]+[PL_3]+[ACC]

nekem	én[noun_pron]+[SG_1]+[DAT]
neked	én[noun_pron]+[SG_2]+[DAT]
neki	én[noun_pron]+[SG_3]+[DAT]
nekünk	én[noun_pron]+[PL_1]+[DAT]
nektek	én[noun_pron]+[PL_2]+[DAT]
nekik	én[noun_pron]+[PL_3]+[DAT]
énnekem	én[noun_pron]+[SG_1]+[DAT]+[EMPH]
teneked	én[noun_pron]+[SG_2]+[DAT]+[EMPH]
őneki	én[noun_pron]+[SG_3]+[DAT]+[EMPH]
minekünk	én[noun_pron]+[PL_1]+[DAT]+[EMPH]
tinektek	én[noun_pron]+[PL_2]+[DAT]+[EMPH]
őnekik	én[noun_pron]+[PL_3]+[DAT]+[EMPH]

enyém/VÓ×n	én[noun_pron]+[SG_1]+[POSS]{+[NOM]}
enyémek/VÓ×n	én[noun_pron]+[SG_1]+[POSS]+[PLUR]{+[NOM]}
enyéim/VÓ×n	én[noun_pron]+[SG_1]+[POSS]+[PLUR]{+[NOM]}
tiéd/VÓ×n	én[noun_pron]+[SG_2]+[POSS]{+[NOM]}
tied/VÓ×n	én[noun_pron]+[SG_2]+[POSS]{+[NOM]}
tiéid/VÓ×n	én[noun_pron]+[SG_2]+[POSS]+[PLUR]{+[NOM]}
tieid/VÓ×n	én[noun_pron]+[SG_2]+[POSS]+[PLUR]{+[NOM]}
övé/VĐÓŐ	én[noun_pron]+[SG_3]+[POSS]{+[NOM]}
övéi/VĐÓŐ	én[noun_pron]+[SG_3]+[POSS]+[PLUR]{+[NOM]}
miénk/VÓ×n	én[noun_pron]+[PL_1]+[POSS]{+[NOM]}
mienk/VÓ×n	én[noun_pron]+[PL_1]+[POSS]{+[NOM]}
miéink/VÓ×n	én[noun_pron]+[PL_1]+[POSS]+[PLUR]{+[NOM]}
mieink/VÓ×n	én[noun_pron]+[PL_1]+[POSS]+[PLUR]{+[NOM]}
tiétek/VÓ×n	én[noun_pron]+[PL_2]+[POSS]{+[NOM]}
tietek/VÓ×n	én[noun_pron]+[PL_2]+[POSS]{+[NOM]}
tiéitek/VÓ×n	én[noun_pron]+[PL_2]+[POSS]+[PLUR]{+[NOM]}
tieitek/VÓ×n	én[noun_pron]+[PL_2]+[POSS]+[PLUR]{+[NOM]}
övék/VÓ×n	én[noun_pron]+[PL_3]+[POSS]{+[NOM]}
övüké/VÓ×n	én[noun_pron]+[PL_3]+[POSS]{+[NOM]}
övéké/VÓ×n	én[noun_pron]+[PL_3]+[POSS]{+[NOM]}
övéik/VÓ×n	én[noun_pron]+[PL_3]+[POSS]+[PLUR]{+[NOM]}

# tesztek:
#<belétek>	belé
#<tibelétek>	belé
#<rátok>	rá
#<tirátok>	rá
#<reátok>	reá
#<tireátok>	reá
#<véletek>	véle
#<tivéletek>	véle
#<alátok>	alá
#<tialátok>	alá
#<felétek>	felé
#<tifelétek>	felé
#<fölétek>	fölé
#<tifölétek>	fölé
#<elétek>	elé
#<tielétek>	elé
#<mögétek>	mögé
#<timögétek>	mögé
#<mellétek>	mellé
#<timellétek>	mellé
#<közétek>	közé
#<tiközétek>	közé
#<körétek>	köré
#<tikörétek>	köré
#<hozzátok>	hozzá
#<tihozzátok>	hozzá
#<elibétek>	elibé
#<tielibétek>	elibé
#<fölibétek>	fölibé
#<tifölibétek>	fölibé
#<fölébem>	fölébe
#<fölébük>	fölébe
#<közibétek>	közibé
#<tiközibétek>	közibé

# esetragokhoz kapcsolódó névmások

nevmas_rag(benn,e,e,ü,[INE])
nevmas_rag(bel,é,e,ü,[ILL],e)
nevmas_rag(belől,e,e,ü,[ELA],"")
nevmas_rag(rajt,a,o,u,[SUE])
nevmas_rag(r,á,o,u,[SBL],a)
nevmas_rag(re,á,o,u,[SBL]+[SUBS],a)
nevmas_rag(ról,a,o,u,[DEL])
nevmas_rag(nál,a,o,u,[ADE])
nevmas_rag(től,e,e,ü,[ABL])
nevmas_rag(hozz,á,o,u,[ALL],a)
nevmas_rag(vel,e,e,ü,[INSTR])
nevmas_rag(vél,e,e,ü,[INSTR]+[SUBS])
nevmas_rag(ért,e,e,ü,[CAUS/FIN])

# helyhatározói névutókból képzett névmások

nevmas_uto(alatt,a,o,u)
nevmas_uto(al,á,o,u,á,a)
nevmas_uto(alól,a,o,u)
nevmas_uto(felett,e,e,ü)
nevmas_uto(fölött,e,e,ü)
nevmas_uto(fel,é,e,ü,é,e)
nevmas_uto(föl,é,e,ü,é,e)
nevmas_uto(felől,e,e,ü)
nevmas_uto(előtt,e,e,ü)
nevmas_uto(el,é,e,ü,é,e)
nevmas_uto(elől,e,e,ü)
nevmas_uto(mögött,e,e,ü)
nevmas_uto(mög,é,e,ü,é,e)
nevmas_uto(mögül,e,e,ü)
nevmas_uto(mellett,e,e,ü)
nevmas_uto(mell,é,e,ü,é,e)
nevmas_uto(mellől,e,e,ü)
nevmas_uto(kívül,e,e,ü)
nevmas_uto(között,e,e,ü)
nevmas_uto(közt,e,e,ü)
nevmas_uto(köz,é,e,ü,é,e)
nevmas_uto(közül,e,e,ü)
nevmas_uto(kör,é,e,ü,é,e)

# körülöttem -> körül névutó körülött helyett

körülöttem	körülötte[noun_pron]+[POSTP(körül)]+[SG_1]
énkörülöttem	körülötte[noun_pron]+[POSTP(körül)]+[SG_1]+[EMPH]
körülötted	körülötte[noun_pron]+[POSTP(körül)]+[SG_2]
tekörülötted	körülötte[noun_pron]+[POSTP(körül)]+[SG_2]+[EMPH]
körülötte	[noun_pron]+[POSTP(körül)]+[SG_3]
őkörülötte	körülötte[noun_pron]+[POSTP(körül)]+[SG_3]+[EMPH]
körülöttünk	körülötte[noun_pron]+[POSTP(körül)]+[PL_1]
mikörülöttünk	körülötte[noun_pron]+[POSTP(körül)]+[PL_1]+[EMPH]
körülöttetek	körülötte[noun_pron]+[POSTP(körül)]+[PL_2]
tikörülöttetek	körülötte[noun_pron]+[POSTP(körül)]+[PL_2]+[EMPH]
körülöttük	körülötte[noun_pron]+[POSTP(körül)]+[PL_3]
őkörülöttük	körülötte[noun_pron]+[POSTP(körül)]+[PL_3]+[EMPH]


# egyéb határozói névutókból képzett névmások

nevmas_uto(után,a,o,u)
nevmas_uto(helyett,e,e,ü)
nevmas_uto(nélkül,e,e,ü)
nevmas_uto(miatt,a,o,u)
nevmas_uto(által,a,o,u)
nevmas_uto(szerint,e,e,ü)
nevmas_uto(ellen,e,e,ü)
nevmas_uto(iránt,a,o,u)

# egy-két továbbragozott forma

bennünket	én[noun_pron]+[PL_1]+[ACC]
mibennünket	én[noun_pron]+[PL_1]+[ACC]+[EMPH]
benneteket	én[noun_pron]+[PL_2]+[ACC]
tibenneteket	én[noun_pron]+[PL_2]+[ACC]+[EMPH]

# nevmas_rag(nál,a,o,u,,nál) nálanál miatt -->
nálamnál	én[noun_pron]+[SG_1]+[ADE]
énnálamnál	én[noun_pron]+[SG_1]+[ADE]+[EMPH]
náladnál	én[noun_pron]+[SG_2]+[ADE]
tenáladnál	én[noun_pron]+[SG_2]+[ADE]+[EMPH]
nálánál	én[noun_pron]+[SG_3]+[ADE]
őnálánál	én[noun_pron]+[SG_3]+[ADE]+[EMPH]
nálunknál	én[noun_pron]+[PL_1]+[ADE]
minálunknál	én[noun_pron]+[PL_1]+[ADE]+[EMPH]
nálatoknál	én[noun_pron]+[PL_2]+[ADE]
tinálatoknál	én[noun_pron]+[PL_2]+[ADE]+[EMPH]
náluknál	én[noun_pron]+[PL_3]+[ADE]
őnáluknál	én[noun_pron]+[PL_3]+[ADE]+[EMPH]

ellenemre	ellenére[noun_pron]+[SG_1]+[POSTP(ellenére)]
ellenedre	ellenére[noun_pron]+[SG_2]+[POSTP(ellenére)]
ellenére	[noun_pron]+[SG_3]+[POSTP(ellenére)]
ellenünkre	ellenére[noun_pron]+[PL_1]+[POSTP(ellenére)]
ellenetekre	ellenére[noun_pron]+[PL_2]+[POSTP(ellenére)]
ellenükre	ellenére[noun_pron]+[PL_3]+[POSTP(ellenére)]

ellenében	ellenére[noun_pron]+[SG_3]+[POSTP(ellenében)]


# régies v. tájnyelvi jellegű változatok

nevmas_uto(el,é,e,ü,é,e,be,+[SUBS])
nevmas_uto(eléb,e,e,ü,e,e,,+[SUBS])
nevmas_uto(elib,é,e,ü,e,e,,+[SUBS])
nevmas_uto(elejb,é,e,ü,é,e,,+[SUBS])
nevmas_uto(elejb,e,e,ü,e,e,,+[SUBS])
nevmas_rag(hozz,á,o,u,[ALL]+[SUBS],a,ig)
nevmas_rag(érett,e,e,ü,[CAUS/FIN]+[SUBS])
nevmas_uto(fölib,é,e,ü,e,e,,+[SUBS])
nevmas_uto(föléb,e,e,ü,e,e,,+[SUBS])
nevmas_uto(körül,e,e,ü,,,,+[SUBS])
nevmas_uto(közib,é,e,ü,e,e,,+[SUBS])

közibünk	közibe[noun_pron]+[PL_1]+[POSTP(közé)]+[SUBS]
közibük	közibe[noun_pron]+[PL_3]+[POSTP(közé)]+[SUBS]

nékem	néki[noun_pron]+[SG_1]+[DAT]+[SUBS]
néked	néki[noun_pron]+[SG_1]+[DAT]+[SUBS]
néki	[noun_pron]+[SG_1]+[DAT]+[SUBS]
nékünk	néki[noun_pron]+[SG_1]+[DAT]+[SUBS]
néktek	néki[noun_pron]+[SG_1]+[DAT]+[SUBS]
nékik	néki[noun_pron]+[SG_1]+[DAT]+[SUBS]
énnékem	néki[noun_pron]+[SG_1]+[DAT]+[EMPH]+[SUBS]
tenéked	néki[noun_pron]+[SG_1]+[DAT]+[EMPH]+[SUBS]
őnéki	néki[noun_pron]+[SG_1]+[DAT]+[EMPH]+[SUBS]
minékünk	néki[noun_pron]+[SG_1]+[DAT]+[EMPH]+[SUBS]
tinéktek	néki[noun_pron]+[SG_1]+[DAT]+[EMPH]+[SUBS]
őnékik	néki[noun_pron]+[SG_1]+[DAT]+[EMPH]+[SUBS]

nevmas_uto(körött,e,e,ü,e,,,+[SUBS])

