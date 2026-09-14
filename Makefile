SRC = full_adder.sv ripple_adder.sv alu.sv
TB  = alu_tb.sv
OUT = sim.out

test: $(SRC) $(TB)
	iverilog -g2012 -o $(OUT) $(SRC) $(TB)
	vvp $(OUT)

clean:
	rm -f $(OUT) wave.vcd

.PHONY: test clean
