SRC = full_adder.sv ripple_adder.sv alu.sv
TB  = alu_tb.sv
OUT = sim.out
DEFS = $(if $(N),-DN=$(N))

test: compile
	vvp $(OUT)

compile: $(SRC) $(TB)
	iverilog -g2012 $(DEFS) -o $(OUT) $(SRC) $(TB)

clean:
	rm -f $(OUT) wave.vcd

.PHONY: test compile clean
