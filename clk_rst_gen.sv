// clk_rst_gen.sv
module clk_rst_gen #(
    real CLK_PERIOD = 10.0   // ns
)(
    output logic clk,
    output logic rst_n
);
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    initial begin
        rst_n = 0;
        #(CLK_PERIOD * 10) rst_n = 1;
    end
endmodule