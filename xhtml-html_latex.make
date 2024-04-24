#!/usr/bin/env make
#
# Generate HTML and PDF (via LaTeX) output from XHTML input with some custom
# extensions for bibliography, etc.
# 
# Andrew Cashner, 2023/09/25
#
# Generate html: 	`make html`
# Generate pdf: 	`make pdf`
# Generate both: 	`make all` or `make`
# View html: 		`make view`
# View pdf: 		`make view-pdf`
# Reset, start fresh: 	`make clean`

# Requirements
# - Installed and available on path: saxon, biber, latexmk & TeXLive
# - In project directory: 
#   	- BibLaTeX bibliography file or symlink to one, *.bib
#   	- The stylesheets in this directory (check the xsl_dir path below)

# TODO
# find and copy css
# copy media files
# make xsl_dir configurable

dirs 		= aux build
xhtml_in 	= $(wildcard *.xhtml)
xhtml_include   = $(wildcard include/*.xhtml)
bib		= $(wildcard *.bib)

bibxml		= $(addprefix aux/,$(bib:%.bib=%.bltxml))
biber_log	= $(bibxml:%.bltxml=%.blg)

tex		= $(addprefix aux/,$(xhtml_in:%.xhtml=%.tex))

html_out        = $(addprefix build/,$(xhtml_in:%.xhtml=%.html))
pdf_out		= $(html_out:%.html=%.pdf)

xsl_dir         = $(HOME)/lib/xsl
saxon-html      = saxon -xi:on -xsl:$(xsl_dir)/xhtml-html/main.xsl
saxon-latex     = saxon -xi:on -xsl:$(xsl_dir)/xhtml-latex/main.xsl

biber-xml       = biber --tool --output-format=biblatexml \
			--output-resolve-crossrefs --no-bltxml-schema \
			--logfile $(biber_log)

# Define variable TEX to change latex engine
# - On command line: `make TEX=xe` or `TEX=lua`
# 	- For pdflatex, leave blank (`TEX=""` to reset)
# - In Makefile: `TEX=xe; include $(this_makefile)`
latexmk = latexmk -outdir=aux

ifeq ($(TEX),xe)
	makelatex = $(latexmk) -pdfxe
else ifeq ($(TEX),lua)
	makelatex = $(latexmk) -pdflua
else
	makelatex = $(latexmk) -pdf
endif

.PHONY: all html pdf view view-pdf clean

.SECONDARY : $(tex)

all : html pdf

html : $(html_out)

pdf : $(pdf_out)

$(dirs) :
	mkdir -p $(dirs)

aux/%.bltxml : %.bib | $(dirs)
	$(biber-xml) -O $@ $<


# xhtml -> html
build/%.html : %.xhtml $(xhtml_include) $(bibxml) | $(dirs)
	$(saxon-html) -s:$< -o:$@

# xhtml -> latex -> pdf
build/%.pdf : aux/%.pdf
	cp -u $< $@

aux/%.pdf : aux/%.tex $(bib)
	$(makelatex) $<

aux/%.tex : %.xhtml $(xhtml_include) $(bibxml) | $(dirs)
	$(saxon-latex) -s:$< -o:$@

view : $(html_out)
	xdg-open $^ &

view-pdf : $(pdf_out)
	xdg-open $^ &

clean : 
	rm -rf $(dirs)

