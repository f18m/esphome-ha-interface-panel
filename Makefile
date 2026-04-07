# Basic Makefile for this ESPHome project
# Make sure you activate the ESPHome venv environment before running these commands

ifeq ($(LOCALLY_ATTACHED),1)
# to upload to a device locally attached via USB:
OPTIONS:=--device /dev/ttyACM0
else
# to upload to a device that has already been flashed with this project
# and needs just to be updated over the network:
OPTIONS:= --device smarthome-hmi-waveshare-lcd-p2.lan
endif

ifeq ($(CONFIG_FILE),)
# default value
CONFIG_FILE:=interface-panel.yaml
endif


flash-main:
	@echo "Flashing the MAIN firmware..."
	esphome run $(OPTIONS) $(CONFIG_FILE)

upload-main:
	@echo "Uploading the MAIN firmware..."
	esphome upload $(OPTIONS) $(CONFIG_FILE)

validate-main:
	@echo "Validating the MAIN firmware..."
	esphome config $(CONFIG_FILE) >$(CONFIG_FILE).validated


# test with SDL emulator in local

test-local:
	@echo "Running local tests (without flashing)..."
	esphome run --no-logs dev-sdl.yaml 

test-validate:
	@echo "Validating the configuration files..."
	#esphome config main.yaml
	esphome config dev-sdl.yaml >dev-sdl.yaml.validated


# initial test, just for historical records:

flash-self-contained:
	@echo "Flashing the self-contained ESPHome device..."
	esphome run $(OPTIONS) self-contained.yaml
