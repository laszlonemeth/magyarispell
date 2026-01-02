import sys, hunspell, re
h=hunspell.HunSpell('/home/laci/magyarispell/hu_HU_u8_gen_alias.dic', '/home/laci/magyarispell/hu_HU_u8_gen_alias.aff')

# disambiguation for single word forms
EXCEPTIONS = {
    'alapok': 'a=la-pok', # not alap|ok
    'általad': 'ál-ta-lad', # not által|ad
    'aranyért': 'a=ra-nyért', # not arany|ért
    'elég': 'e=lég', # not el|ég, FIXME
    'életévé': 'é=le-té-vé', # not élet|évé
    'elöl': 'e=löl', # not el|öl, FIXME
    'félék': 'fé-lék', # not fél|ék
    'felette': 'fe-let-te', # not fel|ette, FIXME
    'felül': 'fe-lül', # not fel|ül, FIXME
    'fölül': 'fö-lül', # not föl|ül, FIXME
    'kiesem': 'ki|e=sem', # not ki-e-sem
    'kocsisorral': 'ko-csi|sor-ral', # not kocsis|orr
    'legelőre': 'leg|e=lő-re', # not legelő, FIXME
    'megint': 'me=gint', # not meg|int, FIXME
    'mindennek': 'min-den-nek', # not mind|ennek, FIXME
    'mindennél': 'min-den-nél', # not mind|ennél, FIXME
    'népének': 'né-pé-nek', # not nép|ének, FIXME
    'tapasszá': 'ta-pasz-szá', # not tapas-szá
    'tapasszal': 'ta-pasz-szal', # not tapas-szal
    'vízért': 'ví-zért' # not víz|ér
}

# disambiguation of all affixed forms
EXCEPTIONS_MORPH = {
    'alapok': 'st:alapok .*hy:4', # alapok, not alap|ok
    'autósp': 'st:autós .*st:por(tok)? ', # autó|sport, not autós|port or autós||por|tok
    'bankal': 'st:banka .*st:lapít ', # bank|alapítás, not banka|lapítás
    'csőrep': 'st:csőr .*st:eped ', # cső|repedés, not csőr|epedés
    'fajtan': 'st:faj .*st:tanév ', # fajta|név, not faj||tan|év
    'falapá': 'st:fal .*st:apát ', # fa|lapát, not fal|apát
    'farács': 'st:far .*st:ács ',  # fa|rács, not far|ács
    'farácc': 'st:far .*st:ács ', # fa|ráccsal, not far|áccsal
    'farész': 'st:far .*st:ész ', # fa|rész, not far|ész
    'faréss': 'st:far .*st:ész ', # fa|résszel, not far|ésszel
    'fasz': 'st:fasz ', # fa|szállítás, not fasz|állítás
    'félelm': 'pa:fél .*st:elme .*is:i_PLACE/TIME_adj', # félelmei, not fél|elmei
    'felett': 'sp:fel  *st:eszik .*is:PAST_INDIC', # felette, not fel|ette
    'felüli': 'sp:fel  *st:ül ', # felül, not fel|ül
    'fiókal': 'st:fióka .*st:lapít ', # fiók|alapítás, not fióka|lapítás
    'fölüli': 'sp:föl  *st:ül ', # fölül, not föl|ül
    'gondfe': 'sp:fel .*st:ejt', # gond|felejtő, not gond|fel|ejtő
    'gyökér': 'st:érrendszer ', # gyökér||rend|szer, not gyök||ér||rend|szer
    'hatalm': 'sp:hat .*st:alma', # hatalmai, not hat|almai
    'halálh': 'st:hal .*st:álhír ', # halál|hír, not hal|ál|hír
    'hallev': 'st:hall .*st:evet ', # hal|levet, not hall|evet
    'hangal': 'st:hanga .*st:lap ', # hang|alapú, not hanga|lapú
    'hitelv': 'st:iszony ', # hitel|viszony, not hit|elv|iszony
    'hódara': 'st:hód .*st:ara ', # hó|dara, not hód|ara
    'hódará': 'st:hód .*st:ara ', # hó|dara, not hód|ara
    'karizm': 'st:karizom .*hy:3 *is:POSS_SG_3', # karizma, but kar|izmai
    'kiabál': 'sp:ki  *st:abál ', # kiabál, not ki|abál
    'kőrács': 'st:kőr .*st:ács ', # kő|rács, not kőr|ács
    'különü': 'sp:külön *st:ül ', # különül, not külön|ül
    'legelő': 'st:legel .*is:bb_COMPARATIVE_adj', # leg|előbb, not le-ge-lőbb
    'oktató': 'st:ok .*st:tat ', # oktató|évét, not ok|tat|ó|évét
    'nyelvt': 'st:nyelvtan .*st:ár(ok|u)? ', # nyelv|tanár(ok), not nyelv|tan|ár or nyelv|tan|árok
    'pártal': 'st:párta .*st:lap(ít)? ', # párt|alapító, not párta|lapító
    'sajtób': 'st:sajt .*st:óbirodalom ', # sajtó|birodalom, not sajt||ó|birodalom
    'szénac': 'st:széna .*st:cél ', # szén|acél, not széna|cél
    'szénat': 'st:széna .*st:Tom ', # szén|atomos, not széna|tomos
    'szerel': 'st:elő(csarnok|lap) ', # szerelő|csarnok, not szer|elő|csarnok
    'sziget': 'st:előanyag ', # szigetelő|anyag, not sziget|elő|anyag
    'vázson': 'st:Sony ' # vá-zso-nyi, not váz|sony
}

# add title case and capitalized exceptions
E1 = {i.upper(): EXCEPTIONS[i] for i in EXCEPTIONS}
E2 = {i.title(): EXCEPTIONS[i] for i in EXCEPTIONS}
EXCEPTIONS = {**EXCEPTIONS, **E1, **E2}
E1 = {i.upper(): EXCEPTIONS_MORPH[i] for i in EXCEPTIONS_MORPH}
E2 = {i.title(): EXCEPTIONS_MORPH[i] for i in EXCEPTIONS_MORPH}
EXCEPTIONS_MORPH = {**EXCEPTIONS_MORPH, **E1, **E2}

WORDS = """# V-CV: vowel - consonant + vowel
ad          ad
adu         a=du
adakozás    a=da-ko-zás
Adrienn     Ad-ri-enn
Chișinău    Chi-și-nă=u
Dvořák      Dvo-řák
# V-V
fiaiéi      fi-a-i-é=i
Citroën     Cit-ro-ën
# C+-CV
altruizmus  alt-ru-iz-mus
Škoda       Ško-da
# V-CV: cs, dz, dzs, gy, ly, ny, ty, sz, zs
acsa        a=csa
edzek       e=dzek
büdzsé      bü-dzsé
magyar      ma-gyar
selyem      se-lyem
hanyag      ha-nyag
fátyol      fá-tyol
maszat      ma-szat
mazsola     ma-zso-la
# C+-CV: cs, dz, dzs, gy, ly, ny, ty, sz, zs
borscsot    bors-csot
téeszcsé    té-esz-csé
brindza     brin-dza
lándzsa     lán-dzsa
hangya      han-gya
uzsgyi      uzs-gyi
fáklya      fák-lya
csoroszlya  cso-rosz-lya
ernyő       er-nyő
tarisznya   ta-risz-nya
alszik      al-szik
hányszor    hány-szor
gyertya     gyer-tya
keresztyén ke-resz-tyén
Erzsébet    Er-zsé-bet
# ccs, ddz, ddzs, ggy, lly, nny, tty, ssz, zzs
öccse       öc{s-}cse
eddze       ed{z-}dze
briddzsel   brid{zs-}dzsel
buggyan     bug{y-}gyan
gallyat     gal{y-}lyat
könnyen     kön{y-}nyen
lottyad     lot{y-}tyad
vesszen     ves{z-}szen
varázzsal   va-ráz{s-}zsal
# ch, ck, cz, sh, th, tz
Damjanichot Dam-ja-ni-chot
Ráczot      Rá-czot
# terminal consonant
hertz       hertz
hertzet     her-tzet
Móricz      Mó-ricz
Móriczot    Mó-ri-czot
Németh      Né-meth
Némethet    Né-me-thet
Pulitzer    Pu-li-tzer
Szüts       Szüts
Szütsöt     Szü-tsöt
rock        rock
rockot      ro-ckot
squash      squash
squashé     squa-shé
squashsal   squash-sal
squasht     squasht
tarack      ta-rack
tarackot    ta-rac-kot
# -dy, czy ...
Vekerdy     Ve-ker-dy
Verbőczy    Ver-bő-czy
# c|s, d|z, d|zs, g|y, l|ly, n|ny, t|ty, s|sz, z|zs
pácsó       pác|só
smaragdzöld sma-ragd|zöld
hódzsír     hód||zsír
nyílászáró  nyí-lás||zá-ró
őzsuta      őz|su-ta
vízszint    víz|szint
# c|cs, d|dz, d|dzs, g|gy, l|ly, n|ny, t|ty, s|sz, z|zs
tánccsoport tánc||cso-port
joggyakorlat    jog||gya-kor-lat
ruggyanta  rug|gyan-ta
füllyukasztás   fül||lyu-kasz-tás
tannyelvű   tan||nyel-vű
tudásszint  tu-dás||szint
paraszttyúk pa-raszt||tyúk
kolbászzsír kol-bász||zsír
# -V|
bioélelmiszer   bi=o||é=lel-mi|szer
# ch, sch, th
achát       a=chát
archívum    ar-chí-vum
athéni      a=thé-ni
drachma     drach-ma
Porsche     Por-sche
Ranschburg  Ransch-burg
# c-hoz
akáchoz     a=kác-hoz
hecchez     hecc-hez
pöcchöz     pöcc-höz
# prefix
agyonnyom   a=gyon|nyom
bekrepált   be|kre-pált
féllyukas   fél|lyu-kas
legazsúrságosabb    leg||a=zsúr-sá-go-sabb
legdicsőségesebb    leg||di-cső-sé-ge-sebb
meggyón     meg|gyón
nyolccsavaros   nyolc|csa-va-ros
# compound
igénybevehetőségét  i=gény||be|ve-he-tő-sé-gét # FIXME: igénybe||vehetőségét
őszsiráf    ős||zsi-ráf
pácsavak    pác||sa-vak
pácsó       pác|só
plüsszebra  plüss||zeb-ra
parfümellenes   par-füm||el-le-nes
parfümellenesen   par-füm||el-le-ne-sen
parfümellenesebben   par-füm||el-le-ne-seb-ben
parfümellenesebbeket   par-füm||el-le-ne-seb-be-ket
parfümellenesebbiket   par-füm||el-le-ne-seb-bi-ket
# hyphen
rossz-szívű rossz--szí-vű
vakáció-műsor   va-ká-ci=ó--mű|sor
habostorta-     ha-bos|tor-ta--
habostorta-recept     ha-bos|tor-ta--re-cept
habostorta      ha-bos|tor-ta # *habostorta! = mozgószabály
# dictionary hyphen
egyes-egyedül   e=gyes--e=gye-dül
Erie-tóról  E=rie--tó-ról
Montaigne-ről   Mon-taigne--ről
szén-dioxid szén--di|o=xid
szén-monoxid    szén--mon|o=xid
televízió-műsor te-le-ví-zi=ó--mű|sor
tetrakloro-aurát    tet-ra|klo-ro--a=u-rát
# -e$
vagy-e      vagy--e
VAGY-E      VAGY--E
Vagy-e      Vagy--e
# hy:number
ablakemelő  ab-lak|e=me-lő
adatfeldolgozás a=dat||fel|dol-go-zás
bolognai    bo-lo-gna=i
honvédelem  hon|vé-de-lem # not hon|véd|e=lem
rendőrfőkapitány    rend|őr||fő|ka-pi-tány
#Nagy-Magyarország   Nagy--magyar|ország # FIXME Nagy--Magyar|ország
# hy:0
fair        fair
Freud       Freud
freudi      freu-di
blues       blues
bluesos     blue-sos
bluesosok   blue-so-sok
eleste      el|es-te
letelte     le|tel-te
legmeggyőzőbb   leg||meg|győ-zőbb
legszembenállóbb  leg||szem-ben|ál-lóbb
legszembenállóbbat  leg||szem-ben|ál-lób-bat
elhasználtság   el|hasz-nált-ság
Poe         Poe
Poe-val     Poe--val
legalja     leg||al-ja
legalját    leg||al-ját
fairek        fai-rek
Holmes      Holmes
Holmeson    Holme-son
Twain       Twain
Twainen     Twai-nen
# hy:pattern
Ady         A=dy
Adynak      A=dy-nak
Adyé        A=dy=é
Adyét       A=dy-ét
Adyt        A=dyt
alapigazságát a=lap|i=gaz-sá-gát
biológia    bi=o-ló-gi=a
biológiát   bi=o-ló-gi-át
blueszene   blues|ze-ne
blueszenét  blues|ze-nét
bőrfelületet    bőr||fe-lü-le-tet
félelmeit   fé-lel-me-it
határátkelőhely ha-tár||át|ke-lő||hely
kerékpárút  ke-rék|pár||út
kerékpárutat  ke-rék|pár||u=tat
lasagne     la-sa-gne
lasagnét    la-sa-gnét
népegészségügyi nép||e=gész-ség|ü=gyi
offline     off-line
ruggyanta   rug|gyan-ta
ruggyantát  rug|gyan-tát
penny       pen-ny
pennyt      pen-nyt
pennyét     pen-ny-ét
pennyről    pen-ny-ről
pennyvel    pen-ny-vel
pennymnek   pen-nym-nek
#pennynként pen-nyn-ként #FIXME
félpennys   fél|pen-nys
félpennysről   fél|pen-nys-ről
szennyvízelvezetési    szenny||víz||el|ve-ze-té-si
Nietzsche   Nietz-sche
Nietzschét  Nietz-schét
Semmelweis  Sem-mel-weis
Semmelweisen  Sem-mel-wei-sen
vízsugarainak   víz|su-ga-ra-i-nak
złoty       zło-ty
# -nyi
kamionnyi   ka-mi-on-nyi
kamionnyit  ka-mi-on-nyit
kamionnyinak   ka-mi-on-nyi-nak
szekrénnyi  szek-rén{y-}nyi
kisregénnyi kis|re-gén{y-}nyi
# -ság/-ség
elhasználtság   el|hasz-nált-ság
különcség   kü-lönc-ség
többértelműség  több|ér-tel-mű-ség
úzság   úz-ság
# -beli, -szerte, -szerű
felsorolásszerűen   fel|so-ro-lás|sze-rű-en
rendeltetésszerű    ren-del-te-tés|sze-rű
regénybeli  re-gény|be-li
# -szerte
városszerte vá-ros|szer-te
# -mentes
allergiamentes  al-ler-gi=a|men-tes
# s + -szal/-szel, s + -szá/-szé
opusszal    o=pus-szal
opusszá     o=pus-szá
toplesszel  top-les-szel # stem: topless!
Vénusszal   Vé-nus{z-}szal
Vénusszá    Vé-nus{z-}szá
Windowszal  Win-dows-zal
Windowszá   Win-dows-zá
# hy:pattern=
Thaiföld    Thai|föld
Montaigne   Mon-taigne
# hy:paint|ball=
paintball   paint-ball
paintballé  paint-bal-lé
paintballos paint-bal-los
paintballt  paint-ballt
# missing sp:leg
leggyönyörűbb   leg||gyö-nyö-rűbb
legesleggyönyörűbb   le-ges|leg||gyö-nyö-rűbb
legeszményibb   leg||esz-mé-nyibb
legesleghosszabban  le-ges|leg||hos{z-}szab-ban
# other
kétszázezer két|száz|e=zer
kétszázezret két|száz||ez-ret
ezeregyszázötvenegy   e=zer|egy|száz|öt-ven|egy
ezeregyszázötvenegyet   e=zer|egy|száz|öt-ven|e=gyet
kisközség   kis|köz-ség
felüli      fe-lü-li
hároméves      há-rom|é=ves
százezer    száz|e=zer
tanárképző  ta-nár||kép-ző
egyéniség   e=gyé-ni-ség
egyénisége  e=gyé-ni-sé-ge
kiegyensúlyozott    ki|e=gyen|sú-lyo-zott
# magyarispell 1.9.1
alapok      a=la-pok #FIXME
alapokra    a=la-pok-ra
alapokot    a=lap|o=kot
állóképei   ál-ló||ké-pe=i
Ampère      Am-père
Anjou       An-jou
Anjouk      An-jouk
Anjoué      An-jou=é
Anjouét     An-jou-ét
Anjouval    An-jou-val
Apáthi      A=pá-thi
Apáthié     A=pá-thi=é
Apáthiét    A=pá-thi-ét
Apáthit     A=pá-thit
autósport   a=u-tó||sport # not autós|port
autósportok a=u-tó||spor-tok # not autós|por|tok
Baudelaire  Baude-laire
beleromlott be-le|rom-lott
bombayi     bom-ba-yi
bombayt     bom-bayt
bonszai     bon-szai
bonszaié    bon-szai=é
bonszaijal  bon-szai-jal
bonszait    bon-szait
Bornemissza Bor-nem-is{z-}sza
boyé        bo-yé
boyjal      boy-jal
boyok       bo-yok
boyt        boyt
Bródy       Bró-dy
Bródyé      Bró-dy=é
Bródyét     Bró-dy-ét
Bródyt      Bró-dyt
bródys      bró-dys
bródysé     bró-dy-sé
bródyst     bró-dyst
byte        byte
capoeira    ca-po-ei-ra
capoeirát   ca-po-ei-rát
capriccio   cap-ric-cio
capricciót  cap-ric-ciót
capriccióé  cap-ric-ció=é
capriccióét cap-ric-ció-ét
capriccióval    cap-ric-ció-val
cumisüveg   cu-mis|ü=veg
Csergheő    Cser-gheő
Csergheőé   Cser-gheő=é
Csergheőét  Cser-gheő-ét
Csergheőével    Cser-gheő-é-vel
Csergheővel Cser-gheő-vel
csoportelső cso-port|el-ső
dezorganizáció  dez-or-ga-ni-zá-ci=ó
dinoszaurusz    di-no-sza=u-rusz
dinoszauruszok    di-no-sza=u-ru-szok
dixieland   di-xie-land
dixielandet   di-xie-lan-det
dizájnerei  di-záj-ne-re=i
ecstasy     ecs-ta-sy
e-learning  e--lear-ning
e-learningé e--lear-nin-gé
e-learninget    e--lear-nin-get
e-learningről   e--lear-ning-ről
elhallik    el|hal-lik
előadásmód  e=lő|a=dás||mód
emlékest    em-lék|est
Esterházyak Es-ter-há-zy-ak
ethosz      e=thosz
ethosszal   e=thos{z-}szal
falazúr     fa||la-zúr
fényképészmester    fény|ké-pész||mes-ter
Firefox     Fire-fox
Firefoxot   Fire-fo-xot
főgépész    fő|gé-pész
főtanácsadója   fő||ta-nács|a=dó-ja
gonorrhoea  go-nor-rhoe=a
gonorrhoeát go-nor-rhoe-át
hacker      ha-cker
haiku       ha=i-ku
halálút     ha-lál|út
halálutak   ha-lál|u=tak
hallevet    hal|le-vet
hangszerész hang|sze-rész
hallatára   hal-la-tá-ra
határút     ha-tár|út
húszezren   húsz|ez-ren
improduktív im-pro-duk-tív
inadekvát   in-a=dek-vát
ingatlanalapok  in-gat-lan||a=la-pok
Jászszentandrás Jász||szent|and-rás
jogdíjára   jog|dí-já-ra
joule       joule
ketchup     ke-tchup
kisunokám   kis|u=no-kám
Lesotho     Le-so-tho
Lesothóban  Le-so-thó-ban
Lesothóé    Le-so-thó=é
Lesothóét   Le-so-thó-ét
Lesothót    Le-so-thót
leukocita   le=u-ko-ci-ta
liechtensteini   liech-tens-tei-ni
lime        lime
Marseille   Mar-seille
Martonffy   Mar-ton-ffy
Martonffyé  Mar-ton-ffy=é
Martonffyék Mar-ton-ffy-ék
Martonffyt  Mar-ton-ffyt
Martonffyval    Mar-ton-ffy-val
megabyte    me-ga|byte
# megfelelőségértékelés   meg|fe-le-lő-ség||ér-té-ke-lés # FIXME
működészavar    mű-kö-dés|za-var
nyelvtanár  nyelv||ta-nár
nyelvtanárképzés  nyelv|ta-nár||kép-zés
nyelvtanárok    nyelv||ta-ná-rok
nyelvtanárunk    nyelv||ta-ná-runk
pacemaker   pace-ma-ker
Quijote     Qui-jo-te
Quimby      Quim-by
Rákóczi     Rá-kó-czi
Rákóczit    Rá-kó-czit
Rákóczira   Rá-kó-czi-ra
Sennyey     Sen{y-}nye=y
Sennyeyt    Sen{y-}nye-yt
streetball  street-ball
szakipari   szak||i=pa-ri # not szaki|pari
szigetelőlapok  szi-ge-te-lő|la-pok # not sziget||elő|lapok
szívátültetett  szív||át|ül-te-tett
szuburbanizáció szub|ur-ba-ni-zá-ci=ó
Télapó      Tél|a=pó
tizenegyedikes  ti-zen|e=gye-di-kes
Toyota      To-yo-ta
underground un-der|ground
Uruguay     U=ru-guay
Uruguayé    U=ru-gua-yé
Uruguayét   U=ru-gua-yét
uruguayi    u=ru-gua-yi
uruguayiak  u=ru-gua-yi-ak
Uruguayjal  U=ru-guay-jal
Uruguayt    U=ru-guayt
Vázsonyi    Vá-zso-nyi
versenyhelyezés ver-seny||he-lye-zés
viszontláthat   vi-szont|lát-hat
Vörösmarty  Vö-rös-mar-ty
Vörösmartyé Vö-rös-mar-ty=é
Vörösmartyét    Vö-rös-mar-ty-ét
vörösmartys vö-rös-mar-tys
vörösmartysé    vö-rös-mar-ty-sé
vörösmartyst    vö-rös-mar-tyst
Vörösmartyt Vö-rös-mar-tyt
Vörösmartyval   Vö-rös-mar-ty-val
Waterloo    Wa-ter-loo
Waterloot   Wa-ter-loot
Waterlooé   Wa-ter-loo=é
Waterlooét  Wa-ter-loo-ét
Waterlooról Wa-ter-loo-ról
Wrocław     Wroc-ław
zarándokút  za-rán-dok|út
zarándokutakat  za-rán-dok|u=ta-kat
# ds:
exportellenőrzési   ex-port||el-len|őr-zé-si
# exceptions
alapok      a=la-pok
aranyért    a=ra-nyért
bankalapítás bank||a=la-pí-tás
csőrepedés  cső||re-pe-dés
elég        e=lég
elöl        e=löl
életévé     é=le-té-vé
megint      me=gint
fajtanév    faj-ta||név
fajtanévig  faj-ta||né-vig
fajtanévnek faj-ta||név-nek
farács      fa||rács
faráccsal   fa||rác{s-}csal
farész      fa||rész
farésszel   fa||rés{z-}szel
faszállítás fa||szál-lí-tás
faszékek    fa||szé-kek
faszövet    fa||szö-vet
felettük    fe-let-tük
feleszik    fel|e=szik
felüli      fe-lü-li
fiókalapítás fi-ók||a=la-pí-tás
fölüli      fö-lü-li
gyökérrendszer  gyö-kér||rend|szer
halálhír    ha-lál||hír
hangalapú   hang||a=la-pú
hatalmai    ha-tal-ma=i
hitelviszony    hi-tel||vi-szony
hódara      hó||da-ra
hódarát     hó||da-rát
karizma     ka-riz-ma
karizmát    ka-riz-mát
karizmai    kar|iz-ma=i
karizmuk    kar|iz-muk
kiabál      ki-a-bál
kocsisorral ko-csi|sor-ral
kőrács      kő||rács
különül     kü-lö-nül
legelőbb    leg||e=lőbb
oktatóévét  ok-ta-tó||é=vét
pártalapító párt||a=la-pí-tó
pártalapszervezet párt||a=lap||szer-ve-zet
sajtóbirodalom  saj-tó||bi-ro-da-lom
sajtóbirodalmak  saj-tó||bi-ro-dal-mak
szénacél    szén||a=cél
szénatomos  szén||a=to-mos
szerelőcsarnok  sze-re-lő||csar-nok
szerelőlap  sze-re-lő||lap
szigetelőanyag  szi-ge-te-lő||a=nyag
vízért      ví-zért"""

arguments = sys.argv

log = False

def part(s):
    s = re.sub(r'{[^\}]+}', '', s).replace('=', '').replace('--', '@').replace('-', '')
    # keep only constituent boundary with higher priority, if it exists
    # macska|kő||dobálás -> macskakő=dobálás
    if '||' in s:
        return s.replace('||', '=').replace('|', '')
    return s.replace('|', '=').replace('@', '-')

# default function: hyphenate
func = lambda s: re.sub(r'\|+', '=', s.replace('=', '').replace('--', '@').replace('-', '=').replace('@', '-').replace('{', '').replace('}', ''))
# process arguments
if len(arguments) < 2:
    arguments.append('-h')
while len(arguments) > 1 and arguments[1][0:1] == '-':
    nextarg = arguments[1]
    if nextarg == '-h' or nextarg == '--help':
        print(f'Usage: {sys.argv[0]} [ -h | --help | -s | --syllabify | -p | --part | -r | --raw | -v | --verbose ] file\nExample: echo példa | python3 hy.py -r /dev/stdin')
        sys.exit(-1)
    elif nextarg == '-s' or nextarg == '--syllabify':
        func = lambda s: re.sub(r'(\|+|-)', '=', s.replace('{', '').replace('}', '').replace('--', '@')).replace('@', '-')
    elif nextarg == '-p' or nextarg == '--part':
        func = part
    elif nextarg == '-r' or nextarg == '--raw':
        func = lambda s : s
    elif nextarg == '-v' or nextarg == '--verbose':
        log = True
    del arguments[1]

text=[s.strip() for s in open(sys.argv[1])]

# legéletbevágóbb  st:életbe_vágó po:adj is:bb_COMPARATIVE_adj ts:NOM al:legéletbevágóbbik
# odakézműveskedtem ip:PREF sp:oda  st:kézműveskedik po:vrb ts:PRES_INDIC_INDEF_SG_3 hy:3 is:PAST_INDIC_INDEF_SG_1

# tölgyfaleveleinket  pa:tölgy st:tölgy po:noun ts:NOM pa:faleveleinket  st:falevél po:noun ts:PLUR ts:NOM hy:2 is:PLUR is:POSS_PL_1 is:ACC
# tölgyfaleveleinket  pa:tölgyfa st:tölgyfa po:noun ts:NOM hy:5 pa:leveleinket  st:levél po:noun ts:PLUR ts:NOM is:PLUR is:POSS_PL_1 is:ACC

def hyphenate(patterns, word):
    for i in patterns:
        word = re.sub(i[0], i[1], word)
    return word

def test(patterns):
    for p in range(len(patterns)):
        subpatterns = patterns[:p+1]
        pattern = patterns[p]
        for testcase in re.split(', *', pattern[2]):
            # test word: test case without the hyphenation marks
            word = testcase.replace('--', '@') # keep hyphen of the original word
            word = re.sub('[-=]', '', word, re.IGNORECASE)
            word = word.replace('@', '--')
            hyphenated = hyphenate(subpatterns, word)
            if hyphenated != testcase:
                print(f'Failed hyphenation of “{word}”: “{hyphenated}” instead of “{testcase}” (rule: {pattern[3]})')

vowels = 'aäáàăeéèëiíoóöőøuúüű'
#vowels = vowels + vowels.upper()
consonants = 'qwrřtzpsšșdfghjklłxcčćvbnm' # without y
#consonants = consonants + consonants.upper()
v = rf'[{vowels}]'
c = rf'([{consonants}]|cs|dz|dzs|[glnt]y|sz|zs|c[hz]|sch)'
letters = rf'([{consonants}{vowels}]|cs|dz|dzs|[glnt]y|sz|zs|c[hz]|sch|y)' # consonants + vowels + y
patterns = [
    # v-v
    (rf'({v})({v})', r'\1-\2', 'be-ad fi-a-i-é-i', 'v-v'),
    # -cv
    (rf'(?<![-])({c}{v})', r'-\1', 'ad, al-ma, Ad-ri-enn, a-csa, e-dzek, ál-dzsent-ri, uzs-gyi, al-szik, Er-zsé-bet, ar-chí-vum', '-cv'),
    # -c-cv (fix -cv at 'legdicsőségesebb': leg-di-cső-sé-ge-sebb -> *leg-di-c-s-ő-sé-ge-sebb)
    (rf'(-{c})-', r'\1', '', '-c-'),
    # ^c*
    (rf'(^{c}*)-', r'\1', 'bab-ra, bo-dza, ben-dzsó, ma-gyar, drach-ma, Por-sche, Ransch-burg', '^c*'),
    (rf'([|]{c}*)-', r'\1', '|tril-li-ó', '|c*'),
    (rf'([-][-]{c}{c}*)-', r'\1', 'rossz--szí-vű', '--c*'),
    # v-v
    (rf'({v})({v})', r'\1-\2', 'Ad-ri-enn, a-du', '^c*'),
    # =v$, =v|, =v-- (hyphen in the original stem: televízió-műsor)
    (rf'-({v}$|{v}[|]|{v}[-][-])', r'=\1', 'rá-di=ó, a-du', '=v$'),
    # ^v=, |v=, --v= (hyphen in the original stem: rossz-szívű)
    (rf'^({v})-', r'\1=', 'a=du, a=csa, e=mo-dzsi, a=gyar, a=szat, u=zsi, a=chát', '^v='),
    (rf'(([|]|[-][-]){v})-', r'\1=', 'kéz|mű|i=par', '|v='),
    # ccs, ddz, ddzs,
    (rf'c-cs', r'c{s-}cs', 'locs-csan', 'cs-cs'),
    (rf'd-dzs', r'd{zs-}dzs', 'bridzs-dzsel', 'dzs-dzs'),
    (rf'd-dz', r'd{z-}dz', 'edz-dzek', 'dz-dz'),
    (rf'([glnt])-\1y', r'\1{y-}\1y', 'edz-dzek', 'gy-gy'),
    (rf's-sz', r's{z-}sz', 'asz-szony', 'sz-sz'),
    (rf'z-zs', r'z{s-}zs', 'va-rázs-zsal', 'zs-zs'),
    (rf'([^z]s)-zs', r'\1z-s', 'e=gész-ség', 'sz-s'),
    # it was "i=-gaz--sá-gát" after hyphenation of the hy: pattern
    (rf'([=|])[-=]', r'\1', 'i=gaz|sá-gát', '=-'),
    # c-hoz/-hez/-höz (not ch): aká-choz -> akác-hoz
    (rf'-c(h[oeö]z)$', r'c-\1', 'a=kác|hoz', 'c-hoz'),
    ]

# TESTING
test(patterns)

patterns = [(re.compile(r[0], re.IGNORECASE), r[1]) for r in patterns]

# test

# s/^=\?\(.\)=\?/\1/ # szó eleji elválasztójel törlése
# s/=\?\(.\)$/\1/ # szó végi törlése
# optimalizálás
# s/\(.[aáeéiíoóöőuúüű]\)\([aáeéiíoóöőuúüű].\)/\1=\2/g # magánhangók között van elválasztás
# s/^=\?\(.\)\?=/\1/ # szó eleji
# sed regex hiba ssz -> egy betűnek veszi
# s/=ccs/cs=cs/g;s/=ggy/gy=gy/g;s/=lly/ly=ly/g;s/=nny/ny=ny/g;s/=ssz/sz=sz/g;s/=tty/ty=ty/g;s/=zzs/zs=zs/g

def hyph_part(st):
    if log:
        print(f'hyph_part("{st}")')
    # remove paralel analysis:
    # INPUT:  kiáramlás  (  ip:PREF sp:ki st:áramol po:vrb ds:Ás_PROCESS/RESULT_noun ts:NOM | ip:PREF sp:ki  st:áramlik po:vrb ts:PRES_INDIC_INDEF_SG_3 al:áramoljék al:áramol ds:Ás_PROCESS/RESULT_noun ts:NOM )
    # OUTPUT: kiáramlás  ip:PREF sp:ki st:áramol po:vrb ds:Ás_PROCESS/RESULT_noun ts:NOM
    has_hy = 'hy:' in st
    if ' ( ' in st:
        # egészségügyi  (  st:egészségügy po:noun ts:NOM  is:i_PLACE/TIME_adj ts:NOM |  st:egészségügy po:noun ts:NOM hy:8 is:i_PLACE/TIME_adj ts:NOM )
        # keep part with hy:
        st = st.replace(' ds:hAtÓ_ABLE_(adj,present_part)', ' ds:hAtÓ_ABLE') # fix 'igénybevehetőségét'
        pipe = st.rindex(' | ')
        try:
            if st.index('hy:', pipe):
                st = re.sub(r' [(] [^)]* [|] ([^)]*) [)]', r' \1', st)
        except:
            if has_hy:
                st = re.sub(r' [(] ([^|)]*) [|] [^)]* [)]', r' \1', st)
            else:
                st = re.sub(r' [(] [^)]* [|] ([^)]*) [)]', r' \1', st)
        if log:
            print(st)

    # filter relevant fields
    fields = st.split()
    part = fields[0]
    if log:
        print('HYPH_PART:', part)
    prefix = ''
    legprefix = ''
    numeric_hy = -1
    do_not_hyphenate = False
    origpart = ""
    missing_leg_prefix = False # fix leggyönyörűbb (missing prefix in analysis: *legy-gyönyörűbb)
    terminal_consonant = '' # fix her-tzet (not *hert-zet)
    terminal_consonant_ok = True # ro-ckot, but tarac-kot
    terminal_y_i = False
    terminal_y_j = False
    terminal_ny = False
    terminal_INSTR_or_TRANS = False
    stem = ''
    for nfield, field in enumerate(fields):
        if log:
            print('FIELD: ', nfield, field, part)
        # fix iga-zság/külön-cség, if there is no explicit hy:
        # fix rendeltetésszerű -> *rendeltetész-szerű
        if field.startswith('st:'):
            # keep original hyphen by duplicating it
            stem = field.replace('-', '--')
        elif field == 'ds:beli_LOCATIVE_adj':
            origpart = part
            part = re.sub(r'beli', r'|beli', part)
        elif field == 'ds:szerű_SORT_adj':
            origpart = part
            part = re.sub(r'szerű', r'|szerű', part)
        elif field == 'po:szerte_PLACE_adj':
            origpart = part
            part = re.sub(r'szerte', r'|szerte', part)
        elif field == 'ds:mentes_FREE_adj':
            origpart = part
            part = re.sub(r'mentes', r'|mentes', part)
        elif field == 'ds:sÁg_ABSTRACT_noun' and not 'hy:' in st:
            origpart = part
            part = re.sub(r'([^-])(s[áé]g)', r'\1-\2', part)
        elif field == 'is:bb_COMPARATIVE_adj':
            missing_leg_prefix = True
        elif field == 'is:nyi_MEASURE_adj':
            terminal_ny = True
        elif field in ['is:INSTR', 'is:TRANS', 'po:INSTR', 'po:TRANS']:
            terminal_INSTR_or_TRANS = True
    if origpart and 'ip:PREF' not in st and 'ip:leg' not in st and 'hy:' not in st and 'sp:' not in st and not (missing_leg_prefix and part.startswith('leg') and 'st:leg' not in st):
        return hyphenate(patterns, part) + '||'
    # fix 'leggyönyörűbb' and 'legesleggyönyörűbb'
    if missing_leg_prefix:
        if part.startswith('legesleg'):
            if 'ip:legesleg_SUPERLATIVE_adj' not in st and 'st:legesleg' not in st:
                if log:
                    print('add ip:legesleg_...', fields)
                fields = ['ip:legesleg_SUPERLATIVE_adj'] + fields
        elif part.startswith('leg') and 'ip:leg_SUPERLATIVE_adj' not in st and 'st:leg' not in st:
            if log:
                print('add ip:leg_...', fields)
            fields = ['ip:leg_SUPERLATIVE_adj'] + fields

    is_hy_processed = False
    for nfield, field in enumerate(fields):
        fid = field[0:3]
        if log:
            print('FIELD: ', nfield, field, part)
        if fid == 'ip:':
            prefixid = field[3:]
            if prefixid == 'leg_SUPERLATIVE_adj':
                legprefix = 'leg||'
                # it's possible to hyphenate immediately, if it's not a compound
                if 'hy:' not in st and not (nfield < len(fields) and fields[nfield + 1] == 'ip:PREF'):
                    part = hyphenate(patterns, part[3:])
                    origpart = ""
                else:
                    part = part[3:]
            elif prefixid == 'legesleg_SUPERLATIVE_adj':
                legprefix = 'le-ges|leg||'
                # it's possible to hyphenate immediately, if it's not a compound
                if 'hy:' not in st and not (nfield < len(fields) and fields[nfield + 1] == 'ip:PREF'):
                    part = hyphenate(patterns, part[8:])
                    origpart = ""
                else:
                    part = part[8:]
        elif fid == 'sp:' or fid == 'pr:':
            prefix = field[3:]
            if 'hy:' not in st:
                # handle also | in sp:két|száz (kétszázezer)
                part = hyphenate(patterns, part[len(prefix.replace('|', '')):])
                if log:
                    print(part, prefix)
                origpart = ""
            else:
                part = part[len(prefix.replace('|', '')):]
            prefix = hyphenate(patterns, prefix) + '|'
        elif fid == 'hy:' and not is_hy_processed:
            is_hy_processed = True
            field_hy = field[3:]
            origpart = ""
            # break point by a number, e.g. "hy:3"
            try:
                numeric_hy = int(field_hy)
                #if log:
                if numeric_hy != 0:
                    part = hyphenate(patterns, part[:numeric_hy]) + '|' + hyphenate(patterns, part[numeric_hy:])
                # not Poe- al:Poe-val etc.
                elif 'al:' + 'part' + '-' not in st:
                    # handle suffixed forms, like Freu-di, fai-rek, Holme-son, Twai-nen
                    # st: and terminating consonant
                    if stem and len(stem) > 3 + 2 and re.search(rf'{c}$', stem):
                        part = hyphenate(patterns, part)
                        stem = stem[3:-2]
                        stem_pattern = stem.replace('', '([-=|]|[|][|]|{[^}]*-})?')
                        if log:
                            print("hy:", stem, stem_pattern, part)
                        part = re.sub(stem_pattern.lower(), stem.lower(), part.lower())
                        if log:
                            print("hy:", stem, stem_pattern, part)
               # if log:
            # break point by a pattern, e.g. "hy:igaz-ság"
            except:
                # last '=' character means disabled hyphenation over the specified hyphenation points, e.g. hy:paint|ball=
                do_not_hyphenate = field_hy[-1:] == '='
                if do_not_hyphenate:
                    # trim terminal '='
                    field_hy = field_hy[:-1]
                terminal_y_i = re.search(rf'[-]{c}*y$', field_hy.replace('.',''))
                if '-' in field_hy or '=' in field_hy or do_not_hyphenate:
                    # extend sub-pattern, e.g. -dy -> Veker-dy
                    field_hy_pattern = re.sub(r'[-=|.]', '', field_hy)
                    # trim terminal consonant to avoid of lost hyphenation
                    # in the case of suffixed form: igazságát + hy:igaz-ság -> igaz-sá-gát
                    # (only if it mathes the end of the stem to avoid of
                    # Mon-taigne -> hy:Mon-taign -> Mon-taig -> *Mon=taig=ne)
                    # (but not hy:-dy -> Veker-dy)
                    if part.startswith(field_hy_pattern) or part.lower().startswith(field_hy_pattern.lower()):
                        last_char = field_hy[-1:]
                        try:
                            st_field_pos = st.index('st:')
                            st_field_end_pos = st.index(' ', st_field_pos)
                            if last_char.lower() == st[st_field_end_pos-1].lower():
                                # handle also ~rug|gyan-ta -> hy:rug|gyan-t -> *rug|gyan-
                                if log:
                                    print('before strip pattern:', field_hy)
                                # handle Csergheő= -> *Cserghe=ő
                                if (do_not_hyphenate and re.search(rf'{v}{v}$', field_hy)):
                                    # strip only a single letter, allowing 'Csergheő-ék'
                                    field_hy = re.sub(rf'{letters}$', '', field_hy)
                                else:
                                    # strip two letters, allowing 'paint|bal-los'
                                    field_hy = re.sub(rf'[^-]{letters}$', '', field_hy)
                                if log:
                                    print('strip pattern:', field_hy)
                        except:
                            if log:
                                print('EXCEPTION: ', field_hy)
                            pass
                    # first hyphenate it, and later fix it
                    part = hyphenate(patterns, part)
                    # create a pattern, which matches the (badly) hyphenated word, for example
                    # hy:igaz-ság -> igazság -> i([-=|]|[|][|]|{[^}]*-})?g([-=|]|[|][|]|{[^}]*-})?a...
                    # hy:rug|gyanta -> ruggyanta -> r([-=|]|[|][|]|{[^}]*-})?u([-=|]|[|][|]|{[^}]*-})?g([-=|]|[|][|]|{[^}]*-})?g...
                    # matching iga-zság, rugy-gyanta, fixing them as igaz-ság, rug-gyanta
                    field_hy_pattern = re.sub(r'[-=|.]', '', field_hy)
                    #field_hy_pattern = field_hy_pattern[:-1].replace('', '([-=|]|[|][|]|{[^}]*-})?') + field_hy_pattern[-1:]
                    field_hy_pattern = field_hy_pattern.replace('', '([-=|]|[|][|]|{[^}]*-})?')
                    # convert the patterns and the word to lowercase, to avoid of bad forms, like *Országy=gyűlés
                    if log:
                        print('hy: non-numeric before:', part.lower(), ':', field_hy.lower(), '→', field_hy_pattern.lower())
                    # remove dot from ec.s-ta-sy
                    # replace only once (A=dy -> A= -> *A=dyna=k
                    part = re.sub(field_hy_pattern.lower(), field_hy.lower().replace('.', ''), part.lower(), 1)
                    if log:
                        print('hy: non-numeric after:', part)
                else:
                    # convert the patterns and the word to lowercase, to avoid of bad forms, like *Országy=gyűlés
                    if log:
                        print("only part:", field_hy.lower(), part)
                    part = hyphenate(patterns, part.lower().replace(re.sub(r'[-=|.]', '', field_hy.lower()), field_hy, 1))
                    if log:
                        print("only part:", field_hy.lower(), part)
            # fix hyphenation before the last letter
            part = re.sub(r'[-](\w)$', r'=\1', part)
        elif fid == 'st:':
            if field.endswith('n') and terminal_ny and 'nnyi' in part:
                terminal_consonant = 'n{y-}'
            elif terminal_INSTR_or_TRANS and field.endswith('s') and re.search(r'ssz([ae]l|[áé])$', part):
                terminal_consonant = 's{z-}'
            elif field.endswith('ck'):
                terminal_consonant = 'c-k'
                terminal_consonant_ok = False
            elif field.endswith('gh'):
                terminal_consonant = 'g-h'
            elif field.endswith('sh'):
                terminal_consonant = 's-h'
            elif field.endswith('th'):
                terminal_consonant = 't-h'
            elif field.endswith('ts'):
                terminal_consonant = 't-s'
            elif field.endswith('tz'):
                terminal_consonant = 't-z'
            elif terminal_INSTR_or_TRANS and field.endswith('ws'):
                terminal_consonant = 'w-sz'
            if log:
                print('TERMINAL CONSONANT:', terminal_consonant)
        elif fid == 'ph:':
            if terminal_consonant == 'c-k' and not field.endswith('ck'):
                terminal_consonant_ok = True
            elif field.endswith('j') and stem.endswith('y'):
                terminal_y_j = True

    # handle hy:, if not hy:0
    if part == fields[0] and numeric_hy != 0 and not do_not_hyphenate:
        if log:
            print('handle hy:, if not hy:0:', part, fields[0])
        part = hyphenate(patterns, part)
        if log:
            print('after handle hy:', part)

    # fix hert-zet -> her-tzet
    if terminal_consonant and terminal_consonant_ok and terminal_consonant in part:
        if log:
            print('TERMINAL CONSONANT:', terminal_consonant, part)
        if terminal_consonant == 'n{y-}' or terminal_consonant == 's{z-}':
            # replace the last one
            part = (terminal_consonant[0] + '-').join(part.rsplit(terminal_consonant, 1))
        if terminal_consonant == 'w-sz':
            part = 'ws-z'.join(part.rsplit(terminal_consonant, 1))
        else:
            # replace the last one, not the first one?, not, because this is only for traditional family names + hertz
            part = part.replace(terminal_consonant, '-' + terminal_consonant.replace('-', ''))
    if terminal_y_i:
        if log:
            print('TERMINAL_Y_I', part)
        part = re.sub(rf'({terminal_y_i.group()}{c}*?)({c}?{v})', r'\1-\3', part)
        part = re.sub(rf'[-]({v})$', r'=\1', part)
        part = re.sub(rf'^({v})[-]', r'\1=', part) # A=dy, A=dyt, A=dy=é, A=dy-ét
        if log:
            print('TERMINAL_Y_I', part)
    elif terminal_y_j:
        if log:
            print('TERMINAL_Y_J', part)
        part = re.sub(rf'y({v})', r'-y\1', part)

    return legprefix + prefix + part + '||'

def hyph(st, analysis):
    # choose the analysis with a hy: part
    hid = 0
    # FIXME keep last hy: elements
    analysis = [i.decode('utf-8') for i in analysis]
    # remove ki|abál, fel|ette etc.
    for n in (6, 4):
        exception_morph = st[:n] in EXCEPTIONS_MORPH
        if exception_morph:
            sign = re.compile(EXCEPTIONS_MORPH[st[:n]])
            analysis_morph = [i for i in analysis if not re.search(sign, i)]
            if analysis_morph:
                if log:
                    print('MORPH:', analysis_morph)
                analysis = analysis_morph
    # prefer hy:
    analysis_with_hy = [i for i in analysis if 'hy:' in i]
    if log:
        print(analysis_with_hy)
        print(analysis)
    if analysis_with_hy:
        analysis = analysis_with_hy
        # choose the last one with multiple compound
        # kerék|párút -> kerék|pár||út
        if len(analysis) > 1 and '||' not in analysis[-1] and '||' in analysis[-2]:
            del analysis[-1]

    # choose the last one, containing less (often fake) compound constituent
    # e.g. tan-ács-tag -> tanács-tag
    # FIXME choose the one with less pa: fields
    s = analysis[-1].strip()

    # fix dictionary bug temporarily!!!
    s = re.sub(r'([^\s])(\w\w:)', r'\1	\2', s)

    # split compound consituents
    parts = s.split('pa:')

    # handle 'hároméves'
    # hároméves po:adj_num  három  st:év po:noun ts:NOM ds:s_OCCUPATION_noun ts:NOM
    if len(parts) == 2 and "po:adj_num pa:" in s:
        parts = s.replace('po:adj_num pa:', 'sp:').split('pa:')

    # if not a compound, add the word form to it, as a constituent
    if len(parts) < 3:
        parts[0] = st + ' ' + parts[0]
        # egyszeriben (egyszeriben po:adj_num pa:egy  st:szer po:noun ts:NOM is:i_PLACE/TIME_adj ts:NOM is:INE)
        if len(parts) == 2:
            parts[0] = parts[0] + ' ' + parts[1]
            del parts[1]

    # join analysis of the compound constituents
    # FIXME keep only the last hy: element
    return ''.join([hyph_part(re.sub(r'hy:[^ ]* (hy:)', r' \1', p)) for p in parts if p != '']).strip('|')

def hyphenate_word(word):
    titlecase = word[0] == word[0].upper()
    uppercase = titlecase and word == word.upper()
    exception = word in EXCEPTIONS
    hyphen_e = word[-2:]
    if hyphen_e.lower() == '-e':
        word = word[:-2]
        hyphen_e = '-' + hyphen_e
    else:
        hyphen_e = ''
    # analyse, if it is not a hyphen used instead of an n-dash
    if word and word != '-' and not exception:
        analysis = h.analyze(word)
        if log:
            print('ANALYSIS: ', analysis)
        if analysis:
            word = hyph(word.replace('-', '--'), analysis)
        elif '-' in word or '–' in word:
            if log:
                print('Split at hyphens and n-dashes...')
            # split at hyphens, and try to hyphenate the word parts
            parts = []
            word_parts = word.split('-')
            do_analysis = True
            for w in word_parts:
                parts2 = []
                # split at n-dash
                for v in w.split('–'):
                    # only a single hyphen, check for word + hyphen
                    if len(word_parts) == 2 and v == w and not parts2:
                        analysis = h.analyze(w)
                        if not analysis:
                            analysis = h.analyze(w + '-')
                            if analysis:
                                v = v + '-'
                                do_analysis = False
                    parts2.append(hyphenate_word(v))
                parts.append('–'.join(parts2))
            if not do_analysis:
                parts[0] = parts[0].strip('-')
            word = '--'.join(parts)
        else:
            if log:
                print('no analysis for:', word)
            # words with hyphen are recognized without the hyphen, too
            analysis = h.analyze(word + '-')
            if analysis:
                word = hyph(word + '-', analysis).strip('-')
            else:
                word = hyphenate(patterns, word)
    elif exception:
        word = EXCEPTIONS[word]
    if uppercase:
        return word.upper() + hyphen_e
    elif titlecase:
        return word[0].upper() + word[1:] + hyphen_e
    return word + hyphen_e

def base_test():
    bad = False
    for words in WORDS:
        word = hyphenate_word(words[0])
        if func(word) != func(words[1]):
            print(words[0], f'→ *{func(word)} (correct: {func(words[1])})')
            bad = True
    if bad:
        print('Failed test.')
        sys.exit(-1)

# run regression tests for the development
# FIXME remove True
if log or True:
    WORDS = [s.split() for s in WORDS.split('\n') if not s.startswith('#')]
    base_test()

# hyphenate all words in the text line, keeping punctuation
for words in text:
    hyphenated_words = []
    for split in words.split():
        # split quotation marks, other punctuation before and after the word
        try:
            # middle part (the word) can contain hyphens and n-dashes, too
            parts = list(re.match('([^\w]*)([-–\w]+)([^\w]*)', split).groups())
            parts[1] = hyphenate_word(parts[1])
            hyphenated_words.append(func("".join(parts)))
        except:
            hyphenated_words.append(split)
    print(' '.join(hyphenated_words))

