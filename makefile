BOARD ?= basys3
VIVADO ?= vivado
SUPPORTED_BOARDS := basys3 arty-a7-100

ifeq ($(filter $(SUPPORTED_BOARDS),$(BOARD)),)
$(error Unsupported BOARD '$(BOARD)'; choose one of: $(SUPPORTED_BOARDS))
endif
ifneq ($(words $(BOARD)),1)
$(error BOARD must name exactly one board)
endif

PROJECT := $(notdir $(shell pwd))
BUILD_DIR := build/$(BOARD)
XPR := $(BUILD_DIR)/$(PROJECT).xpr
PROJECT_INPUTS := makefile $(wildcard scripts/*.tcl src/*.vhd sim/*.vhd constraints/*.xdc)

.PHONY: all project bitstream clean

all: bitstream

project: $(XPR)

bitstream: $(XPR)
	$(VIVADO) -mode batch -source scripts/build_bitstream.tcl -nojournal -nolog -tclargs $(BOARD)

$(XPR): $(PROJECT_INPUTS)
	mkdir -p "$(BUILD_DIR)"
	$(VIVADO) -mode batch -source scripts/create_project.tcl -nojournal -nolog -tclargs $(BOARD)

clean:
	rm -rf build out *.jou *.log
