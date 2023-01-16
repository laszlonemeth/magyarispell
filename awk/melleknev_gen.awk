#
# melléknevek ragozási csoportba sorolása
# 
BEGIN { 
    while ((getline var < "melleknev_a.1") > 0) { a_kotohangzo[var]=1; }
    while ((getline var < "melleknev_e.1") > 0) { e_kotohangzo[var]=1; }
    while ((getline var < "melleknev_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "melleknev_magas.1") > 0) { magas[var]=1; }
    while ((getline var < "melleknev_ing.1") > 0) { ingadozo[var]=1; }
    while ((getline var < "melleknev_jaje.1") > 0) { jaje[var]=1; }
    while ((getline var < "melleknev_ae.1") > 0) { ae[var]=1; }
    while ((getline var < "melleknev_jajeae.1") > 0) { jajeae[var]=1; }
    while ((getline var < "melleknev_oe.1") > 0) { oe[var]=1; }
    while ((getline var < "fonev_s.1") > 0) { fn_s[var]=1; }
}

function a_koto(szo,kapcsolo) {
    if (a_kotohangzo[szo]==1) { 
        return "";
    } else if (e_kotohangzo[szo]==1) {
	return "/N";
    } else {
        return kapcsolo;
    }
}

function jaje_e(st,j,nemj) {
if (jaje[st]==1) {return j;} else {
if (ae[st]==1) {return nemj;} else {
if (jajeae[st]==1) {return j nemj; } else {
if (match(st,"[chjmsxyvz]$")!=0) { return nemj;}
  else {return j;}  
}}}}

# -ka, -ke kicsinyítõképzõ:
# a szó nem összetett, és legalább két szótagú
function ka(s) {
    if (!osszetett[$1] && $1~/[aáeéiíoóöõuúüûAÁEÉIÍOÓÖÕUÚÜÛ].*[aáeéiíoóöõuúüû]/) return s
    return ""
}

/[aáoóuú]$/ { print "[adj]" $1 "/AÒÕÏ/F/U/Î/Q" }
/[öõüû]$/ { print "[adj]" $1 "/CÔÕŞ/H/W/Ì/R" }
/[eéií]$/ { if (mely[$1]==1) {print "[adj]" $1 "/AÒÕÏ/F/U/Î/Q"; next } 
    else {print "[adj]" $1 "/BÓÕĞ/G/V/Ë/R"; next } }

(magas[$1]!=1 && (/[aáoóuú][-bcdfghjklmnpqrstvwxyz]+$/ ||
/^.*[uúoóaá][bcdfghjklmnpqrstvwxyz]*i[bcdfghjklmnpqrstvwxyz]+$/)) {
    s = fn_s[$1]?"ö":"mô"
    print "[adj]" $1 "/ÒÙ/F/U/Î" s a_koto($1,"/KÖ") jaje_e($1,"/Q","/S/s") ka("k"); next }

/[iíeéa][-bcdfghjklmnpqrstvwxyz]+$/ {
  s = fn_s[$1]?"õ":"nò"
  s2 = fn_s[$1]?"ö":"mô"
  if (mely[$1]==1) {print "[adj]" $1 "/ÒÙ/F/U/Î" s2 a_koto($1,"/KÖ") jaje_e($1,"/Q","/S/s") ka("k")} 
  else { 
     if (ingadozo[$1]==1) { 
        print "[adj]" $1 "/ÒÙ/F/U/Î" s2 a_koto($1,"/KÖ") jaje_e($1,"/Q","/S/s") "/Ó×/G/V/Ë" s a_koto($1,"/L") jaje_e($1,"/R","/T/t") ka("kl") }
     else { print "[adj]" $1 "/Ó×/G/V/Ë" s a_koto($1,"/L") jaje_e($1,"/R","/T/t") ka("l")}
  }
}

/[öõüû][bcdfghjklmnprstvxyz]+$/ { 
  print "[adj]" $1 "/Ô×İò/G/V/Ì/N" a_koto($1,"/M") jaje_e($1,"/R","/T/t") ka("l"); 
}
