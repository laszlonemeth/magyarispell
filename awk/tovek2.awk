#
# tövek felvétele kivételekhez a fonev_morfo állományokból
#
/	/ {
    if ($2 != "") {
	print "[nounmorfo]" $2 "\t" $1 "[noun]{+[PLUR]+[NOM]}"
	next
    }
}
