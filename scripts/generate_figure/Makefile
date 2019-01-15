REXEC=Rscript

all: fig1 fig2

fig1: fig1a fig1bc
	$(REXEC) 1A-who.R

fig1a:
	$(REXEC) 1A-who.R

fig1bc:
	$(REXEC) 1BC-pubmed.R

fig2:
	$(REXEC) 2-hpo-gene-count.R
	 
clean:
	rm *.png

