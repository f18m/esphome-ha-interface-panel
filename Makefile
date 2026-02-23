# Basic Makefile for this ESPHome project
# Make sure you activate the ESPHome venv environment before running these commands

flash-main:
	@echo "Flashing the MAIN firmware..."
	esphome run main.yaml
	
flash-self-contained:
	@echo "Flashing the self-contained ESPHome device..."
	esphome run self-contained.yaml

test-local:
	@echo "Running local tests (without flashing)..."
	esphome run dev-sdl.yaml --no-flash --no-log
