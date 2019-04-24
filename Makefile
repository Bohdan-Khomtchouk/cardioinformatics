BIBDIR=bib-submission
bib-submission:
	mkdir -p $(BIBDIR)/figures && cd Briefings_in_Bioinformatics; cp main.tex cardio.bib bib.cls main.pdf unsrtnat.bst table*.tex table*.pdf OUP_First_SBk_Bot_8401-eps-converted-to.pdf OUP_First_SBk_Bot_8401.eps ../$(BIBDIR)/
	cp -L figures/figure*.png $(BIBDIR)/figures/
	tar -czf $(BIBDIR).tar.gz $(BIBDIR)
clean:
	rm -rf $(BIBDIR) $(BIBDIR).tar.gz
    
