// cxl_interface.sv
module cxl_interface (
    input  logic clk, rst_n,
    input  logic cxl_rx_valid,
    input  logic [63:0] cxl_rx_data,
    output logic cxl_tx_valid,
    output logic [63:0] cxl_tx_data,
    output logic axi_req_valid,
    output logic [31:0] axi_req_addr,
    output logic [63:0] axi_req_data,
    input  logic axi_resp_valid,
    input  logic [63:0] axi_resp_data
);
    assign cxl_tx_valid = axi_resp_valid;
    assign cxl_tx_data  = axi_resp_data;
    assign axi_req_valid = cxl_rx_valid;
    assign axi_req_addr = 0;
    assign axi_req_data = cxl_rx_data;
endmodule