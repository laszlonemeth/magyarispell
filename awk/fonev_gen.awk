#
# fõnevek ragozási csoportba sorolása
#
# külsõ változó: tulaj_e (tulajdonnevek esetén kikapcs. szóösszetétel)
# ha tulaj_e==1)
# tulaj_geo_e: ötamerikai külön (a földrajzi neveknél a 119. szabály
# nincs elfogadva)
#
# ketchup ingadozása bedrótozva
#

BEGIN { 
    while ((getline var < "fonev_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "fonev_magas.1") > 0) { magas[var]=1; }
    while ((getline var < "fonev_magas2.1") > 0) { magas2[var]=1; }
    while ((getline var < "fonev_ing.1") > 0) { ingadozo[var]=1; }
    while ((getline var < "fonev_jaje.1") > 0) { jaje[var]=1; }
    while ((getline var < "fonev_ae.1") > 0) { ae[var]=1; }
    while ((getline var < "fonev_jajeae.1") > 0) { jajeae[var]=1; }
    while ((getline var < "fonev_oe.1") > 0) { oe[var]=1; }
    while ((getline var < "fonev_kulon.1") > 0) { kulonszo[var]=1; }
    while ((getline var < "fonev_eleje.1") > 0) { elejeszo[var]=1; }
    while ((getline var < "fonev_vege.1") > 0) { vegeszo[var]=1; }
    while ((getline var < "fonev_osszetett.1") > 0) { osszetett[var]=1; }
    while ((getline var < "fonev_a.1") > 0) { a[var]=1; }
    while ((getline var < "fonev_y_i.1") > 0) { y_i[var]=1; }
    while ((getline var < "fonev_y_j.1") > 0) { y_j[var]=1; }
    while ((getline var < "fonev_s.1") > 0) { fn_s[var]=1; }
    while ((getline var < "tobbtagu.1") > 0) { tobbtagu[var]=1; }
    while ((getline var < "fonev_igekoto.1") > 0) { igekoto[var]=1; }
}
function jaje_e(st,j,nemj) {
if (jaje[st]==1 || y_i[st]) {return j;} else {
if (ae[st]==1) {return nemj;} else {
if (jajeae[st]==1) {return j nemj; } else {
if (match(st,"[cghjmsxyvz]$")) { return nemj;}
  else {return j;}  
}}}}

# kulon és igekoto
function kulon(st) {
    igekot = (igekoto[st]==1) ? "/X" : ""
    if (tulaj_e==1) return "/," igekot;
    if (vegeszo[st]==1) {
	return "/x/c" igekot
    } else if (elejeszo[st]==1) {
	return "/v/c" igekot
    } else if (kulonszo[st]!=1) {
	return "/Y/c" igekot
    } else {
	return "/c" igekot
    }
    return igekot
}

# ajakkerekítéses magas csoportok (improduktív -es (könyves), produktív -ös (tökös))

function _s(kotojeles_s) {
    return (tobbtagu[$1] ? kotojeles_s: "")
}

function os(s1, s2) {
    if (oe[$1]==1) return s2;
    return s1;
}

# -jú, -jû

function ju(s1, s2) {
    if (tulaj_e==1) return s1
    if (osszetett[$1] == 1) return s2
    return s1 s2
}

function tulaj(s, s2, s3, s4) {
    if (tulaj_geo_e==1) return "/q" s2
    if (tulaj_e==1) return "/q" s3
    if ($1~/^[^aeuioöõüóúéá¿í]*[aeuioöüóõúéá¿í]$/) s="" # ti->tiz
    if (osszetett[$1]==1) return s "y" s3
    return s s4
}

# -ka, -ke kicsinyítõképzõ:
# a szó nem összetett, és legalább két szótagú
function ka(s) {
    if (!osszetett[$1] && $1~/[aáeéiíoóöõuúüûAÁEÉIÍOÓÖÕUÚÜÛ].*[aáeéiíoóöõuúüû]/) return s
    return ""
}

magas2[$1]==1 && !/u$/  { # Weöreshöz, Wordhöz
    print $1 "/W/Ì/¯/j" (y_i[$1]?"ÕBĞÑ":"ØMİÔ") tulaj("/í", "¶", "ÈÁÿ", "è³Åå") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","½") ka("l") _s("ù")
    next
}

( /[aáoóuú]$/ || /agrave;$/ || /ugrave;$/ )  && magas2[$1] != 1 {
    print $1 "/Õ/A/U/Q/Ê/®/i/Ï/Ò" tulaj("/á", "µ", "Ç¿ß", "ç²Ãã") kulon($1) ju("·","»") _s("÷")
}
/[öõüû]$/ || /oslash;$/ || magas2[$1] == 1 { 
    print $1 "/Õ/C/W/R/Ì/¯/j/Ş/Ô" tulaj("/í", "¶", "È" os("Áÿ","Àà"), "è³Åå") kulon($1) ju("¸","½") _s("ù")
}
/[eéiíä]$/ { 
    if (ingadozo[$1]==1) {
	print $1 "/Õ/A/U/B/V/L/Q/R/Ê/®/Ë/¯/i/j/Ï/Ğ/Ó" tulaj("/á/é", "µ¶", "Ç¿ßÈ", "çè²³ÄäÃã") kulon($1) ju("·","»") ju("¸","¼") _s("ø")
    } else {
        if (mely[$1]==1) {
	    print $1 "/Õ/A/U/Q/Ê/®/i/Ï/Ò" tulaj("/á", "µ", "Ç¿ß", "ç²Ãã") kulon($1) ju("·","»") _s("÷")
	} else {
	    print $1 "/Õ/B/V/R/Ë/¯/j/Ğ/Ó" tulaj("/é", "¶", "ÈÀà", "è³Ää") kulon($1) ju("¸","¼") _s("ø")
	}
    }
}

$1=="ketchup" { # [kecsap]-[kecsöp]
		s = fn_s[$1]?"mö":"mô"
	    print $1 "/U/Ê/®/i" (a[$1]?"$sÒ" s:(y_i[$1]?"ÕAÏÑ":(y_j[$1]?"ÕKÒ" s:"ÖKÒ" s))) tulaj("/á", "µ", "Ç¿ß", "ç²Ãã") jaje_e($1,"/Q","/S/s") kulon($1) ju("·","»") ka("k") \
            "/W/Ì/¯/j" (y_i[$1]?"ÕBĞÑ":"ØMİÔ") tulaj("/í", "¶", "ÈÁÿ", "è³Åå") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","½") ka("l")
            next
}
/[aáoóuúAÁOÓUÚ]['bcdfghjklmnpqrstvwxyz£¥¦©ª«¬®¯³µ¶¹º»¼¾¿ÀÅÆÇÈÏĞÑÒØİŞßàåïğñòøış]+$/ { 
    if (magas[$1]==1) {
		s = fn_s[$1]?"nõ":"nò"
	    print $1 "/V/Ë/¯/j" (y_i[$1]?"ÕBĞÑ": "×LnÓ" s) tulaj("/é", "¶", "ÈÀà", "è³Ää") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","¼") ka("l") _s("ø")
    } else {
		s = fn_s[$1]?"mö":"mô"
	    print $1 "/U/Ê/®/i" (a[$1]?"$sÒ" s:(y_i[$1]?"ÕAÏÑ":(y_j[$1]?"ÕKÒ" s:"ÖKÒ" s))) tulaj("/á", "µ", "Ç¿ß", "ç²Ãã") jaje_e($1,"/Q","/S/s") kulon($1) ju("·","»") ka("k") _s("÷")
    }
}
/[iíeéIÍEÉYë]['bcdfghjklmnpqrstvwxyz£¥¦©ª«¬®¯³µ¶¹º»¼¾¿ÀÅÆÇÈÏĞÑÒØİŞßàåïğñòøış]+$/  || /Babe&0219;$/ { 
	s = fn_s[$1]?"nõ":"nò"
	s2 = fn_s[$1]?"mö":"mô"
    if (ingadozo[$1]==1) {
		print $1 "/U/V/Ê/®/Ë/¯/i/j" (y_i[$1]?"ÕABÏĞÑ":"Ö×KLÒÓ" s s2)  tulaj("/á/é", "µ¶", "Ç¿ßÈ", "çè²Ãã³Ää") jaje_e($1,"/Q/R","/T/t") kulon($1) ju("·","»") ju("¸","¼") ka("kl") _s("÷ø")
    } else {
	if (mely[$1]==1) {
	    print $1 "/U/Ê/®/i" (y_i[$1]?"ÕAÏÑ":"ÖKÒ" s2) tulaj("/á", "µ", "Ç¿ß", "ç²Ãã") jaje_e($1,"/Q","/S/s") kulon($1) ju("·","»") ka("k") _s("÷")
	} else { 
	    print $1 "/V/Ë/¯/j" (y_i[$1]?"ÕBĞÑ":"×LÓ" s) tulaj("/é", "¶", "ÈÀà", "è³Ää") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","¼") ka("l") _s("ø")
	}
    }
}
/[öõüûÖÕÜÛ]['bcdfghjklmnpqrstvxywz£¥¦©ª«¬®¯³µ¶¹º»¼¾¿ÀÅÆÇÈÏĞÑÒØİŞßàåïğñòøış]+$/ { 
    if (oe[$1]==1) {
	print $1 "/V/N/Ë/¯/j" "×LİòÔ" tulaj("/é", "¶", "ÈÀà", "è³Ää") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","¼") ka("l") _s("ø")
    } else {
	print $1 "/W/Ì/¯/j" (y_i[$1]?"ÕBĞÑ":"ØMİòÔ") tulaj("/í", "¶", "ÈÁÿ", "è³Åå") jaje_e($1,"/R","/T/t") kulon($1) ju("¸","½") ka("l") _s("ù")
    }
}
/[-]$/ {
    print $1 "/v/c"
}
