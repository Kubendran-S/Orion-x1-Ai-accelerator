// hbm_pim_controller.sv
`include "pkg_orion.sv"
module hbm_pim_controller #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 64,
    parameter MEM_DEPTH  = 1024
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic                     s_axi_awvalid,
    input  logic [ADDR_WIDTH-1:0]    s_axi_awaddr,
    output logic                     s_axi_awready,
    input  logic                     s_axi_wvalid,
    input  logic [DATA_WIDTH-1:0]    s_axi_wdata,
    output logic                     s_axi_wready,
    output logic                     s_axi_bvalid,
    input  logic                     s_axi_bready,
    input  logic                     s_axi_arvalid,
    input  logic [ADDR_WIDTH-1:0]    s_axi_araddr,
    output logic                     s_axi_arready,
    output logic                     s_axi_rvalid,
    output logic [DATA_WIDTH-1:0]    s_axi_rdata,
    input  logic                     s_axi_rready,
    input  logic                     pim_en,
    input  logic [ADDR_WIDTH-1:0]    pim_vec_addr,
    input  logic [ADDR_WIDTH-1:0]    pim_mat_addr,
    input  logic [31:0]              pim_size,
    output logic                     pim_done,
    output logic [DATA_WIDTH-1:0]    pim_result
);
    import pkg_orion::*;
    logic [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    typedef enum { IDLE, WDATA, WRESP } write_state_t;
    write_state_t wstate;

    // Write channel
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axi_awready <= 0; s_axi_wready <= 0; s_axi_bvalid <= 0; wstate <= IDLE;
        end else begin
            case (wstate)
                IDLE: begin
                    s_axi_awready = s_axi_awvalid;
                    s_axi_wready = s_axi_wvalid;
                    if (s_axi_awvalid && s_axi_wvalid) begin
                        mem[s_axi_awaddr[$clog2(MEM_DEPTH)-1:0]] <= s_axi_wdata;
                        wstate <= WRESP;
                    end
                end
                WRESP: begin
                    s_axi_bvalid <= 1;
                    if (s_axi_bready) begin
                        s_axi_bvalid <= 0; wstate <= IDLE;
                        s_axi_awready <= 0; s_axi_wready <= 0;
                    end
                end
                default: wstate <= IDLE;
            endcase
        end
    end

    // Read channel
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axi_arready <= 0; s_axi_rvalid <= 0; s_axi_rdata <= 0;
        end else begin
            s_axi_arready = s_axi_arvalid;
            if (s_axi_arvalid) begin
                s_axi_rdata <= mem[s_axi_araddr[$clog2(MEM_DEPTH)-1:0]];
                s_axi_rvalid <= 1;
            end else if (s_axi_rready) begin
                s_axi_rvalid <= 0;
            end
        end
    end

    // PIM compute (dummy dot product)
    logic pim_done_r;                    // FIXED: separate declarations
    logic [DATA_WIDTH-1:0] pim_result_r; // FIXED

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pim_done_r <= 0; pim_result_r <= 0;
        end else if (pim_en) begin
            automatic logic [63:0] sum = 0;
            for (int i=0; i<pim_size; i++) begin
                sum = sum + mem[pim_vec_addr + i] * mem[pim_mat_addr + i];
            end
            pim_result_r <= sum[DATA_WIDTH-1:0];
            pim_done_r <= 1;
        end else begin
            pim_done_r <= 0;
        end
    end
    assign pim_done = pim_done_r;
    assign pim_result = pim_result_r;
endmodule