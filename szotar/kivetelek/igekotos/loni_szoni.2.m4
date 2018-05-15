#   1    2 3 4 5 6 7 8
#   alap ő,ö,ö,ü,é,e,e
#	     ú,u,o,u,á,a,o

# szőnők, lőnők stb. régies, nagyon ritka (nem kezelve)

define(oe_rag,

############# $1$2 #################

[vrb]$1$2v$7	$1$2$9[vrb]+[vA_PART_adv]
[vrb]$1$2v$6n	$1$2$9[vrb]+[vÁn_PART_adv]

[vrb]$1$3v$4k	$1$2$9[vrb]+[PRES_INDIC_INDEF_SG_1]
[vrb]$1$3v$4m	$1$2$9[vrb]+[PRES_INDIC_DEF_SG_1]
[vrb]$1$2l$7k	$1$2$9[vrb]+[PRES_INDIC_SG_1_OBJ_2]
[vrb]$1$2sz	$1$2$9[vrb]+[PRES_INDIC_INDEF_SG_2]
[vrb]$1$3v$4d	$1$2$9[vrb]+[PRES_INDIC_DEF_SG_2]
[vrb]$1$2	$1$2$9[vrb]+[PRES_INDIC_INDEF_SG_3]
[vrb]$1$3v$5nk	$1$2$9[vrb]+[PRES_INDIC_INDEF_PL_1]
[vrb]$1$2j$5k	$1$2$9[vrb]+[PRES_INDIC_DEF_PL_1]
[vrb]$1$2t$4k	$1$2$9[vrb]+[PRES_INDIC_INDEF_PL_2]
[vrb]$1$2n$7k	$1$2$9[vrb]+[PRES_INDIC_DEF_PL_3]

[vrb]$1$2tt$7m	$1$2$9[vrb]+[PAST_INDIC_INDEF_SG_1]
[vrb]$1$2tt$7m	$1$2$9[vrb]+[PAST_INDIC_DEF_SG_1]
[vrb]$1$2tt$7l$7k	$1$2$9[vrb]+[PAST_INDIC_SG_1_OBJ_2]
[vrb]$1$2tt$6l	$1$2$9[vrb]+[PAST_INDIC_INDEF_SG_2]
[vrb]$1$2tt$7d	$1$2$9[vrb]+[PAST_INDIC_DEF_SG_2]
[vrb]$1$2tt	$1$2$9[vrb]+[PAST_INDIC_INDEF_SG_3]
[vrb]$1$2tt$7	$1$2$9[vrb]+[PAST_INDIC_DEF_SG_3]
[vrb]$1$2tt$5nk	$1$2$9[vrb]+[PAST_INDIC_INDEF_PL_1]
[vrb]$1$2tt$5k	$1$2$9[vrb]+[PAST_INDIC_DEF_PL_1]
[vrb]$1$2tt$7t$8k	$1$2$9[vrb]+[PAST_INDIC_INDEF_PL_2]
[vrb]$1$2tt$6t$8k	$1$2$9[vrb]+[PAST_INDIC_DEF_PL_2]
[vrb]$1$2tt$7k	$1$2$9[vrb]+[PAST_INDIC_INDEF_PL_3]
[vrb]$1$2tt$6k	$1$2$9[vrb]+[PAST_INDIC_DEF_PL_3]

[vrb]$1$2nék	$1$2$9[vrb]+[PRES_COND_INDEF_SG_1]
[vrb]$1$2n$6m	$1$2$9[vrb]+[PRES_COND_DEF_SG_1]
[vrb]$1$2n$6l$7k	$1$2$9[vrb]+[PRES_COND_SG_1_OBJ_2]
[vrb]$1$2n$6l	$1$2$9[vrb]+[PRES_COND_INDEF_SG_2]
[vrb]$1$2n$6d	$1$2$9[vrb]+[PRES_COND_DEF_SG_2]
[vrb]$1$2n$7	$1$2$9[vrb]+[PRES_COND_INDEF_SG_3]
[vrb]$1$2n$6	$1$2$9[vrb]+[PRES_COND_DEF_SG_3]
[vrb]$1$2n$6nk	$1$2$9[vrb]+[PRES_COND_INDEF_PL_1]
[vrb]$1$2n$6nk	$1$2$9[vrb]+[PRES_COND_DEF_PL_1]
[vrb]$1$2n$6t$8k	$1$2$9[vrb]+[PRES_COND_INDEF_PL_2]
[vrb]$1$2n$6t$8k	$1$2$9[vrb]+[PRES_COND_DEF_PL_2]
[vrb]$1$2n$6n$7k	$1$2$9[vrb]+[PRES_COND_INDEF_PL_3]
[vrb]$1$2n$6k	$1$2$9[vrb]+[PRES_COND_DEF_PL_3]

[vrb]$1$2j$7k	$1$2$9[vrb]+[SUBJ/IMPER_INDEF_SG_1]
[vrb]$1$2j$7m	$1$2$9[vrb]+[SUBJ/IMPER_DEF_SG_1]
[vrb]$1$2j$7l$7k	$1$2$9[vrb]+[SUBJ/IMPER_SG_1_OBJ_2]
[vrb]$1$2j	$1$2$9[vrb]+[SUBJ/IMPER_INDEF_SG_2]
[vrb]$1$2dd	$1$2$9[vrb]+[SUBJ/IMPER_DEF_SG_2]
[vrb]$1$2j$6l	$1$2$9[vrb]+[SUBJ/IMPER_INDEF_SG_2]
[vrb]$1$2j$7d	$1$2$9[vrb]+[SUBJ/IMPER_DEF_SG_2]
[vrb]$1$2j$4n	$1$2$9[vrb]+[SUBJ/IMPER_INDEF_SG_3]
[vrb]$1$2j$7	$1$2$9[vrb]+[SUBJ/IMPER_DEF_SG_3]
[vrb]$1$2j$5nk	$1$2$9[vrb]+[SUBJ/IMPER_INDEF_PL_1]
[vrb]$1$2j$5k	$1$2$9[vrb]+[SUBJ/IMPER_DEF_PL_1]
[vrb]$1$2j$7t$8k	$1$2$9[vrb]+[SUBJ/IMPER_INDEF_PL_2]
[vrb]$1$2j$6t$8k	$1$2$9[vrb]+[SUBJ/IMPER_DEF_PL_2]
[vrb]$1$2j$7n$7k	$1$2$9[vrb]+[SUBJ/IMPER_INDEF_SG_3]
[vrb]$1$2j$6k	$1$2$9[vrb]+[SUBJ/IMPER_DEF_SG_3]

[vrb]$1$2ni	$1$2$9[vrb]+[ni_INFINITIVE_inf]
[vrb]$1$2n$4m	$1$2$9[vrb]+[INF_SG_1]
[vrb]$1$2n$4d	$1$2$9[vrb]+[INF_SG_2]
[vrb]$1$2ni$7	$1$2$9[vrb]+[INF_SG_3]
[vrb]$1$2n$5nk	$1$2$9[vrb]+[INF_PL_1]
[vrb]$1$2n$4t$4k	$1$2$9[vrb]+[INF_PL_2]
[vrb]$1$2ni$5k	$1$2$9[vrb]+[INF_PL_3]
[vrb]$1$2ni$4k/&	$1$2$9[vrb]+[INF_PL_3]
)

oe_rag(f,ő,ö,ö,ü,é,e,e)
[vrb]fövi	fő[vrb]+[PRES_INDIC_DEF_SG_3]
[vrb]fövitek	fő[vrb]+[PRES_INDIC_DEF_PL_2]
[vrb]fövik	fő[vrb]+[PRES_INDIC_DEF_PL_3]

oe_rag(f,ú,ú,o,u,á,a,o,j)
oe_rag(h,í,í,o,u,á,a,o,v)
oe_rag(l,ő,ö,ö,ü,é,e,e)
[vrb]lövi	lő[vrb]+[PRES_INDIC_DEF_SG_3]
[vrb]lövitek	lő[vrb]+[PRES_INDIC_DEF_PL_2]
[vrb]lövik	lő[vrb]+[PRES_INDIC_DEF_PL_3]

oe_rag(n,ő,ö,ö,ü,é,e,e)
[vrb]növi	nő[vrb]+[PRES_INDIC_DEF_SG_3]
[vrb]növitek	nő[vrb]+[PRES_INDIC_DEF_PL_2]
[vrb]növik	nő[vrb]+[PRES_INDIC_DEF_PL_3]

# oe_rag(ny,í,í,o,u,á,a,o,lik)

[vrb]nyísz	nyílik[vrb]+[PRES_INDIC_INDEF_SG_2]
[vrb]nyí	nyílik[vrb]+[PRES_INDIC_DEF_SG_3]
[vrb]nyítok	nyílik[vrb]+[PRES_INDIC_DEF_PL_2]
[vrb]nyínak	nyílik[vrb]+[PRES_INDIC_DEF_PL_3]

[vrb]nyíttam	nyílik[vrb]+[PAST_INDIC_INDEF_SG_1]
[vrb]nyíttál	nyílik[vrb]+[PAST_INDIC_INDEF_SG_2]
[vrb]nyítt	nyílik[vrb]+[PAST_INDIC_INDEF_SG_3]
[vrb]nyíttunk	nyílik[vrb]+[PAST_INDIC_INDEF_PL_1]
[vrb]nyíttatok	nyílik[vrb]+[PAST_INDIC_INDEF_PL_2]
[vrb]nyíttak	nyílik[vrb]+[PAST_INDIC_INDEF_PL_3]

[vrb]nyínák	nyílik[vrb]+[PRES_COND_INDEF_SG_1]
[vrb]nyínál	nyílik[vrb]+[PRES_COND_INDEF_SG_2]
[vrb]nyína	nyílik[vrb]+[PRES_COND_INDEF_SG_3]
[vrb]nyínánk	nyílik[vrb]+[PRES_COND_INDEF_PL_1]
[vrb]nyínátok	nyílik[vrb]+[PRES_COND_INDEF_PL_2]
[vrb]nyínának	nyílik[vrb]+[PRES_COND_INDEF_PL_3]

[vrb]nyíjak	nyílik[vrb]+[SUBJ/IMPER_INDEF_SG_1]
[vrb]nyíj	nyílik[vrb]+[SUBJ/IMPER_INDEF_SG_2]
[vrb]nyíjál	nyílik[vrb]+[SUBJ/IMPER_INDEF_SG_2]
[vrb]nyíjon	nyílik[vrb]+[SUBJ/IMPER_INDEF_SG_3]
[vrb]nyíjunk	nyílik[vrb]+[SUBJ/IMPER_INDEF_PL_1]
[vrb]nyíjatok	nyílik[vrb]+[SUBJ/IMPER_INDEF_PL_2]
[vrb]nyíjanak	nyílik[vrb]+[SUBJ/IMPER_INDEF_PL_3]

[vrb]nyíni	nyílik[vrb]+[ni_INFINITIVE_inf]
[vrb]nyínom	nyílik[vrb]+[INF_SG_1]
[vrb]nyínod	nyílik[vrb]+[INF_SG_2]
[vrb]nyínia	nyílik[vrb]+[INF_SG_3]
[vrb]nyínunk	nyílik[vrb]+[INF_PL_1]
[vrb]nyínotok	nyílik[vrb]+[INF_PL_2]
[vrb]nyíniuk	nyílik[vrb]+[INF_PL_3]
[vrb]nyíniok/&	nyílik[vrb]+[INF_PL_3]

oe_rag(ny,ű,ü,ö,ü,é,e,e)
[vrb]nyüvi	nyű[vrb]+[PRES_INDIC_DEF_SG_3]
[vrb]nyüvitek	nyű[vrb]+[PRES_INDIC_DEF_PL_2]
[vrb]nyüvik	nyű[vrb]+[PRES_INDIC_DEF_PL_3]


oe_rag(r,í,í,o,u,á,a,o)
oe_rag(r,ó,o,o,u,á,a,o)
oe_rag(sz,í,í,o,u,á,a,o,v)
oe_rag(sz,ő,ö,ö,ü,é,e,e)

[vrb]szövi	sző[vrb]+[PRES_INDIC_INDEF_SG_3]
[vrb]szövitek	sző[vrb]+[PRES_INDIC_DEF_PL_2]
[vrb]szövik	sző[vrb]+[PRES_INDIC_DEF_PL_3]
