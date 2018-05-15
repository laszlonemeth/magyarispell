all: magyarispell.pdf

magyarispell.pdf: *.tex *.txt
	latex magyarispell.tex
	latex magyarispell.tex
	dvipdf magyarispell.dvi magyarispell.pdf

txt:
	@echo Kézikönyvoldalak egyszerû szöveges állománnyá alakítása
	man hunspell | col -x -b | tr ­ - | fold -s -w 65 >hunspell1.txt
	man 4 hunspell | col -x -b | tr ­ - | fold -w 65 >hunspell4.txt
	man hunstem | col -x -b | tr ­ - | fold -s -w 65 >hunstem1.txt
	man makedb | col -x -b | tr ­ - | fold -s -w 65 >makedb1.txt
	man lookdb | col -x -b | tr ­ - | fold -s -w 65 >lookdb1.txt
	test -f example.cxx && expand example.cxx >example.txt

clean:
	rm -f *.aux *.toc *.dvi *.pdf *.log

html:
	test -d magyarispell || mkdir magyarispell
	latex2html -up_title "Magyar Ispell dokumentáció" -down_title "" -split 4 -style magyar -html_version 3.2,latin2,unicode -local_icons magyarispell
	for i in magyarispell/*.html; do sed "s/\&#305;/í/g;s/Subsections//g;s/IMG WIDTH=[^ ]* /IMG /g;s/^dd$$//" $$i >$$i.tmp; mv $$i.tmp $$i; done
	for i in magyarispell/*.html; do sed "s/BLINK/SPAN/g;s/ffff00/ff9900/g" $$i >$$i.tmp; mv $$i.tmp $$i; done
	cp *.png magyarispell
