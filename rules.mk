include config.mk

.PHONY: clean $(TARGET)

all: $(TARGET).xst $(TARGET).bit

$(TARGET).ncd: $(TARGET).ngd
	$(MAP) $^

$(TARGET)_routed.ncd: $(TARGET).ncd
	$(PAR) -ol high -xe n -w $^ $@

$(TARGET).bit: $(TARGET)_routed.ncd
	$(BITGEN) -w $^ $@

$(TARGET).mcs: $(TARGET).bit
	$(PROMGEN) -w -u 0 $(TARGET)

$(TARGET)_routed.xdl: $(TARGET)_routed.ncd
	$(XDL) -ncd2xdl $^ $@

$(TARGET)_routed.twr: $(TARGET)_routed.ncd
	$(TRCE) -v 10 $^ $(TARGET).pcf

$(TARGET).prj: $(HDL_SRC)
	rm -f $(TARGET).prj
	for i in `echo $^`; do \
	    echo "verilog work $$i" >> $(TARGET).prj; \
	done

$(TARGET).ngc: $(TARGET).prj
	$(XST) -ifn $(TARGET).xst

$(TARGET).ngd: $(TARGET).ngc $(CON_SRC)
	$(NGDBUILD) -uc $(CON_SRC) $(TARGET).ngc

$(TARGET).xst:
	@echo "run" > $(TARGET).xst
	@echo "-ifn $(TARGET).prj" >> $(TARGET).xst
	@echo "-top $(TARGET)" >> $(TARGET).xst
	@echo "-ifmt MIXED" >> $(TARGET).xst
	@echo "-opt_mode AREA" >> $(TARGET).xst
	@echo "-opt_level 2" >> $(TARGET).xst
	@echo "-ofn $(TARGET).ngc" >> $(TARGET).xst
	@echo "-p $(DEVICE)" >> $(TARGET).xst
	@echo "-register_balancing yes" >> $(TARGET).xst

clean:
	rm -f *.prj *.xdl *.ncd *.pcf *.mcs *.pad *.xml *.twr 
	rm -f *.ngc *.drc *.par *.ptwx *.srp *.mrp *.ngm *.bgn 
	rm -f *.bld *.csv *.map *.unroutes *.xpi *.lst *.lso *.ngd *.xrpt *.txt *.bit
	rm -Rf xst
	rm -Rf xlnx_auto_0_xdb
