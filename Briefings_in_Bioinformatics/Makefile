OLDVERSION_PREFIX=../bib-submission/main.tex
CURVERSION_PREFIX=main
DIFFVER_PREFIX=diff-main.tex
table:
	pdflatex -synctex=1 -interaction=nonstopmode table-resources.tex
	pdflatex -synctex=1 -interaction=nonstopmode table-dbgapSubject.tex
main:
	xelatex -synctex=1 -interaction=nonstopmode $(CURVERSION_PREFIX).tex
	bibtex $(CURVERSION_PREFIX)
	xelatex $(CURVERSION_PREFIX).tex
all: main diff table
diff:
	latexdiff $(OLDVERSION_PREFIX) $(CURVERSION_PREFIX).tex > $(DIFFVER_PREFIX)
	xelatex -synctex=1 -interaction=nonstopmode $(DIFFVER_PREFIX)
	bibtex diff-main.aux
	xelatex -synctex=1 -interaction=nonstopmode $(DIFFVER_PREFIX)
clean:
	rm -rf annot.log annot.pdf annot.blg annot.bbl annot.aux annot.bcf annot.run.xml
	rm -rf main.log main.pdf main.blg main.bbl main.aux main.synctex* 
	rm -rf diff-main.log diff-main.pdf diff-main.blg diff-main.bbl diff-main.aux diff-main.synctex* 
	rm -rf table-*.log table-*.pdf table-*.blg table-*.bbl table-*.aux table-*.synctex* 
