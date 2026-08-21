// pe_mixed_precision.sv
import pkg_orion::*;

module pe_mixed_precision #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 16
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic                     en,
    input  precision_t               prec,
    input  logic [DATA_WIDTH-1:0]    data,
    input  logic [DATA_WIDTH-1:0]    weight,
    input  logic [ACC_WIDTH-1:0]     accum_in,
    output logic [ACC_WIDTH-1:0]     accum_out
);
    logic [DATA_WIDTH-1:0] data_m, weight_m;
    logic signed [2*DATA_WIDTH-1:0] prod;
    logic [ACC_WIDTH-1:0] sum, sum_reg, acc_in_reg;

    always_comb begin
        data_m   = mask_prec(data, prec);
        weight_m = mask_prec(weight, prec);
    end

    assign prod = $signed({1'b0, data_m}) * $signed(weight_m);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_in_reg <= 0;
            sum_reg <= 0;
        end else if (en) begin
            acc_in_reg <= accum_in;
            sum = acc_in_reg + prod[ACC_WIDTH-1:0];
            sum_reg <= sum;
        end
    end
    assign accum_out = sum_reg;
endmodule