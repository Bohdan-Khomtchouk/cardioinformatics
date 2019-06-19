BIBDIR=bib-submission
bib-submission:
	mkdir -p $(BIBDIR)/figures && cd Briefings_in_Bioinformatics; cp main.tex cardio.bib bib.cls main.pdf unsrtnat.bst table*.tex table*.pdf biographical-note.pdf keypoint.pdf OUP_First_SBk_Bot_8401-eps-converted-to.pdf OUP_First_SBk_Bot_8401.eps ../$(BIBDIR)/ && xelatex -synctex=1 -interaction=nonstopmode  "main".tex;
	cp -L figures/figure*.png $(BIBDIR)/figures/
	cd $(BIBDIR); gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=single-file-submission.pdf keypoint.pdf biographical-note.pdf main.pdf;
	tar -czf $(BIBDIR).tar.gz $(BIBDIR)
clean:
	rm -rf $(BIBDIR) $(BIBDIR).tar.gz
    
