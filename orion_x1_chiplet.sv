// orion_x1_chiplet.sv
`include "pkg_orion.sv"
module orion_x1_chiplet #(
    parameter chiplet_t CHIPLET_TYPE = CHIPLET_COMPUTE,
    parameter SYSTOLIC_SIZE = 64
)(
    input  logic                      clk,
    input  logic                      rst_n,
    input  config_t                   cfg,
    input  logic [7:0]                data_in,
    output logic [15:0]               data_out,
    input  logic [31:0]               mem_req_addr,
    output logic [63:0]               mem_resp_data
);
    import pkg_orion::*;
    // Placeholder – actual implementation would instantiate the corresponding module
    assign data_out = 0;
    assign mem_resp_data = 0;
endmodule