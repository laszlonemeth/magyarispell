#
# igékbõl ás/és fõnévképzõs, stb. alakok legenerálása, lásd igesgen
#
# magánhangzók száma
function M(s) {
	m=0
	n=split(s, a, "")
	for (i=1; i<=n; i++) {
		if (a[i]~/[aáeéiíoóöõuúüû]/) m++
	}
	return m
}
BEGIN {
    while ((getline var < "ige_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "ige_tat_kiv.1") > 0) { tat_kiv[var]=1; }
    while ((getline var < "ige_ikes_kiv.1") > 0) { ikes_kiv[var]=1; }
}
# mély hangrendû igék + i
(MELYRAG=="¡") && (tat_kiv[$0]==1 || ikes_kiv[$0]) { next }
(MELYRAG=="§") && (ikes_kiv[$0]) { next }
(MELYRAG=="§") && ((tat_kiv[$0]) && ($0!~/szt$/) && ($0!~/nt$/)) { next }
(MELYRAG=="§" && M($0)==1) { next }
(MELYRAG=="§" && ($0~/ik$/) && M($0)==2) { next }
! (MELYRAG=="©") && ikes_kiv[$0] { next }
/[uúoóaá][bcdfghjklmnpqrstvwxyz]*ik$/ { print "[vrb]" $1 "/" MELYRAG }
/[uúoóaá][bcdfghjklmnpqrstvwxyz]*ít$/ { print "[vrb]" $1 "/" MELYRAG }
/[uúoóaá][bcdfghjklmnpqrstvwxyz]+$/ && ! /(ik|ít)$/ { print "[vrb]" $1 "/" MELYRAG }
# magas
mely[$0]==1 { RAG=MELYRAG }
mely[$0]!=1 { RAG=MAGASRAG }
/[iíeéöõüû][bcdfghjklmnpqrstvwxyz]*ik$/ || /-zik$/ { print "[vrb]" $1 "/" RAG; next }
/[iíeéöõüû][bcdfghjklmnpqrstvwxyz]*ít$/ || /^szít$/ { print "[vrb]" $1 "/" RAG; next }
/[iíeéöõüû][bcdfghjklmnpqrstvwxyz]+$/ && ! /(ik|ít)$/ { print "[vrb]" $1 "/" RAG }
