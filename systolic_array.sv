// systolic_array.sv
import pkg_orion::*;

module systolic_array #(
    parameter SIZE = 64,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 16
)(
    input  logic                      clk,
    input  logic                      rst_n,
    input  logic                      en,
    input  precision_t                prec,
    input  logic [DATA_WIDTH-1:0]     input_row [0:SIZE-1],
    input  logic [DATA_WIDTH-1:0]     weight_col [0:SIZE-1],
    output logic [ACC_WIDTH-1:0]      accum_out [0:SIZE-1]
);
    logic [DATA_WIDTH-1:0] data_flow [0:SIZE-1][0:SIZE-1];
    logic [ACC_WIDTH-1:0] acc_flow [0:SIZE-1][0:SIZE-1];

    genvar i, j;
    generate
        for (i = 0; i < SIZE; i++) begin : row
            for (j = 0; j < SIZE; j++) begin : col
                logic [DATA_WIDTH-1:0] data_in;
                logic [ACC_WIDTH-1:0] acc_in;
                if (j == 0) assign data_in = input_row[i];
                else        assign data_in = data_flow[i][j-1];
                if (i == 0) assign acc_in = 0;
                else        assign acc_in = acc_flow[i-1][j];

                pe_mixed_precision #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) pe (
                    .clk(clk), .rst_n(rst_n), .en(en), .prec(prec),
                    .data(data_in), .weight(weight_col[j]),
                    .accum_in(acc_in), .accum_out(acc_flow[i][j])
                );
                always_ff @(posedge clk or negedge rst_n)
                    if (!rst_n) data_flow[i][j] <= 0;
                    else if (en) data_flow[i][j] <= data_in;
            end
        end
    endgenerate

    always_comb begin
        for (int j = 0; j < SIZE; j++)
            accum_out[j] = acc_flow[SIZE-1][j];
    end
endmodule