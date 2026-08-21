// fifo_async.sv
module fifo_async #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 16
)(
    input  logic wclk, wrst_n,
    input  logic wren,
    input  logic [DATA_WIDTH-1:0] wdata,
    output logic wfull,
    input  logic rclk, rrst_n,
    input  logic rden,
    output logic [DATA_WIDTH-1:0] rdata,
    output logic rempty
);
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [$clog2(DEPTH)-1:0] wptr, rptr;
    logic [DATA_WIDTH-1:0] rdata_reg;
    assign wfull = 0; assign rempty = 0; assign rdata = rdata_reg;
endmodule