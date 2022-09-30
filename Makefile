BUILDDIR=outputs
SOURCES=$(wildcard examples/*.py)
ASCIINEMA_SOURCES=$(wildcard asciinema/*.cast)
PLANTUML_SOURCES=$(wildcard images/*.plantuml)
PLANTUML_TARGETS=$(patsubst images/%.plantuml,images/%.png,$(PLANTUML_SOURCES))
TXT_TARGETS=$(patsubst examples/%.py,$(BUILDDIR)/%.output.txt,$(SOURCES))
CAST_TARGETS=$(patsubst examples/%.py,$(BUILDDIR)/%.cast,$(SOURCES))
GIF_TARGETS=$(patsubst $(BUILDDIR)/%.cast,$(BUILDDIR)/%.gif,$(CAST_TARGETS)) \
	$(patsubst asciinema/%.cast,$(BUILDDIR)/%.gif,$(ASCIINEMA_SOURCES))
MP4_TARGETS=$(patsubst $(BUILDDIR)/%.gif,$(BUILDDIR)/%.mp4,$(GIF_TARGETS))
FONT_FAMILY=MesloLGS Nerd Font Mono,JetBrains Mono,Fira Code,SF Mono,Menlo,Consolas,DejaVuSans Mono,Liberation Mono
AGG_BIN=build/agg/target/release/agg
AGG=$(AGG_BIN) --idle-time-limit 1 --font-size 18 --no-loop --font-family "$(FONT_FAMILY)"
QR_CODE=images/slides-qr-code.png

.PHONY: all
all: $(TXT_TARGETS) $(CAST_TARGETS) $(GIF_TARGETS) $(PLANTUML_TARGETS) $(QR_CODE) $(MP4_TARGETS)

$(TXT_TARGETS): | $(BUILDDIR)  # build the build directory first

$(BUILDDIR):
	mkdir $(BUILDDIR)

$(BUILDDIR)/%.output.txt: examples/%.py
	python $< > $@

$(BUILDDIR)/%.cast: examples/%.py
	asciinema rec --overwrite --rows 40 --cols 80 --command "python $<" $@

$(BUILDDIR)/%.gif: $(BUILDDIR)/%.cast $(AGG_BIN)
	$(AGG) $< $@

$(BUILDDIR)/%.gif: asciinema/%.cast $(AGG_BIN)
	$(AGG) $< $@

$(BUILDDIR)/%.mp4: $(BUILDDIR)/%.gif
	ffmpeg -i $< -y -vf "crop='iw-mod(iw,2)':'ih-mod(ih,2)',format=yuv420p" -an $@

images/%.png: images/%.plantuml
	plantuml $<

build/agg/Cargo.lock:
	git clone git@github.com:asciinema/agg.git build/agg

$(AGG_BIN): build/agg/Cargo.lock
	cd build/agg && cargo build --release

.PHONY: clean-gif
clean-gif:
	rm $(GIF_TARGETS)

$(QR_CODE):
	segno -o $@ --scale 10 --dpi 300 "https://github.com/micktwomey/exploring-boto3-events-with-mitmproxy"
