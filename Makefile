BUILDDIR=outputs
SOURCES=$(wildcard examples/*.py)
ASCIINEMA_SOURCES=$(wildcard asciinema/*.cast)
TXT_TARGETS=$(patsubst examples/%.py,$(BUILDDIR)/%.output.txt,$(SOURCES))
CAST_TARGETS=$(patsubst examples/%.py,$(BUILDDIR)/%.cast,$(SOURCES))
GIF_TARGETS=$(patsubst $(BUILDDIR)/%.cast,$(BUILDDIR)/%.gif,$(CAST_TARGETS)) \
	$(patsubst asciinema/%.cast,$(BUILDDIR)/%.gif,$(ASCIINEMA_SOURCES))
FONT_FAMILY=MesloLGS Nerd Font Mono,JetBrains Mono,Fira Code,SF Mono,Menlo,Consolas,DejaVuSans Mono,Liberation Mono
AGG=agg --font-family "$(FONT_FAMILY)"

all: $(TXT_TARGETS) $(CAST_TARGETS) $(GIF_TARGETS)

$(TXT_TARGETS): | $(BUILDDIR)  # build the build directory first

$(BUILDDIR):
	mkdir $(BUILDDIR)

$(BUILDDIR)/%.output.txt: examples/%.py
	python $< > $@

$(BUILDDIR)/%.cast: examples/%.py
	asciinema rec --overwrite --rows 40 --cols 80 --command "python $<" $@

$(BUILDDIR)/%.gif: $(BUILDDIR)/%.cast
	$(AGG) $< $@

$(BUILDDIR)/%.gif: asciinema/%.cast
	$(AGG) $< $@
