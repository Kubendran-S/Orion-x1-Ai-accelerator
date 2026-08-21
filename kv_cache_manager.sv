// kv_cache_manager.sv
`include "pkg_orion.sv"
module kv_cache_manager #(
    parameter MAX_TOKENS = 65536,
    parameter KEY_WIDTH = 512,
    parameter VALUE_WIDTH = 512,
    parameter COMPRESS_RATIO = 4
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic                     wr_en,
    input  logic [31:0]              token_id,
    input  logic [KEY_WIDTH-1:0]     key,
    input  logic [VALUE_WIDTH-1:0]   value,
    input  logic                     rd_en,
    input  logic [31:0]              rd_token_id,
    output logic [KEY_WIDTH-1:0]     rd_key,
    output logic [VALUE_WIDTH-1:0]   rd_value,
    output logic                     hit,
    input  logic                     compress_en,
    input  logic [3:0]               compression_ratio
);
    logic [KEY_WIDTH-1:0]   keys [0:MAX_TOKENS-1];
    logic [VALUE_WIDTH-1:0] values [0:MAX_TOKENS-1];
    logic                   valid [0:MAX_TOKENS-1];
    logic [31:0]            lru_counter [0:MAX_TOKENS-1];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i=0; i<MAX_TOKENS; i++) valid[i] = 0;
        end else begin
            if (wr_en) begin
                if (compress_en) begin
                    keys[token_id]   <= key & ~((1<<COMPRESS_RATIO)-1);
                    values[token_id] <= value & ~((1<<COMPRESS_RATIO)-1);
                end else begin
                    keys[token_id]   <= key;
                    values[token_id] <= value;
                end
                valid[token_id] <= 1;
                lru_counter[token_id] <= 0;
                for (int i=0; i<MAX_TOKENS; i++)
                    if (i != token_id && valid[i])
                        lru_counter[i] <= lru_counter[i] + 1;
            end
        end
    end

    always_comb begin
        hit = 1'b0; rd_key = 0; rd_value = 0;
        if (rd_en && valid[rd_token_id]) begin
            hit = 1'b1;
            rd_key = keys[rd_token_id];
            rd_value = values[rd_token_id];
        end
    end
endmodule