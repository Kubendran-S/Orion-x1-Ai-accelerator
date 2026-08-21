// pkg_orion.sv
package pkg_orion;
    typedef enum logic [2:0] {
        CHIPLET_COMPUTE,
        CHIPLET_MEMORY,
        CHIPLET_CIM,
        CHIPLET_CONTROL,
        CHIPLET_IO
    } chiplet_t;

    typedef enum logic [1:0] {
        MODE_SYSTOLIC,
        MODE_SIMD,
        MODE_SPARSE,
        MODE_CIM
    } dataflow_mode_t;

    typedef enum logic [1:0] {
        PREC_1BIT,
        PREC_2BIT,
        PREC_4BIT,
        PREC_8BIT
    } precision_t;

    localparam MAX_LAYERS     = 32;
    localparam SYSTOLIC_SIZE  = 64;
    localparam DATA_WIDTH     = 8;
    localparam ACC_WIDTH      = 16;

    typedef logic [31:0] mem_addr_t;
    typedef logic [63:0] mem_data_t;
    typedef logic [7:0]  byte_t;
    typedef logic [15:0] acc_t;

    typedef struct packed {
        dataflow_mode_t mode;
        precision_t     weight_prec;
        precision_t     data_prec;
        logic [3:0]     layer_idx;
        logic           enable;
    } config_t;

    function automatic int prec_bits(precision_t p);
        case (p)
            PREC_1BIT: return 1;
            PREC_2BIT: return 2;
            PREC_4BIT: return 4;
            PREC_8BIT: return 8;
            default:   return 8;
        endcase
    endfunction

    function automatic byte_t mask_prec(byte_t data, precision_t p);
        byte_t mask;
        case (p)
            PREC_1BIT: mask = data[0] ? 8'hFF : 8'h00;
            PREC_2BIT: mask = {6'b00, data[1:0]};
            PREC_4BIT: mask = {4'b0000, data[3:0]};
            PREC_8BIT: mask = data;
            default:   mask = data;
        endcase
        return mask;
    endfunction
endpackage