`ifndef N
`define N 8
`endif

module alu #(parameter N = `N)(
    input logic [N-1:0] a, b,
    input logic [3:0] opcode,
    output logic overflow, zero, negative,
    output logic [N-1:0] out
);

    // add and subtract
    logic sub;
    assign sub = (opcode == 4'b1100);

    logic [N-1:0] b_op;
    assign b_op = b ^ {N{sub}};

    logic [N-1:0] add_sub_result;
    ripple_adder #(N) u_adder (.a(a), .b(b_op), .cin(sub), .sum(add_sub_result));
    assign overflow = (a[N-1] == b_op[N-1]) && (add_sub_result[N-1] != a[N-1]);

    always_comb begin
        case (opcode)
            4'b1000: out = add_sub_result; // add
            4'b1100: out = add_sub_result; // sub
            4'b1110: out = a * b; // mult
            4'b1111: out = a / b; // div
            4'b0010: out = a & b;   // AND
            4'b0011: out = a | b;   // OR
            4'b0100: out = a ^ b;   // XOR
            4'b0101: out = ~a;      // NOT
            default: out = 0;
        endcase
    end

    assign zero = !out;
    assign negative = out[N-1];

endmodule