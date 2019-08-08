WORKDIR=Briefings_in_Bioinformatics
# BIBDIR=bib-submission-r1
BIBDIR=bib-submission-r2

submission:
	mkdir -p $(BIBDIR)/figures;
	cp supp/* $(BIBDIR)/;
	cd $(WORKDIR) && cp main.tex cardio.bib bib.cls main.pdf unsrtnat.bst table*.tex table*.pdf biographical-note.pdf keypoint.pdf OUP_First_SBk_Bot_8401-eps-converted-to.pdf OUP_First_SBk_Bot_8401.eps diff-main.tex diff-main.pdf Makefile ../$(BIBDIR)/
	cp -L figures/figure*.png $(BIBDIR)/figures/
# 	cd $(BIBDIR); make all;
	cd $(BIBDIR); gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=single-file-submission.pdf keypoint.pdf biographical-note.pdf main.pdf;
	tar -czf $(BIBDIR).tar.gz $(BIBDIR)
clean:
	rm -rf $(BIBDIR) $(BIBDIR).tar.gz
