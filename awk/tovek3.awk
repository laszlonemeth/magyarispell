#
# tövek felvétele a külön kezelt igék képzett alakjaihoz (egy 0-ban különbözök a tovek2.awk-tól)
#
/	/ {
    if ($2 != "") {
	print $2 "\t" $1
	next
    }
}
