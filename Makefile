.PHONY: day

SHELL := /bin/fish
DAY ?= 1
PADDED_DAY := $(shell printf '%02d' $(DAY))

day:
	@if test -z "$(DAY)"; \
		echo "Please provide a day number: make day DAY=1"; \
		exit 1; \
	end
	@echo "Creating d$(PADDED_DAY)..."
	@gleam new --skip-git solutions/d$(PADDED_DAY)
	@./scripts/init_day.fish $(PADDED_DAY)
	@echo "d$(PADDED_DAY) initialized successfully"
	@echo "Good luck!"
