// axi4_lite_slave.sv
import pkg_orion::*;

module axi4_lite_slave (
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic                     s_axi_awvalid,
    input  logic [31:0]              s_axi_awaddr,
    output logic                     s_axi_awready,
    input  logic                     s_axi_wvalid,
    input  logic [31:0]              s_axi_wdata,
    output logic                     s_axi_wready,
    output logic                     s_axi_bvalid,
    input  logic                     s_axi_bready,
    input  logic                     s_axi_arvalid,
    input  logic [31:0]              s_axi_araddr,
    output logic                     s_axi_arready,
    output logic                     s_axi_rvalid,
    output logic [31:0]              s_axi_rdata,
    input  logic                     s_axi_rready,
    output logic                     start,
    output logic [31:0]              workload_id
);
    logic [31:0] regs [0:3];
    logic aw_hs, w_hs, ar_hs;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axi_awready <= 0; aw_hs <= 0;
            s_axi_wready <= 0; w_hs <= 0;
            s_axi_bvalid <= 0;
            s_axi_arready <= 0; ar_hs <= 0;
            s_axi_rvalid <= 0; s_axi_rdata <= 0;
            start <= 0; workload_id <= 0;
        end else begin
            // Write address
            s_axi_awready <= s_axi_awvalid && !aw_hs;
            if (s_axi_awvalid && !aw_hs) aw_hs <= 1;
            else if (s_axi_wvalid && s_axi_wready) aw_hs <= 0;
            // Write data
            s_axi_wready <= s_axi_wvalid && !w_hs;
            if (s_axi_wvalid && !w_hs) w_hs <= 1;
            else if (s_axi_awvalid && s_axi_awready) w_hs <= 0;
            // Write response
            if (s_axi_awvalid && s_axi_wvalid && s_axi_awready && s_axi_wready) begin
                if (s_axi_awaddr[3:0] == 4'h0) start <= s_axi_wdata[0];
                else if (s_axi_awaddr[3:0] == 4'h4) workload_id <= s_axi_wdata;
                s_axi_bvalid <= 1;
            end else if (s_axi_bready) begin
                s_axi_bvalid <= 0;
            end
            // Read address
            s_axi_arready <= s_axi_arvalid && !ar_hs;
            if (s_axi_arvalid && !ar_hs) ar_hs <= 1;
            else if (s_axi_rvalid && s_axi_rready) ar_hs <= 0;
            // Read data
            if (s_axi_arvalid && s_axi_arready) begin
                s_axi_rdata <= regs[s_axi_araddr[3:0]];
                s_axi_rvalid <= 1;
            end else if (s_axi_rready) begin
                s_axi_rvalid <= 0;
            end
        end
    end
endmodule