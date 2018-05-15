#
# tövek felvétele a tulajdonnevek melléknévképzõs alakjaihoz
#
/.	./ {
    l1 = length($1);
    l2 = length($2);
    # ha a tulajdonnév és a melléknév megegyezik (elsõ betût és a képzõt nem nézzük)
    if (substr($1, 2, l1-1) == substr($2, 2, l1-1)) {
	if (l1 != l2) {
	    print $2 "\t" $1
	} else {
	    # a méretük megegyezik (pl. Hawaii/hawaii)
	    print $2 "\t" $1
	}
    } else {
	# egyébként ha nem -y (vagyis i vagy j végû)
	if (match($1,"[^ij]$")) {
	    print $2 "\t" $1	    
	}
    }
}
