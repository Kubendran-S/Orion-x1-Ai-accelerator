// sparse_engine.sv
`include "pkg_orion.sv"
module sparse_engine #(
    parameter N = 4,
    parameter M = 8,
    parameter DATA_WIDTH = 8
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic                     en,
    input  logic [DATA_WIDTH-1:0]    weights [0:M-1],
    input  logic [DATA_WIDTH-1:0]    data,
    output logic [DATA_WIDTH-1:0]    non_zero_weights [0:N-1],
    output logic [3:0]               non_zero_count,
    output logic                     all_zero,
    output logic                     valid_out
);
    import pkg_orion::*;
    integer idx;
    logic [3:0] count;
    logic valid;
    logic [DATA_WIDTH-1:0] nz_reg [0:N-1];
    logic [3:0] cnt_reg;
    logic all_zero_reg, valid_reg;

    always_comb begin
        count = 0; valid = 0;
        for (int i=0; i<M; i++) begin
            if (weights[i] != 0) begin
                if (count < N) begin
                    non_zero_weights[count] = weights[i];
                    count++;
                end
            end
        end
        non_zero_count = count;
        all_zero = (count == 0);
        if (count > 0) valid = 1;
        for (int i=count; i<N; i++) non_zero_weights[i] = 0;
    end

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            for (int i=0; i<N; i++) nz_reg[i] <= 0;
            cnt_reg <= 0; all_zero_reg <= 1; valid_reg <= 0;
        end else if (en) begin
            for (int i=0; i<N; i++) nz_reg[i] <= non_zero_weights[i];
            cnt_reg <= count; all_zero_reg <= all_zero; valid_reg <= valid;
        end
    assign non_zero_weights = nz_reg;
    assign non_zero_count = cnt_reg;
    assign all_zero = all_zero_reg;
    assign valid_out = valid_reg;
endmodule