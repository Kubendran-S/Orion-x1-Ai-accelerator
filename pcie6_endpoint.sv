// pcie6_endpoint.sv
module pcie6_endpoint (
    input  logic clk, rst_n,
    input  logic pcie_rx_valid,
    input  logic [127:0] pcie_rx_data,
    output logic pcie_tx_valid,
    output logic [127:0] pcie_tx_data,
    output logic axi_req_valid,
    output logic [31:0] axi_req_addr,
    output logic [127:0] axi_req_data,
    input  logic axi_resp_valid,
    input  logic [127:0] axi_resp_data
);
    assign pcie_tx_valid = axi_resp_valid;
    assign pcie_tx_data  = axi_resp_data;
    assign axi_req_valid = pcie_rx_valid;
    assign axi_req_addr = 0;
    assign axi_req_data = pcie_rx_data;
endmodule