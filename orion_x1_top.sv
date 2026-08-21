// orion_x1_top.sv
import pkg_orion::*;

module orion_x1_top (
    input  logic                      clk,
    input  logic                      rst_n,
    input  logic                      s_axi_awvalid,
    input  logic [31:0]               s_axi_awaddr,
    output logic                      s_axi_awready,
    input  logic                      s_axi_wvalid,
    input  logic [31:0]               s_axi_wdata,
    output logic                      s_axi_wready,
    output logic                      s_axi_bvalid,
    input  logic                      s_axi_bready,
    input  logic                      s_axi_arvalid,
    input  logic [31:0]               s_axi_araddr,
    output logic                      s_axi_arready,
    output logic                      s_axi_rvalid,
    output logic [31:0]               s_axi_rdata,
    input  logic                      s_axi_rready,
    input  logic [7:0]                data_in,
    output logic [15:0]               data_out
);
    logic start, done;
    logic [31:0] workload_id;
    config_t cfg;
    logic [3:0] layer_idx;
    logic [31:0] instr;
    logic [$clog2(1024)-1:0] pc;
    logic [31:0] measured_latency;

    axi4_lite_slave axi (
        .clk(clk), .rst_n(rst_n),
        .s_axi_awvalid(s_axi_awvalid), .s_axi_awaddr(s_axi_awaddr), .s_axi_awready(s_axi_awready),
        .s_axi_wvalid(s_axi_wvalid), .s_axi_wdata(s_axi_wdata), .s_axi_wready(s_axi_wready),
        .s_axi_bvalid(s_axi_bvalid), .s_axi_bready(s_axi_bready),
        .s_axi_arvalid(s_axi_arvalid), .s_axi_araddr(s_axi_araddr), .s_axi_arready(s_axi_arready),
        .s_axi_rvalid(s_axi_rvalid), .s_axi_rdata(s_axi_rdata), .s_axi_rready(s_axi_rready),
        .start(start), .workload_id(workload_id)
    );

    microcode_rom #(.DEPTH(1024), .WIDTH(32)) rom (
        .addr(pc),
        .data(instr)
    );

    agentic_fsm #(.MICROCODE_DEPTH(1024), .NUM_CONFIGS(4)) control (
        .clk(clk), .rst_n(rst_n),
        .start(start), .workload_id(workload_id),
        .busy(), .done(done),
        .current_cfg(cfg), .layer_idx(layer_idx),
        .pc(pc), .instr(instr),
        .measured_latency(measured_latency)
    );

    logic [7:0] input_row [0:63];
    logic [7:0] weight_col [0:63];
    logic [15:0] accum_out [0:63];

    generate
        for (genvar i=0; i<64; i++) begin
            assign input_row[i] = data_in;
            assign weight_col[i] = 8'h10 + i[7:0];
        end
    endgenerate

    systolic_array sa (
        .clk(clk), .rst_n(rst_n),
        .en(cfg.mode == MODE_SYSTOLIC),
        .prec(cfg.weight_prec),
        .input_row(input_row),
        .weight_col(weight_col),
        .accum_out(accum_out)
    );
    assign data_out = accum_out[0];

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) measured_latency <= 0;
        else if (done) measured_latency <= $urandom_range(10,100);
endmodule