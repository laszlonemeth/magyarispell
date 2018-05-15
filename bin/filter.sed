#!/bin/sed -f
:a s#<NOU\(.*\)>+*<NOUN#<NOU\1#;t a
:b s#<VER\(.*\)>+*<VERB#<VER\1#;t b
:c s#<AD\(.*\)>+*<ADJ#<AD\1#;t c
s#<AD\(.*\)>+*<NOUN#<AD\1[0]NOUN#
