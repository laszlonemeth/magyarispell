#
# tövek felvétele kivételekhez a kivetelek könyvtárból
#
/	/ {
    c = index($1, "/");
    if (c == 0) {
	# print $1 "/0g" param
	print $1 param
	if ($3 == "") {
	    print $1 "\t" $2
	} else {
	    print $1 "\t" $2 " " $3
	}
    } else {    
	# print substr($1, 1, c-1) "/0g" substr($1, c) param
	# print substr($1, 1, c-1) "/0g" substr($1, c) param
	print substr($1, 1, c-1) "/" substr($1, c) param
	if ($3 == "") {
            print substr($1, 1, c-1) "\t" $2
	} else {
	    print substr($1, 1, c-1) "\t" $2 " " $3
	}
    }
    next
}
/^$/ { next }
{ print $1 param }
