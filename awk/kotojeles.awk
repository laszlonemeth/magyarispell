#
# kötõjeles toldalékkal ellátott névszók
# (számok, mozaikszavak és idegen kiejtésû fõnevek)
#
BEGIN {
	FS="\t"
    while ((getline var < "kotojeles_hangzo.1") > 0) { hangzo[var]=1; }
    while ((getline var < "kotojeles_osszetett.1") > 0) { ossz[var]=1; }
}
{ pos="[noun]{+[NOM]}"; num=""; num2="" }
/^[0-9][0-9]*	/ { num="/01q"; num2="/1" } # 115-féle
/^[0-9]*[.%]	/ { num="/1q"; num2="/1" } # 115.-nek, 25%-hoz
/^\&(deg|sect|permil);	/ { num="/1"; num2="/1" } # 15°-kal
/^(\[[a-zA-Z0-9]*\])?[0-9][0-9]*	/ { pos="[adj_num]{+[NOM]}" }
/^(\[[a-zA-Z0-9]*\])?[A-Z]/ { pos="[noun_prs]{+[NOM]}" }
/^(\[[a-zA-Z0-9]*\])?[A-Z][A-Z]/ { pos="[abr]{+[NOM]}" }
/^(\[[a-zA-Z0-9]*\])?.*[.]/ { pos="[abr]{+[NOM]}" }
{
if ($2) { # 2-höz, de 2-eshez miatt
print $1 (ossz[$1]?"/x":"") num
print $1 "\t" pos
print $1 "-/" num2 (hangzo[$1]?V1:V2) (ossz[$1]?"Y":"") "&" # substandard root
print $1 "-\t" $1 pos
print $2 num2 (ossz[$1]?"/x":"")
print $2 "\t" $1 pos "+[INSTR]"
print $3 num2 (ossz[$1]?"/x":"")
print $3 "\t" $1 pos "+[TRANS]"
}
if ($4) {print $4 "/" V3 num2 (ossz[$1]?"/x":""); print $4 "\t" $1 pos "+[s_ATTRIBUTE_adj]{+[NOM]}"}
if ($5) {print $5 "/" V4 num2  (ossz[$1]?"/x":""); print $5 "\t" $1 pos "+[i_PLACE/TIME_adj]{+[NOM]}"}
if ($6) {print $6; print $6  num2 (ossz[$1]?"/x":"") "\t" $1 pos "+[ACC]"}
if ($7) print $7
}
