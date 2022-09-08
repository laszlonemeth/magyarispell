# Magyar Ispell helyesírási szótár
# makefile v0.22 (2018-05-10)

#######################################################################
# Felhasználói beállítás

# KÖNYVTÁRAK
# célkönyvtárak prefixuma
PREFIX?=/usr
# ispell célkönyvtár; ide kerülnek: magyar.hash hungarian.hash magyar.aff
ISPELLDIR?=$(PREFIX)/lib/ispell
# myspell célkönyvtár; ide kerülnek:
# hu_HU.dic hu_HU.aff hungarian.dic hungarian.aff
HUNSPELLDIR?=$(PREFIX)/share/hunspell
# LibreOffice célkönyvtár: ide kerülnek: hu_HU.aff hu_HU.dic
LODIR?=$(USER)/libreoffice/dictionaries/hu_HU
# parancsok
INSTALL_DATA?=install
M4?=m4
CC?=cc
FLEX?=flex
AWK?=awk

# a szotar sikeres elkeszitesehez BOURNE kompatibilis shell kell!
# ilyenek a ksh, bash, zsh.
SH=/bin/sh

# Felhasználói beállítás vége
#######################################################################

# minimize dictionary diff based on the previous LibreOffice hu_HU dictionary
ifneq ("$(wildcard $(LODIR))","")
	MINIMIZE_OPTION="--minimize-diff"
	MINIMIZE_COMPRESSED_AFF_FILE=$(LODIR)/hu_HU.aff
endif

# gyökérkönyvtár
ROOTDIR=$(shell pwd)
# munkakönyvtar
WRKDIR=$(ROOTDIR)/tmp
# a szótárkönyvtár
SZOTAR=$(ROOTDIR)/szotar
# affix állományok
AFFDIR=$(ROOTDIR)/aff
# scriptek
BINDIR=$(ROOTDIR)/bin
# awk scriptek
AWKDIR=$(ROOTDIR)/awk
# szótárfájl
DICT=$(WRKDIR)/dictionary
# soremelés
EN=
EC=
ECHO_N=$(shell echo -n)
ifeq "$(ECHO_N)" ""
  EN=-n
else
  EC="\\c"
endif
CATUTF="$(BINDIR)/catutf"
CATUTF="cat"

# keresési útvonalak:
	vpath %.aff $(AFFDIR)
	vpath %.aff $(WRKDIR)
	vpath %.hash $(WRKDIR)
	vpath %.dict $(WRKDIR)
	vpath %.awk $(AWKDIR)

# ez a default target ha nincs megadva paraméter
default: myspell
	@cat $(ROOTDIR)/logo.txt | $(CATUTF)

# modulválasztós, menüs interfész
menu:
	@vi szotar.konf
	#@$(SH) bin/modul $(SZOTAR)
	make myspell

# munkakönyvtárak létrehozása
$(WRKDIR) $(LODIR) $(HUNSPELLDIR) $(ISPELLDIR):
	@mkdir -p $@

# hasítótábla létrehozása a megfelelő helyesírás-ellenőrzőhöz (Ispell/Myspell)
# magyar4X.hash ahol X={ispell,myspell}
magyar4ispell.hash: $(WRKDIR) magyar4ispell.dict magyar.aff
	@echo "===> Ispell ragozási szótár (magyar4ispell.hash)" | $(CATUTF)
	@buildhash $(WRKDIR)/magyar4ispell.dict $(WRKDIR)/magyar.aff \
	    $(WRKDIR)/magyar4ispell.hash 2> $(WRKDIR)/magyar4ispell.log

# szótár (.dic állomány) létrehozása a megfelelő helyesírás-ellenőrzőhöz (Ispell/Myspell)
# magyar4X.dict ahol X={ispell,myspell}
magyar4%.dict: $(WRKDIR)
	@echo "===> magyar $(*F) alapszótár (magyar4$(*F).dict) előállítása" | $(CATUTF)

	@echo "==> szimbolikus kötések létrehozása a szotar.konf alapján" | $(CATUTF)
	@$(SH) bin/makesymlink $(WRKDIR) szotar.konf

	@echo "==> szótárak egybemásolása" | $(CATUTF)
	@$(SH) bin/copydict $(WRKDIR) $(WRKDIR) $(*F)

	# hy: összetétel
	@cat  $(SZOTAR)/*/fonev_osszetett.1 | sed -n 's/	\(.*\)/[hy:\1]/p' | recode u8..l2 >>$(WRKDIR)/mezok.txt
	@cat  $(SZOTAR)/kivetelek/*/* $(WRKDIR)/*.modul/* | grep HY: | sed -n 's/[ 	].*HY:\([^ 	]*\).*/[hy:\1]/p' | recode u8..l2 >>$(WRKDIR)/mezok.txt
	@echo $(EN) ."$(EC)"

	@echo "==> igéből képzett alakok előállítása" | $(CATUTF)
	@$(SH) bin/igesgen $(ROOTDIR)

	@echo "==> igék" | $(CATUTF)
	@$(SH) bin/igek $(ROOTDIR)

# egyéb kivételek: az m4 miatt nem megy külön héjprogramba
	@echo "==> kivételek" | $(CATUTF)
	@cat $(SZOTAR)/kivetelek/igekotos/*.2* | recode u8..l2 \
		| LC_ALL=C grep -v ^# | $(M4) | LC_ALL=C $(AWK) -f $(AWKDIR)/tovek.awk -v param="/X" \
		>> $(DICT)
	@echo $(EN) ."$(EC)"
	@cat $(SZOTAR)/kivetelek/ragozatlan/*.1* | recode u8..l2 \
		| $(M4) | LC_ALL=C grep -v ^# | LC_ALL=C grep -v "#[A-Z]" \
		| LC_ALL=C sed 's/[	 ]*#.*$$//' | tr "\t" "\n" \
		>> $(DICT)
	@echo $(EN) ."$(EC)"
	@cat $(SZOTAR)/kivetelek/ragozatlan/*.1* | recode u8..l2 \
		| $(M4) | LC_ALL=C grep -v ^# | LC_ALL=C grep -i "#$(*F)" | LC_ALL=C sed 's/[	 ]*#.*$$//' \
		| tr "\t" "\n" \
		>> $(DICT)
	@echo $(EN) ."$(EC)"
	@cat $(SZOTAR)/kivetelek/ragozatlan/*.2* | recode u8..l2 | cat $(WRKDIR)/ragozatlan.2 /dev/stdin \
		| $(M4) | $(BINDIR)/field | LC_ALL=C grep -v ^# | LC_ALL=C grep -v "#[A-Z]" \
		| LC_ALL=C sed 's/[	 ]*#.*$$//' \
		| LC_ALL=C sed 's/\[[a-z][a-z]:[^\]*]//' \
		| LC_ALL=C $(AWK) -f $(AWKDIR)/tovek.awk \
		>> $(DICT)
	@echo $(EN) ."$(EC)"
	@cat  $(SZOTAR)/kivetelek/ragozatlan/*.2* | recode u8..l2 | cat $(WRKDIR)/ragozatlan.2 /dev/stdin \
		| $(M4) | $(BINDIR)/field | LC_ALL=C grep -v ^# | LC_ALL=C grep -i "#$(*F)" | LC_ALL=C sed 's/[	 ]*#.*$$//' \
		| LC_ALL=C sed 's/\[[a-z][a-z]:[^\]*]//' \
		| LC_ALL=C $(AWK) -f $(AWKDIR)/tovek.awk \
		>> $(DICT)
	@echo Rendben.

	@echo "==> névszók" | $(CATUTF)
	@$(SH) bin/fonevek $(ROOTDIR)

	@echo "==> morfológiai kódok" | $(CATUTF)
	@$(SH) bin/kodok $(ROOTDIR)

	@echo $(EN) ."$(EC)"

	@echo "==> tiltott szavak"
	@$(SH) bin/tiltott $(ROOTDIR) $(*F)

	@mv $(DICT) $(WRKDIR)/magyar4$(*F).dict
	@echo Rendben.

# ragozási táblázat (magyar.aff) előállítása
magyar.aff: $(WRKDIR) eleje.aff ige_alanyi.aff fonev.aff fonev_kepzo.aff ige_kepzo.aff
	@echo "===> ragozási táblázat (magyar.aff) előállítása" | $(CATUTF)
	@cd $(AFFDIR);\
	    cat eleje.aff ige_kepzo.aff fonev_kepzo.aff ige_morfo.aff ige_alanyi.aff \
            fonev.aff fonev_morfo.aff ige_targyas.aff | $(M4) > $(WRKDIR)/magyar.aff;

# ispell-installálás: magyar.hash, magyar.aff a helyére (ISPELLDIR könyvtár)
# a default értékkel csak rendszergazdaként tudjuk kiadni!
install_ispell: ispell $(ISPELLDIR)
	@echo "==> ispell állományok (magyar.aff magyar.hash) telepítése" | $(CATUTF)
	@echo "	célkönyvtár: $(ISPELLDIR)" | $(CATUTF)
	@$(INSTALL_DATA) $(WRKDIR)/magyar.aff $(ISPELLDIR)/magyar.aff
	@$(INSTALL_DATA) $(WRKDIR)/magyar4ispell.hash $(ISPELLDIR)/magyar.hash
# hungarian.aff link nem kell?
	@if [ ! -h $(ISPELLDIR)/hungarian.hash ]; then \
		ln -s magyar.hash $(ISPELLDIR)/hungarian.hash; \
	fi

# myspell-installálás: hu_HU.dic, hu_HU.aff a helyére (HUNSPELLDIR könyvtár)
# és kötések létrehozása
# a default értékkel csak rendszergazdaként tudjuk kiadni!
install_myspell: myspell $(HUNSPELLDIR)
	@echo "==> myspell állományok (hu_HU.dic és hu_HU.aff) telepítése" | $(CATUTF)
	@echo "	célkönyvtár: $(HUNSPELLDIR)" | $(CATUTF)

	@cp -f $(WRKDIR)/hu_HU.{dic,aff} $(HUNSPELLDIR)/
#
# magyar.aff -> hu_HU.aff kötés létrehozása
	@echo " myspell linkek ({magyar,hungarian}.{dic,aff}) létrehozása" | $(CATUTF)
	@if [ ! -h $(HUNSPELLDIR)/magyar.aff ]; then \
		ln -s hu_HU.aff $(HUNSPELLDIR)/magyar.aff; \
	fi
#
# magyar.dic -> hu_HU.dic kötés létrehozása
	@if [ ! -h $(HUNSPELLDIR)/magyar.dic ]; then \
		ln -s hu_HU.dic $(HUNSPELLDIR)/magyar.dic; \
	fi
#
# hungarian.aff -> hu_HU.aff kötés létrehozása
	@if [ ! -h $(HUNSPELLDIR)/hungarian.aff ]; then \
		ln -s hu_HU.aff $(HUNSPELLDIR)/hungarian.aff; \
	fi
#
# hungarian.dic -> hu_HU.dic kötés létrehozása
	@if [ ! -h $(HUNSPELLDIR)/hungarian.dic ]; then \
		ln -s hu_HU.dic $(HUNSPELLDIR)/hungarian.dic; \
	fi

install_OO: myspell $(LODIR)
	@echo "Hunspell szótárállományok (hu_HU.dic és hu_HU.aff) telepítése" | $(CATUTF)
	@echo "	célkönyvtár: $(LODIR)" | $(CATUTF)
	@$(INSTALL_DATA) $(WRKDIR)/hu_HU.{dic,aff} $(LODIR)

install: install_all

install_all: install_myspell install_ispell install_OO

# ispell opcióval kompilált hashtábla
#ispell: magyar4ispell.hash

# hu_HU.aff myspell ragozási táblázat és a hu_HU.dic szótár előállítása
myspell: magyar4myspell.dict magyar.aff hu_HU.aff hu_HU.dic alias kr

# - hu_HU.aff myspell ragozási táblázat előállítása az összes
#   lehetséges cserebetűvel
# a myspellhez előállított magyar.aff állományhoz
hu_HU.aff: magyar.aff
	@echo "===> myspell ragozási táblázat (hu_HU.aff) előállítása" | $(CATUTF)
	@$(SH) bin/i2myspell $(WRKDIR)/magyar.aff HUNSPELL_heading \
		A-ZÁÉÍÓÖŐÚÜŰ a-záéíóöőúüű | sed 's/q\([^[]*\]\)/-\1/' | \
                bin/newsyntax >$(ROOTDIR)/hu_HU_morph.aff
	@cat $(ROOTDIR)/hu_HU_morph.aff | bin/aff2gen | \
	        sed 's/&i[ua]grave;//g;s/&oslash;//g' >$(ROOTDIR)/hu_HU_gen.aff
	@cat $(ROOTDIR)/hu_HU_gen.aff | \
		LC_ALL=C sed 's/\t\([^p].\|.[^h]\):[^\t]*//g' >$(ROOTDIR)/hu_HU.aff

# q kötőjellé alakítva a szabályokban

# hu_HU.dic szótár előállítása
# a myspellhez előállított hashtáblából (magyar4myspell.hash)
hu_HU.dic: magyar.aff
	@echo "===> myspell szótár (hu_HU.dic) előállítása" | $(CATUTF)
	@$(SH) bin/i2myspell -d $(WRKDIR)/magyar4myspell.dict | \
	    bin/lemma_present | bin/quniq >$(ROOTDIR)/hu_HU_morph.dic
	@cat $(ROOTDIR)/hu_HU_morph.dic | \
	    bin/dic2gen $(WRKDIR)/mezok2.txt >$(ROOTDIR)/hu_HU_gen.dic
	@cat hu_HU_gen.dic | \
	    sed 's/\t\([^p].\|.[^h]\):[^\t]*//g' >$(ROOTDIR)/hu_HU.dic

u8: hu_HU.aff hu_HU.dic
	@echo "===> Unicode karakterkódolású állományok előállítása" | $(CATUTF)
	@bin/u8myspell $(ROOTDIR)/hu_HU_morph $(WRKDIR)/hu_HU_u8_morph l2
	@cat $(WRKDIR)/hu_HU_u8_morph.dic | sed 's#	/#/#' >$(ROOTDIR)/hu_HU_u8_morph.dic
	@mv $(WRKDIR)/hu_HU_u8_morph.aff $(ROOTDIR)
	@cat $(ROOTDIR)/hu_HU_u8_morph.dic | \
	    bin/dic2gen $(WRKDIR)/mezok_utf.txt >$(ROOTDIR)/hu_HU_u8_gen.dic
	@cat hu_HU_u8_gen.dic | \
	    sed 's/\t\([^p].\|.[^h]\):[^\t]*//g' >$(ROOTDIR)/hu_HU_u8.dic
	@cat $(ROOTDIR)/hu_HU_u8_morph.aff | \
	    bin/aff2gen >$(ROOTDIR)/hu_HU_u8_gen.aff
	@cat hu_HU_u8_gen.aff | \
	    sed 's/\t\([^p].\|.[^h]\):[^\t]*//g' >$(ROOTDIR)/hu_HU_u8.aff

alias: u8
	@echo "===> Tömörített Hunspell szótárak elkészítése" | $(CATUTF)
	@LC_ALL=C $(SH) bin/makealias $(ROOTDIR)/hu_HU_u8.dic $(ROOTDIR)/hu_HU_u8.aff
	@LC_ALL=C $(SH) bin/makealias $(MINIMIZE_OPTION) $(MINIMIZE_COMPRESSED_AFF_FILE) $(ROOTDIR)/hu_HU_u8_gen.dic $(ROOTDIR)/hu_HU_u8_gen.aff

kr: hu_HU.aff hu_HU.dic u8
	@cd kr; make

# minden komponens kompilálása
all: ispell myspell

# új modul létrehozása
new:
	@echo "==> új modul létrehozása" | $(CATUTF)
	@$(SH) bin/modul $(SZOTAR) uj

check:
	bin/check

# takarítás
clean:
	-rm -rf $(WRKDIR) *~ $(ROOTDIR)/hu_*

# a modulválasztás defaultra való visszaállítása
# a kizárandó modulok explicite megadandók az "if"-ben
distclean:
	@for DIR in `find $(SZOTAR) -type d -name "_?*" -maxdepth 1 -noleaf`; do \
		MODULE_LOWER=`echo $(EN) $${DIR}"$(EC)" | sed 's/^.*\/_//'`; \
		MODULE=`echo $(EN) $${MODULE_LOWER}"$(EC)" | sed 's/^\(.\).*/\1/' | \
		tr a-z A-Z; \
		echo $(EN) $${MODULE_LOWER}"$(EC)" | sed 's/^.\(.*\)/\1/'`; \
		if [ "$${MODULE}" = "Huhyph2" ]; then \
			for LINK in `find $(SZOTAR) -type l -name "[A-Z]*" \
			-lname _$${MODULE_LOWER} -maxdepth 1 -noleaf`; do \
				rm -f $${LINK}; \
			done; \
		else \
			ln -s -f -n _$${MODULE_LOWER} $(SZOTAR)/$${MODULE}; \
		fi; \
	done

distbin:
	make clean
	pwd=$$(pwd); cd ..; tar cv --exclude-vcs $$(basename $$pwd) | gzip >$$pwd.tar.gz
