# Basic Makefile for this ESPHome project
# Make sure you activate the ESPHome venv environment before running these commands

#OPTIONS:=--device /dev/ttyACM0
OPTIONS:= --device 192.168.1.97

flash-main:
	@echo "Flashing the MAIN firmware..."
	esphome run $(OPTIONS) main.yaml

upload-main:
	@echo "Uploading the MAIN firmware..."
	esphome upload $(OPTIONS) main.yaml

flash-self-contained:
	@echo "Flashing the self-contained ESPHome device..."
	esphome run $(OPTIONS) self-contained.yaml

test-local:
	@echo "Running local tests (without flashing)..."
	esphome run --no-logs dev-sdl.yaml 
