OLDVERSION=../bib-submission/main.tex
CURVERSION=main.tex
DIFFVER=diff-main.tex
main:
	xelatex -synctex=1 -interaction=nonstopmode ${CURVERSION}
	bibtex main.aux
	xelatex -synctex=1 -interaction=nonstopmode ${CURVERSION}
	xelatex -synctex=1 -interaction=nonstopmode ${CURVERSION}
all: main diff table
table:
	pdflatex -synctex=1 -interaction=nonstopmode table-resources.tex
	pdflatex -synctex=1 -interaction=nonstopmode table-dbgapSubject.tex
diff:
	latexdiff ${OLDVERSION} ${CURVERSION} > ${DIFFVER}
	xelatex -synctex=1 -interaction=nonstopmode ${DIFFVER}
	bibtex diff-main.aux
	xelatex -synctex=1 -interaction=nonstopmode ${DIFFVER}
	xelatex -synctex=1 -interaction=nonstopmode ${DIFFVER}
clean:
	rm -rf annot.log annot.pdf annot.blg annot.bbl annot.aux annot.bcf annot.run.xml
	rm -rf main.log main.pdf main.blg main.bbl main.aux main.synctex* 
	rm -rf diff-main.log diff-main.pdf diff-main.blg diff-main.bbl diff-main.aux diff-main.synctex* 
	rm -rf table-*.log table-*.pdf table-*.blg table-*.bbl table-*.aux table-*.synctex* 
