// array_controller.sv
`include "pkg_orion.sv"
module array_controller (
    input  logic               clk,
    input  logic               rst_n,
    input  config_t            cfg,
    input  logic               layer_start,
    output logic               systolic_en,
    output logic               simd_en,
    output logic               sparse_en,
    output logic               cim_en,
    output logic [3:0]         layer_idx_out
);
    import pkg_orion::*;
    logic [3:0] layer_delay;
    logic start_delay;

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            {systolic_en, simd_en, sparse_en, cim_en} <= 4'b0;
            layer_delay <= 0; start_delay <= 0;
        end else begin
            start_delay <= layer_start;
            layer_delay <= cfg.layer_idx;
            case (cfg.mode)
                MODE_SYSTOLIC: {systolic_en, simd_en, sparse_en, cim_en} <= {start_delay, 3'b0};
                MODE_SIMD:     {systolic_en, simd_en, sparse_en, cim_en} <= {1'b0, start_delay, 2'b0};
                MODE_SPARSE:   {systolic_en, simd_en, sparse_en, cim_en} <= {2'b0, start_delay, 1'b0};
                MODE_CIM:      {systolic_en, simd_en, sparse_en, cim_en} <= {3'b0, start_delay};
                default:       {systolic_en, simd_en, sparse_en, cim_en} <= 0;
            endcase
        end
    assign layer_idx_out = layer_delay;
endmodule