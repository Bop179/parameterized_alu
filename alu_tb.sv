`ifndef N
`define N 8
`endif

module alu_tb;
    localparam N = `N;
    logic [N-1:0] a, b, out;
    logic [3:0] opcode;
    logic overflow, zero, negative;
    int errors = 0;

    alu #(.N(N)) dut (.a(a), .b(b), .opcode(opcode),
                       .overflow(overflow), .zero(zero),
                       .negative(negative), .out(out));

    task automatic check(string name, logic [N-1:0] exp_out, logic exp_ovf, logic exp_zero, logic exp_neg);
        #1;
        if (out !== exp_out || overflow !== exp_ovf || zero !== exp_zero || negative !== exp_neg) begin
            errors++;
            $display("FAIL %-8s a=%0d b=%0d op=%b -> out=%0d(exp %0d) ovf=%b(exp %b) zero=%b(exp %b) neg=%b(exp %b)",
                      name, a, b, opcode, out, exp_out, overflow, exp_ovf, zero, exp_zero, negative, exp_neg);
        end else begin
            $display("PASS %-8s a=%0d b=%0d op=%b -> out=%0d ovf=%b zero=%b neg=%b",
                      name, a, b, opcode, out, overflow, zero, negative);
        end
    endtask

    // overflow isn't implemented for mult yet, so these ops only check out/zero/negative
    task automatic check_no_ovf(string name, logic [N-1:0] exp_out, logic exp_zero, logic exp_neg);
        #1;
        if (out !== exp_out || zero !== exp_zero || negative !== exp_neg) begin
            errors++;
            $display("FAIL %-8s a=%0d b=%0d op=%b -> out=%0d(exp %0d) zero=%b(exp %b) neg=%b(exp %b)",
                      name, a, b, opcode, out, exp_out,
                      zero, exp_zero, negative, exp_neg);
        end else begin
            $display("PASS %-8s a=%0d b=%0d op=%b -> out=%0d zero=%b neg=%b",
                      name, a, b, opcode, out, zero, negative);
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, alu_tb);

        // basic add
        a = 8'd5; b = 8'd3; opcode = 4'b1000; check("add", 8'd8, 0, 0, 0);

        // basic subtract
        a = 8'd5; b = 8'd3; opcode = 4'b1100; check("sub", 8'd2, 0, 0, 0);

        // subtract giving zero
        a = 8'd5; b = 8'd5; opcode = 4'b1100; check("sub=0", 8'd0, 0, 1, 0);

        // subtract giving negative (two's complement result, top bit set)
        a = 8'd3; b = 8'd5; opcode = 4'b1100; check("sub<0", 8'hFE, 0, 0, 1);

        // signed overflow: 127 + 1 as 8-bit signed add
        a = 8'd127; b = 8'd1; opcode = 4'b1000; check("add ovf", 8'd128, 1, 0, 1);

        // multiply
        a = 8'd5; b = 8'd4; opcode = 4'b1110; check_no_ovf("mult", 8'd20, 0, 0);

        // multiply giving zero
        a = 8'd0; b = 8'd9; opcode = 4'b1110; check_no_ovf("mult=0", 8'd0, 1, 0);

        // divide
        a = 8'd20; b = 8'd4; opcode = 4'b1111; check_no_ovf("div", 8'd5, 0, 0);

        // bitwise AND
        a = 8'hF0; b = 8'h0F; opcode = 4'b0010; check_no_ovf("and=0", 8'h00, 1, 0);
        a = 8'hFF; b = 8'h0F; opcode = 4'b0010; check_no_ovf("and", 8'h0F, 0, 0);

        // bitwise OR
        a = 8'hF0; b = 8'h0F; opcode = 4'b0011; check_no_ovf("or", 8'hFF, 0, 1);

        // bitwise XOR
        a = 8'hFF; b = 8'h0F; opcode = 4'b0100; check_no_ovf("xor", 8'hF0, 0, 1);

        // bitwise NOT (b unused)
        a = 8'h0F; b = 8'h00; opcode = 4'b0101; check_no_ovf("not", 8'hF0, 0, 1);

        // undefined opcode falls through to default
        a = 8'd9; b = 8'd2; opcode = 4'b0000; check_no_ovf("default", 8'd0, 1, 0);

        if (errors == 0) $display("\nALL TESTS PASSED");
        else $display("\n%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule
