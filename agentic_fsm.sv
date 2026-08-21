// agentic_fsm.sv - Synthesizable, no `include` needed
// IMPORTANT: pkg_orion.sv must be added to the project and compiled first.
import pkg_orion::*;

module agentic_fsm #(
    parameter MICROCODE_DEPTH = 1024,
    parameter NUM_CONFIGS = 4
)(
    input  logic                      clk,
    input  logic                      rst_n,
    input  logic                      start,
    input  logic [31:0]               workload_id,
    output logic                      busy,
    output logic                      done,
    output config_t                   current_cfg,
    output logic [3:0]                layer_idx,
    output logic [$clog2(MICROCODE_DEPTH)-1:0] pc,
    input  logic [31:0]               instr,
    input  logic [31:0]               measured_latency
);

    typedef enum { IDLE, FETCH, EXECUTE, UPDATE, LEARN } state_t;
    state_t state, next_state;
    config_t cfg_reg;
    logic [3:0] layer_reg;
    logic [31:0] q_table [0:31][0:NUM_CONFIGS-1];   // Q-table

    // Decode instruction
    always_comb begin
        cfg_reg.mode        = dataflow_mode_t'(instr[27:24]);
        cfg_reg.weight_prec = precision_t'(instr[23:20]);
        cfg_reg.data_prec   = precision_t'(instr[19:16]);
        cfg_reg.enable      = 1'b1;
        layer_reg           = instr[15:12];
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            pc <= 0;
            busy <= 0;
            done <= 0;
            current_cfg <= '0;
            layer_idx <= 0;
            // Initialize Q-table (loops unrolled by synthesis)
            for (int i=0; i<32; i++)
                for (int j=0; j<NUM_CONFIGS; j++)
                    q_table[i][j] <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    if (start) begin
                        busy <= 1;
                        done <= 0;
                        pc <= 0;
                        next_state <= FETCH;
                    end else begin
                        busy <= 0;
                        done <= 1;
                        next_state <= IDLE;
                    end
                end

                FETCH: begin
                    next_state <= EXECUTE;
                end

                EXECUTE: begin
                    current_cfg <= cfg_reg;
                    layer_idx <= layer_reg;
                    pc <= pc + 1;
                    next_state <= UPDATE;
                end

                UPDATE: begin
                    if (instr[31:28] == 4'hF) begin
                        done <= 1;
                        busy <= 0;
                        next_state <= LEARN;
                    end else begin
                        next_state <= FETCH;
                    end
                end

                LEARN: begin
                    // No division - use shifts (>>3 = /8) for synthesizable learning
                    logic [31:0] idx, reward, old_q, new_q;
                    logic [1:0]  cfg_used;

                    idx = workload_id & 32'h1F;        // modulo 32
                    cfg_used = instr[1:0];             // use lower 2 bits

                    reward = (measured_latency < 1000) ? (1000 - measured_latency) : 0;

                    old_q = q_table[idx][cfg_used];
                    new_q = old_q - (old_q >> 3) + (reward >> 3);
                    q_table[idx][cfg_used] <= new_q;

                    next_state <= IDLE;
                end

                default: next_state <= IDLE;
            endcase
        end
    end
endmodule