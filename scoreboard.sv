// scoreboard.sv
`include "pkg_orion.sv"
class scoreboard;
    import pkg_orion::*;
    function logic [15:0] compute_expected(
        input [7:0] data_in,
        input [7:0] weights[64],
        input precision_t prec
    );
        logic [15:0] sum = 0;
        for (int i=0; i<64; i++) begin
            logic [7:0] dm = mask_prec(data_in, prec);
            logic [7:0] wm = mask_prec(weights[i], prec);
            sum += $signed({1'b0, dm}) * $signed(wm);
        end
        return sum;
    endfunction

    function bit compare(logic [15:0] dut_out, logic [15:0] expected);
        if (dut_out === expected) begin
            $display("PASS: DUT %d == expected %d", dut_out, expected);
            return 1;
        end else begin
            $display("FAIL: DUT %d != expected %d", dut_out, expected);
            return 0;
        end
    endfunction
endclass