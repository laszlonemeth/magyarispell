#
# melléknevekbõl -ság/-ség fõnévképzõs alakok elõállítása
#
BEGIN {
    while ((getline var < "melleknev_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "melleknev_osszetett.1") > 0) { osszetett[gensub("(^[^	]*).*","\\1",1,var)]=1; }
}
{ossz=""}
osszetett[$1]==1{ossz="y"}
/ss$/ || /rs$/ || /lcs$/ { next }
(/[aáoóuú][bcdfghjklmnpqrstvwxyz]*$/ ||
/^[bcdfghjklmnpqrstvwxyz]*í[bcdfghjklmnpqrstvwxyz]*$/ ||
/^.*[uúoóaá][bcdfghjklmnpqrstvwxyz]*i[bcdfghjklmnpqrstvwxyz]*$/) && ! /^$/ &&
($1 != "fair") && ($1 != "unfair") && ($1 != "átvitt" && $1 != "ír") {
    print "[adj]" $1 "/°" ossz; next; }
! /^[ 	]*$/ { if (mely[$1]==1) { print "[adj]" $1 "/°" ossz }
    else { print "[adj]" $1 "/±" ossz; }
}
