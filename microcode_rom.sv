// microcode_rom.sv
import pkg_orion::*;

module microcode_rom #(
    parameter DEPTH = 1024,
    parameter WIDTH = 32
)(
    input  logic [$clog2(DEPTH)-1:0] addr,
    output logic [WIDTH-1:0]         data
);
    always_comb begin
        case (addr)
            0:  data = {4'h0, MODE_SYSTOLIC, PREC_8BIT, PREC_8BIT, 4'd0, 12'h0};
            1:  data = {4'h0, MODE_SPARSE,   PREC_4BIT, PREC_8BIT, 4'd1, 12'h0};
            2:  data = {4'h0, MODE_CIM,      PREC_2BIT, PREC_4BIT, 4'd2, 12'h0};
            3:  data = {4'hF, 4'h0, 4'h0, 4'h0, 4'd0, 12'h0};
            default: data = 0;
        endcase
    end
endmodule