# Makefile for Belief and Reason(BAR) Documentation
# Author: Joseph Cayouette

SHELL = bash

# BAR Productname and file replacement
PRODUCTNAME_BAR ?= 'BAR'
FILENAME_BAR ?= bar

# PDF Resource Locations
PDF_FONTS_DIR ?= branding/pdf-resources/fonts
PDF_THEME_DIR ?= branding/pdf-resources/themes

# BAR PDF Themes
# Available Choices set variable
# bar-draft
# bar

PDF_THEME_BAR ?= bar

REVDATE ?= "$(shell date +'%B %d, %Y')"
CURDIR ?= .

# Build directories for TAR
HTML_BUILD_DIR ?= build
PDF_BUILD_DIR ?= build/pdf

# BAR OBS Tarball Filenames
HTML_OUTPUT_BAR ?= bar-docs_en
PDF_OUTPUT_BAR ?= bar-docs_en-pdf



# Help Menu
PHONY: help
help: ## Prints a basic help menu about available targets
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
	printf "%-30s %s\n" "target" "help" ; \
	printf "%-30s %s\n" "------" "----" ; \
	for help_line in $${help_lines[@]}; do \
		IFS=$$':' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf '\033[36m'; \
		printf "%-30s %s" $$help_command ; \
		printf '\033[0m'; \
		printf "%s\n" $$help_info; \
	done


# Clean up build artifacts
.PHONY: clean
clean: ## Remove build artifacts from output directory (Antora and PDF)
	-rm -rf build/ .cache/ public/


# BAR DOCUMENTATION BUILD COMMANDS

.PHONY: bar
bar: clean ## Build the BAR Antora static site (See README for more information)
	docker run -u 1000 -v `pwd`:/antora --rm -t antora/antora --cache-dir=./.cache/antora site.yml



# BAR
.PHONY: obs-packages-bar
obs-packages-bar: clean pdf-all bar ## Generate bar OBS tar files
	tar --exclude='$(PDF_BUILD_DIR)' -czvf $(HTML_OUTPUT_BAR).tar.gz $(HTML_BUILD_DIR)
	tar -czvf $(PDF_OUTPUT_BAR).tar.gz $(PDF_BUILD_DIR)
	mkdir build/packages
	mv $(HTML_OUTPUT_BAR).tar.gz $(PDF_OUTPUT_BAR).tar.gz build/packages



.PHONY: pdf-all
pdf-all: pdf-all ## Generate PDF versions of all BAR books



.PHONY: pdf-jesus
pdf-jesus: ## Generate PDF version of the bar Jesus Guide
	asciidoctor-pdf \
		-a pdf-stylesdir=$(PDF_THEME_DIR)/ \
		-a pdf-style=$(PDF_THEME_BAR) \
		-a pdf-fontsdir=$(PDF_FONTS_DIR) \
		-a productname=$(PRODUCTNAME_BAR) \
		-a examplesdir=modules/jesus/examples \
		-a imagesdir=modules/jesus/assets/images \
		-a revdate=$(REVDATE) \
		--base-dir . \
		--out-file $(PDF_BUILD_DIR)/$(FILENAME_BAR)_historicity_of_jesus.pdf \
		modules/jesus/nav-jesus-guide.adoc

.PHONY: pdf-new-atheism
pdf-new-atheism: ## Generate PDF version of the bar New Atheism Guide
	asciidoctor-pdf \
		-a pdf-stylesdir=$(PDF_THEME_DIR)/ \
		-a pdf-style=$(PDF_THEME_BAR) \
		-a pdf-fontsdir=$(PDF_FONTS_DIR) \
		-a productname=$(PRODUCTNAME_BAR) \
		-a examplesdir=modules/new-athesism/examples \
		-a imagesdir=modules/new-atheism/assets/images \
		-a revdate=$(REVDATE) \
		--base-dir . \
		--out-file $(PDF_BUILD_DIR)/$(FILENAME_BAR)_new-atheism.pdf \
		modules/new-atheism/nav-new-atheism.adoc

.PHONY: pdf-root
pdf-root: ## Generate PDF version of the bar root book
	asciidoctor-pdf \
		-a pdf-stylesdir=$(PDF_THEME_DIR)/ \
		-a pdf-style=$(PDF_THEME_BAR) \
		-a pdf-fontsdir=$(PDF_FONTS_DIR) \
		-a productname=$(PRODUCTNAME_BAR) \
		-a examplesdir=modules/ROOT/examples \
		-a imagesdir=modules/ROOT/assets/images \
		-a revdate=$(REVDATE) \
		--base-dir . \
		--out-file $(PDF_BUILD_DIR)/$(FILENAME_BAR)_ROOT_book.pdf \
		modules/ROOT/nav.adoc




