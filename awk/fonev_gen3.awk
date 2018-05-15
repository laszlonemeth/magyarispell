#
# morfonetikus alternáns fõnevek ragozási csoportba sorolása
#
# improduktív toldalékolás
#
# külsõ változó: kulon_e (tulajdonnevek esetén kikapcs. szóösszetétel,
# ha kulon_e==1)
#
BEGIN { 
    while ((getline var < "fonev_kulon.1") > 0) { kulonszo[var]=1; }
    while ((getline var < "fonev_osszetett.1") > 0) { osszetett[var]=1; }
}

function kulon() {
    s=""
    if (kulon_e==1) return ""
    if (osszetett[$1]==1) s="/yÂâ"; else s = "/Ææ/º"
    if (RAG == "J") {
        if (osszetett[$1]==1) s = s "/É/Ââ"
        else s = s "/´"
    }
    if (kulonszo[$1]!=1) {
	return s "/x"
#	return "/Y" # MYSPELL
    } else {
	return ""    
    }
}

{ print "[nounmorfo]" $1 "/I/ó/Í/¾" RAG kulon(); }
