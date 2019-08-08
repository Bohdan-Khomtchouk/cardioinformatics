OLDVERSION_PREFIX=../bib-submission-r1/main.tex
CURVERSION_PREFIX=main
DIFFVER_PREFIX=diff-main.tex
main:
	xelatex -synctex=1 -interaction=nonstopmode $(CURVERSION_PREFIX).tex
	bibtex $(CURVERSION_PREFIX)
	xelatex -synctex=1 -interaction=nonstopmode $(CURVERSION_PREFIX).tex
	xelatex -synctex=1 -interaction=nonstopmode $(CURVERSION_PREFIX).tex
all: main diff table
table: table1 table2
table1:
	xelatex -synctex=1 -interaction=nonstopmode table-resources.tex
	bibtex table-resources
	xelatex -synctex=1 -interaction=nonstopmode table-resources.tex
	xelatex -synctex=1 -interaction=nonstopmode table-resources.tex
table2:
	pdflatex -synctex=1 -interaction=nonstopmode table-dbgapSubject.tex
diff:
	latexdiff $(OLDVERSION_PREFIX) $(CURVERSION_PREFIX).tex > $(DIFFVER_PREFIX)
	xelatex -synctex=1 -interaction=nonstopmode $(DIFFVER_PREFIX)
	bibtex diff-main.aux
	xelatex -synctex=1 -interaction=nonstopmode $(DIFFVER_PREFIX)
	xelatex -synctex=1 -interaction=nonstopmode $(DIFFVER_PREFIX)
clean:
	rm -rf annot.log annot.pdf annot.blg annot.bbl annot.aux annot.bcf annot.run.xml annot.out
	rm -rf main.log main.pdf main.blg main.bbl main.aux main.synctex*  main.out
	rm -rf diff-main.log diff-main.pdf diff-main.blg diff-main.bbl diff-main.aux diff-main.synctex*  diff-main.out
	rm -rf table-*.log table-*.pdf table-*.blg table-*.bbl table-*.aux table-*.synctex*  table-*.out
