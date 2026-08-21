// memory_mux.sv
module memory_mux #(
    parameter NUM_PORTS = 4,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 64
)(
    input  logic                           clk,
    input  logic                           rst_n,
    input  logic [NUM_PORTS-1:0]           req_valid,
    input  logic [NUM_PORTS-1:0][ADDR_WIDTH-1:0] req_addr,
    output logic [NUM_PORTS-1:0]           req_ready,
    output logic [NUM_PORTS-1:0]           resp_valid,
    output logic [NUM_PORTS-1:0][DATA_WIDTH-1:0] resp_rdata
);
    // Simple round‑robin – just for simulation
    logic [2:0] arb;
    assign req_ready = {NUM_PORTS{1'b1}};
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) arb <= 0;
        else arb <= arb + 1;
    // Not implemented fully – placeholder
endmodule