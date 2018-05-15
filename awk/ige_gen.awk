#
# igék ragozási csoportba sorolása
#
BEGIN { 
    while ((getline var < "ige_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "ige_morfo.1") > 0) { morfo[var]=1; }
    while ((getline var < "ige_koto.1") > 0) { koto[var]=1; }
    while ((getline var < "ige_osszetett.1") > 0) { ossz[var]=1; }
}

# mély hangrendû igék + i
/[uúoóaá][bcdfghjklmnpqrstvwxyz]*ik$/ || /[uúoóaá][bcdfghjklmnpqrstvwxyz]*ít$/ { 
    print "[vrb]" $0 "/O" o (koto[$1]?"":"X") (ossz[$1]?"y":""); next }
/[uúoóaá][bcdfghjklmnpqrstvwxyz]*$/ { 
    if (morfo[$0]==1) { print "[vrb]" $0 "/O" o "/d" m (koto[$1]?"":"X") (ossz[$1]?"y":"")} 
    else { print "[vrb]" $0 "/O" o (koto[$1]?"":"X") (ossz[$1]?"y":"")}
    next
}
# magas, ajakréses
/-zik$/ || /[iíeëé][-bcdfghjklmnpqrstvwxyz]*ik$/ || /[iíeé][bcdfghjklmnpqrstvwxyz]*ít$/ { 
    if (mely[$0]==1) { print "[vrb]" $0 "/O" o (koto[$1]?"":"X") (ossz[$1]?"y":"")} 
    else { print "[vrb]" $0 "/E" e (koto[$1]?"":"X") (ossz[$1]?"y":"")};
    next
}
/[iíeé][bcdfghjklmnpqrstvwxyz]*$/ && ! /ik$/ {
    if (mely[$0]==1) { print "[vrb]" $0 "/O" o (koto[$1]?"":"X") (ossz[$1]?"y":"")} 
    else { 
		if (morfo[$0]==1) { print "[vrb]" $0 "/E" e "/d" m (koto[$1]?"":"X") (ossz[$1]?"y":"")} 
		else { print "[vrb]" $0 "/E" e (koto[$1]?"":"X") (ossz[$1]?"y":"")};
    }
    next
}
# magas, ajakkerekítéses
/[öõüû][-bcdfghjklmnpqrstvwxyz]*ik$/ { 
    if (mely[$0]==1) { print "[vrb]" $0 "/O" o (koto[$1]?"":"X") (ossz[$1]?"y":"")} 
    else { print "[vrb]" $0 "/P" p (koto[$1]?"":"X") (ossz[$1]?"y":"")};
    next 
}
/[öõüû][bcdfghjklmnpqrstvwxyz]*$/ { 
    if (mely[$0]==1) { print "[vrb]" $0 "/O" o (koto[$1]?"":"X") (ossz[$1]?"y":"")}
    else {     
    	if (morfo[$0]==1) { print "[vrb]" $0 "/P" p "/d" m (koto[$1]?"":"X") (ossz[$1]?"y":"")}
    	else { print "[vrb]" $0 "/P" p (koto[$1]?"":"X") (ossz[$1]?"y":"")};
	}
    next 
}
