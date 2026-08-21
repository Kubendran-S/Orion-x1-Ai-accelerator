// tb_orion_x1.sv
`include "pkg_orion.sv"

module tb_orion_x1;
    import pkg_orion::*;

    logic clk, rst_n;
    // AXI-Lite signals
    logic s_axi_awvalid, s_axi_awready;
    logic [31:0] s_axi_awaddr;
    logic s_axi_wvalid, s_axi_wready;
    logic [31:0] s_axi_wdata;
    logic s_axi_bvalid, s_axi_bready;
    logic s_axi_arvalid, s_axi_arready;
    logic [31:0] s_axi_araddr;
    logic s_axi_rvalid, s_axi_rready;
    logic [31:0] s_axi_rdata;
    logic [7:0] data_in;
    logic [15:0] data_out;

    orion_x1_top dut (
        .clk(clk), .rst_n(rst_n),
        .s_axi_awvalid(s_axi_awvalid), .s_axi_awaddr(s_axi_awaddr), .s_axi_awready(s_axi_awready),
        .s_axi_wvalid(s_axi_wvalid), .s_axi_wdata(s_axi_wdata), .s_axi_wready(s_axi_wready),
        .s_axi_bvalid(s_axi_bvalid), .s_axi_bready(s_axi_bready),
        .s_axi_arvalid(s_axi_arvalid), .s_axi_araddr(s_axi_araddr), .s_axi_arready(s_axi_arready),
        .s_axi_rvalid(s_axi_rvalid), .s_axi_rdata(s_axi_rdata), .s_axi_rready(s_axi_rready),
        .data_in(data_in), .data_out(data_out)
    );

    clk_rst_gen #(.CLK_PERIOD(10.0)) clk_rst (.clk(clk), .rst_n(rst_n));

    scoreboard sb = new();
    covergroup cg_orion @(posedge clk);
        coverpoint dut.control.current_cfg.weight_prec;
        coverpoint dut.control.current_cfg.mode;
        coverpoint dut.control.layer_idx;
        cross weight_prec, mode, layer;
    endgroup
    cg_orion cov = new();

    task axi_write(input [31:0] addr, input [31:0] data);
        @(posedge clk);
        s_axi_awvalid = 1; s_axi_awaddr = addr;
        s_axi_wvalid = 1; s_axi_wdata = data;
        @(posedge clk);
        wait(s_axi_awready && s_axi_wready);
        s_axi_awvalid = 0; s_axi_wvalid = 0;
        wait(s_axi_bvalid);
        s_axi_bready = 1;
        @(posedge clk);
        s_axi_bready = 0;
    endtask

    task axi_read(input [31:0] addr, output [31:0] data);
        @(posedge clk);
        s_axi_arvalid = 1; s_axi_araddr = addr;
        @(posedge clk);
        wait(s_axi_arready);
        s_axi_arvalid = 0;
        wait(s_axi_rvalid);
        data = s_axi_rdata;
        s_axi_rready = 1;
        @(posedge clk);
        s_axi_rready = 0;
    endtask

    initial begin
        // Initialize
        s_axi_awvalid = 0; s_axi_wvalid = 0; s_axi_bready = 0;
        s_axi_arvalid = 0; s_axi_rready = 0;
        data_in = 0;
        @(posedge rst_n);
        repeat(10) @(posedge clk);

        // Write workload ID and start
        axi_write(32'h04, 32'h1234);
        axi_write(32'h00, 32'h1);

        // Run for some cycles
        repeat(200) @(posedge clk);

        // Check output (dummy check – just print)
        $display("data_out = %d", data_out);
        if (data_out !== 0) $display("PASS: non‑zero output");
        else $display("FAIL: zero output");

        $display("Coverage: %0.2f%%", cov.get_inst_coverage());
        $finish;
    end
endmodule