BINARY_NAME  := autokeyboardlang
BUNDLE_NAME  := $(BINARY_NAME).app
BINARY_SRC   := .build/release/$(BINARY_NAME)
BUNDLE_DIR   := $(BUNDLE_NAME)/Contents
BUNDLE_BIN   := $(BUNDLE_DIR)/MacOS/$(BINARY_NAME)
BUNDLE_PLIST := $(BUNDLE_DIR)/Info.plist
BUNDLE_PKGINFO := $(BUNDLE_DIR)/PkgInfo
BUNDLE_ID    := com.jakguel.autokeyboardlang

.PHONY: bundle install clean-bundle help _build

## Build the release binary and package it into an .app bundle.
## The bundle is required for macOS to grant Input Monitoring permission
## to autokeyboardlang instead of the calling Terminal app.
bundle: _build
	@echo "→ Creating $(BUNDLE_NAME)..."
	@mkdir -p $(BUNDLE_DIR)/MacOS
	@cp $(BINARY_SRC) $(BUNDLE_BIN)
	@cp Resources/Info.plist $(BUNDLE_PLIST)
	@printf 'APPL????' > $(BUNDLE_PKGINFO)
	@codesign --force --sign - --identifier $(BUNDLE_ID) $(BUNDLE_NAME)
	@echo ""
	@echo "✓ $(BUNDLE_NAME) created and signed ($(BUNDLE_ID))"
	@echo ""
	@echo "Next steps:"
	@echo "  cp -r $(BUNDLE_NAME) /Applications/"
	@echo "  /Applications/$(BUNDLE_NAME)/Contents/MacOS/$(BINARY_NAME)"

_build:
	swift build --configuration release --arch arm64

## Install the bundle to /Applications (requires make bundle first).
install: bundle
	@echo "→ Installing to /Applications/$(BUNDLE_NAME) ..."
	@cp -r $(BUNDLE_NAME) /Applications/
	@echo ""
	@echo "✓ Installed. Grant Input Monitoring permission when prompted, then run:"
	@echo "  /Applications/$(BUNDLE_NAME)/Contents/MacOS/$(BINARY_NAME)"

## Remove the generated .app bundle from the working directory.
clean-bundle:
	@rm -rf $(BUNDLE_NAME)
	@echo "✓ Removed $(BUNDLE_NAME)"

help:
	@echo "Targets:"
	@echo "  bundle       Build release binary and create $(BUNDLE_NAME)"
	@echo "  install      bundle + copy to /Applications/"
	@echo "  clean-bundle Remove $(BUNDLE_NAME)"
