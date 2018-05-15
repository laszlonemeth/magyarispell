# Kornai & Rebrus morfológiai kódolás prototípusa
# teszt: bin/morph2

WRKDIR=../tmp

all: h test

test:
	@#test -x hunmorph && ../hu_HU_morph2.aff ../hu_HU_morph2.dic test.txt >../tmp/test.out
	@#test -x hunmorph && diff test.morph ../tmp/test.out && echo 'Elemzés ellenõrizve.' || echo 'Hiba!'

h: hu
	@sed -f c1.sed $(WRKDIR)/hu.aff >../hu_HU_morph2.aff
	@sed -f c2.sed $(WRKDIR)/hu.dic >../hu_HU_morph2.dic

hu: ../hu_HU_morph.aff ../hu_HU_morph.dic
	@sed -f csere.txt ../hu_HU_morph.aff >$(WRKDIR)/hu.aff
	@sed -f csere.txt ../hu_HU_morph.dic >$(WRKDIR)/hu.dic

clean:
	rm $(WRKDIR)/h.aff $(WRKDIR)/h.dic $(WRKDIR)/hu.aff $(WRKDIR)/hu.dic
