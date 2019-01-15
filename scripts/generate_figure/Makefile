REXEC=Rscript

all: fig1 fig2 fig3 fig4

fig1: fig1a fig1bc
	$(REXEC) 1A-who.R

fig1a:
	$(REXEC) 1A-who.R
fig1bc:
	$(REXEC) 1BC-pubmed.R
fig2:
	$(REXEC) 2-hpo-gene-count.R
fig3:
	$(REXEC) 3-variant-contexts.R
fig4:
	$(REXEC) 4-assay-count.R

	 
clean:
	rm *.png

