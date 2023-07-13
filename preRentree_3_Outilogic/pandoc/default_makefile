CONVERTER = pandoc
COURSE_DIR = $(CURDIR)/../../..
PANDOC_DIR = $(COURSE_DIR)/pandoc
TEMPLATES = $(PANDOC_DIR)/templates
FILTERS = $(PANDOC_DIR)/filters
TEXMF = $(COURSE_DIR)/latex
HTML_DEPS = $(FILTERS)/exercise.py $(TEMPLATES)/moodle.html5
TEX_DEPS = $(FILTERS)/exercise.bis.py $(FILTERS)/includes.py $(TEMPLATES)/linfo.latex
BEAMER_DEPS = $(TEMPLATES)/linfo.beamer

TARGETS = $(patsubst %.md, %.pdf, $(wildcard *.md))

COMMON_OPTS = \
	-s \
	-f markdown \
	-F $(FILTERS)/includes.py\
	-F $(FILTERS)/exercise.bis.py

HTML_OPTS = \
	-t html5 \
	--template=$(TEMPLATES)/moodle.html5 \
	--base-header-level=3

TEX_OPTS = \
	-t latex \
	--pdf-engine=lualatex \
	--template=$(TEMPLATES)/linfo.latex \
	--number-sections \
	-V tikz
	 # -V documentclass=linfo

BEAMER_OPTS = \
	-s \
	-f markdown \
	-t beamer \
	--pdf-engine=lualatex \
	--template=$(TEMPLATES)/linfo.beamer \
	--pdf-engine-opt=-shell-escape \
	-V minted -V tikz -V fontsize=12pt

LATEXMK_OPTS = \
	-r $(TEXMF)/latexmkrc \
	-e "\$$ENV{'TEXINPUTS'}='$(TEXMF):'"

.PHONY:	default clean cleanall FORCE_MAKE
.PRECIOUS: %.tex

%.html: %.md $(HTML_DEPS)
	$(CONVERTER) $(COMMON_OPTS) $(HTML_OPTS) $< -o $@

%.pdf: %.tex $(FORCE_MAKE)
	latexmk $(LATEXMK_OPTS) $<

%.tex: %.md $(TEX_DEPS)
	$(CONVERTER) $(COMMON_OPTS) $(TEX_OPTS) $< -o $@	

%.corr.pdf:  %.corr.tex $(FORCE_MAKE)
	latexmk $(LATEXMK_OPTS) $<

%.corr.tex: %.md $(TEX_DEPS)
	$(CONVERTER) -M correction=true $(COMMON_OPTS) $(TEX_OPTS) $< -o $@	

%.slides.tex: %.md $(BEAMER_DEPS)
	$(CONVERTER) $(COMMON_OPTS) $(BEAMER_OPTS) $< -o $@

ifneq "$(TARGETS)" ""
default: $(TARGETS)
else
default:
	@echo "Donner un nom de fichier à construire : <nom>.{html,tex,pdf}"
	@echo "Le fichier <nom>.md doit exister dans le répertoire."
endif

clean:
	-latexmk -c
	-rm -i *.tex

cleanall: clean
	-rm -i *.pdf
