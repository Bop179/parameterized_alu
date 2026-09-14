module half_adder(
    input logic a, b,
    output logic sum, carry
);

    assign sum = a ^ b;
    assign carry = a & b;

endmodule

module full_adder(
    input logic a, b, cin,
    output logic sum, cout
);

    logic sum_to_a, cout0, cout1;
    half_adder ab_adder(a, b, sum_to_a, cout0);
    half_adder bc_adder(sum_to_a, cin, sum, cout1);
    assign cout = cout0 | cout1;

endmodule
