// cim_core.sv
`include "pkg_orion.sv"
module cim_core #(
    parameter CIM_SIZE = 1024,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16
)(
    input  logic                     clk,
    input  logic                     en,
    input  logic [DATA_WIDTH-1:0]    input_vector [0:CIM_SIZE-1],
    output logic [ACC_WIDTH-1:0]     output_vector [0:CIM_SIZE-1]
);
    import pkg_orion::*;
    logic [DATA_WIDTH-1:0] weight_matrix [0:CIM_SIZE-1][0:CIM_SIZE-1];

    initial begin
        for (int i=0; i<CIM_SIZE; i++)
            for (int j=0; j<CIM_SIZE; j++)
                weight_matrix[i][j] = $urandom_range(0,255);
    end

    always_comb begin
        if (en) begin
            for (int i=0; i<CIM_SIZE; i++) begin
                logic [31:0] sum = 0;
                for (int j=0; j<CIM_SIZE; j++)
                    sum += input_vector[j] * weight_matrix[i][j];
                output_vector[i] = sum[ACC_WIDTH-1:0];
            end
        end else begin
            for (int i=0; i<CIM_SIZE; i++)
                output_vector[i] = 0;
        end
    end
endmodule