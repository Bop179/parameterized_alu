module ripple_adder #(parameter N)(
    input logic [N-1:0] a, b,
    input logic cin,
    output logic [N-1:0] sum,
    output logic cout
);
    logic [N:0] carry;
    assign carry[0] = cin;
    assign cout = carry[N];

    genvar i;
    generate // generate multiple full adders
        for (i = 0; i < N; i++) begin : bit_adders
            full_adder fa (
                a[i], b[i], carry[i],
                sum[i], carry[i+1] // chain full adders with their carry out and in
            );
        end
    endgenerate
endmodule