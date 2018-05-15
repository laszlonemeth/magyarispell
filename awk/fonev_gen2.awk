#
# morfonetikus alternáns fõnevek ragozási csoportba sorolása
#
# produktív toldalékolás
#
# külsõ változó: kulon_e (tulajdonnevek esetén kikapcs. szóösszetétel,
# ha kulon_e==1)
#
BEGIN { 
    while ((getline var < "fonev_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "fonev_kulon.1") > 0) { kulonszo[var]=1; }
    while ((getline var < "fonev_osszetett.1") > 0) { osszetett[var]=1; }
}

function kulon(st, nyi, nyi_rule119) {
    s=""
    if (osszetett[$1]==1) s="/y" nyi; else s = nyi_rule119;
    if (kulon_e==1) return s;
    if (kulonszo[st]!=1) {
	return s "/Y/c" melleknevrag
    } else {
	return "/c" melleknevrag
    }
}

# -talan/-telen és -i képzõk (szerelemtelen, *háztalan, *szerelemi, házi)
function talan(s, s2, s3) {
    if (RAG != "") return s
    if (osszetett[$1]==1) return s2
    return s3
}

# -ka, -ke kicsinyítõképzõ:
# a szó nem összetett, és legalább két szótagú
function ka(s) {
    if (!osszetett[$1] && $1~/[aáeéiíoóöõuúüûAÁEÉIÍOÓÖÕUÚÜÛ].*[aáeéiíoóöõuúüû]/) return s
    return ""
}

# magánhangzóra végzõdõ
function magan(s,s2) {
	return ($1~"[uúoóaáiíeéöõüû]$") ? s : s2
}

# mély hangrendû nevszok, morfonetikus alternánsok 
/[uúoóaá][bcdfghjklmnpqrstvwxyz]*$/  { print $1 "/U" magan("ÏÖ","mô") \
	(RAG!="J"?"Ò":"") kulon($1,"/i", "/ç/i") talan("/®", "Ç", "²") ka("k") }
# magas, ajakréses
/[iíeé][bcdfghjklmnpqrstvwxyz]*$/  {
    if (mely[$1]==1) { print $1 "/U" (RAG!="J"?"Ò":"") magan("ÏÖ","mô") \
		kulon($1,"/i","/ç/i") talan("/®", "Ç", "²") ka("k")}
    else { print $1 "/V" (RAG!="J"?"Ó":"") magan("Ğ×","nò") \
		kulon($1,"/j", "/è/j") talan("/¯", "È", "³") ka("l")}
}
# magas, ajakkerekítéses
/[öõüû][bcdfghjklmnpqrstvwxyz]*$/ { print $0 "/W" magan("ŞØ","İ") \
	(RAG!="J"?"Ô":"") kulon($1,"/j", "/è/j") talan("/¯", "È", "³") ka("l")}
