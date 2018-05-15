:a s#<NOU\(.*\)>+*<NOUN#<NOU\1#;t a
:b s#<VER\(.*\)>+*<VERB#<VER\1#;t b
s#~##g;
s#[a-zA-ZöüóõúéáûíÖÜÓÕÚÉÁÛÍ]*_\([/(),A-Z]*\)_noun]#\1]/NOUN#g;
s#[a-zA-ZöüóõúéáûíÖÜÓÕÚÉÁÛÍ]*_\([/(),A-Z]*\)_vrb]#\1]/VERB#g;
s#[a-zA-ZöüóõúéáûíÖÜÓÕÚÉÁÛÍ]*_\([/(),A-Z]*\)_vrb_tr]#\1]/VERB#g;
s#[a-zA-ZöüóõúéáûíÖÜÓÕÚÉÁÛÍ]*_\([/(),A-Z]*\)_adj]#\1]/ADJ#g;
s#[a-zA-ZöüóõúéáûíÖÜÓÕÚÉÁÛÍ]*_\([/(),A-Z]*\)_vrb]#\1]/VERB#g;
s#[a-zA-ZöüóõúéáûíÖÜÓÕÚÉÁÛÍ]*_\([/(),A-Z]*\)_vrb_it]#\1]/VERB#g;
s#[a-zA-ZöüóõúéáûíÖÜÓÕÚÉÁÛÍ]*_\([/(),A-Z]*\)_adv]#\1]/ADV#g;
s#[a-zA-ZöüóõúéáûíÖÜÓÕÚÉÁÛÍ]*_\([/(),A-Z]*\)_(noun,adj)]#DIMIN]/NOUN#g;
s#[a-zA-ZöüóõúéáûíÖÜÓÕÚÉÁÛÍ]*_\([/(),A-Z]*\)_num]#\1]/NUM#g;
s#[a-zA-ZöüóõúéáûíÖÜÓÕÚÉÁÛÍ]*_\([/(),A-Z]*\)_(adj,present_part)]#MODAL_PART]/ADJ/ADJ#g;
s#PASTPART#PERF_PART#g;
s#FUTPART#FUT_PART#g;
s#PRESPART#IMPERF_PART#g;
s#/[&(]	#	#;
	