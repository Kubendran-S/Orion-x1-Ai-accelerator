// runtime_reconfig.sv
`include "pkg_orion.sv"
module runtime_reconfig (
    input  logic               clk,
    input  logic               rst_n,
    input  logic               load_en,
    input  logic [31:0]        config_addr,
    input  logic [31:0]        config_data,
    output dataflow_mode_t     current_mode,
    output precision_t         current_weight_prec,
    output precision_t         current_data_prec,
    output logic [3:0]         current_layer
);
    import pkg_orion::*;
    logic [31:0] cfg_regs [0:7];
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            for (int i=0; i<8; i++) cfg_regs[i] <= 0;
            current_mode <= MODE_SYSTOLIC;
            current_weight_prec <= PREC_8BIT;
            current_data_prec <= PREC_8BIT;
            current_layer <= 0;
        end else if (load_en) begin
            cfg_regs[config_addr] <= config_data;
            current_mode          <= dataflow_mode_t'(cfg_regs[0][1:0]);
            current_weight_prec   <= precision_t'(cfg_regs[0][3:2]);
            current_data_prec     <= precision_t'(cfg_regs[0][5:4]);
            current_layer         <= cfg_regs[0][7:4];
        end
endmodule