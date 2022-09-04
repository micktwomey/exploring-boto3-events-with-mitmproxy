BUILDDIR=outputs
SOURCES=$(wildcard examples/*.py)
TXT_TARGETS=$(patsubst examples/%.py,$(BUILDDIR)/%.output.txt,$(SOURCES))
CAST_TARGETS=$(patsubst examples/%.py,$(BUILDDIR)/%.cast,$(SOURCES))
GIF_TARGETS=$(patsubst $(BUILDDIR)/%.cast,$(BUILDDIR)/%.gif,$(CAST_TARGETS))

all: $(TXT_TARGETS) $(CAST_TARGETS) $(GIF_TARGETS)

$(TXT_TARGETS): | $(BUILDDIR)  # build the build directory first

$(BUILDDIR):
	mkdir $(BUILDDIR)

$(BUILDDIR)/%.output.txt: examples/%.py
	python $< > $@

$(BUILDDIR)/%.cast: examples/%.py Makefile
	asciinema rec --overwrite --rows 40 --cols 80 --command "python $<" $@

$(BUILDDIR)/%.gif: $(BUILDDIR)/%.cast
	agg $< $@
