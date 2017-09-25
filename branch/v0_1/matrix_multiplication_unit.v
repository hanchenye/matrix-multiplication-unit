`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2017 09:57:29 PM
// Design Name: 
// Module Name: matrix_multiplication_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define DEBUG;

module matrix_multiplication_unit
#(
    /* GEMM Unit Calculation Config */
    parameter DATA_WIDTH   = 16,
    parameter DOT_POSITION = 0,

    /* PE Location Config */ /* MEM_DEPT = 1024 */
    parameter ARRAY_SIZE   = 16,
    parameter MATRIX_DEPTH = 16, //less than MEM_DEPTH*ARRAY_SIZE/2

    /* pipeline config */
    parameter PIPELINE_DEPTH = 1
)(
`ifdef DEBUG
    /* debug interface */
    input wire ap_next,
    output wire [6:0] state_w,
    output wire [7:0] pe_state_0_0_w,
    output wire [7:0] pe_state_15_5_w,
`endif
    
    input wire clk,
//    input wire mem_clk, //double clk
    input wire rst_n,
    
    /* Control Interface */
    input wire ap_start,
    output reg ap_done,
    
    output reg datamover_rst_n,
    
    /* AXI Stream Slave Interface */
    input wire s_axis_valid,
    output reg s_axis_ready,
    input wire [ARRAY_SIZE*DATA_WIDTH-1:0] s_axis_data,
    
    /* AXI Stream Master Interface */
    output reg m_axis_valid,
    input wire m_axis_ready,
    output wire [ARRAY_SIZE*DATA_WIDTH-1:0] m_axis_data,

    /* CMD AXI Stream Slave Interface */
    output reg cmd_s_axis_valid,
    input wire cmd_s_axis_ready,
    output wire [103:0] cmd_s_axis_data,

    /* CMD AXI Stream Master Interface */
    output reg cmd_m_axis_valid,
    input wire cmd_m_axis_ready,
    output wire [103:0] cmd_m_axis_data
);

localparam SYS_IDLE   = 7'b1,
           PE_FETCHC  = 7'b10,
           PE_FETCHA  = 7'b100,
           PE_FETCHB  = 7'b1000,
           PE_MULT    = 7'b1_0000,
           PE_OUT     = 7'b10_0000,
           SYS_FINISH = 7'b100_0000;

/* pe state */
localparam INIT      = 8'b1,
           FETCHA    = 8'b10,
           FETCHB    = 8'b100,
           BC0       = 8'b1000,
           BC_UPDATE = 8'b1_0000,
           UPDATE0   = 8'b10_0000,
           FLUSH     = 8'b100_0000,
           OUT       = 8'b1000_0000;

localparam BASEA = 64'h0,
           BASEB = 64'h1000_0000,
           BASEC = 64'h2000_0000;

/* CMD axis signal */
reg [64:0] cmd_s_axis_addr;
reg [22:0] cmd_s_axis_size;
reg [64:0] cmd_m_axis_addr;
reg [22:0] cmd_m_axis_size;

assign cmd_s_axis_data = {8'h00, cmd_s_axis_addr, 8'h40, 1'b1, cmd_s_axis_size};
assign cmd_m_axis_data = {8'h00, cmd_m_axis_addr, 8'h40, 1'b1, cmd_m_axis_size};

/* pe control signal */
reg cnt;
reg pe_start;
reg pe_ctrl;
wire [7:0] pe_state_t[ARRAY_SIZE-1:0][ARRAY_SIZE-1:0];
wire [7:0] pe_state;

always @(posedge clk)
begin
    pe_ctrl <= s_axis_valid;
end
assign pe_state = pe_state_t[0][0];

`ifdef DEBUG
assign pe_state_0_0_w = pe_state_t[0][0];
assign pe_state_15_5_w = pe_state_t[15][5];
`endif

wire [ARRAY_SIZE-1:0] pe_row_bc [ARRAY_SIZE-1:0];
wire [ARRAY_SIZE-1:0] pe_col_bc [ARRAY_SIZE-1:0];
wire [ARRAY_SIZE*DATA_WIDTH-1:0] row_data_in [ARRAY_SIZE-1:0];
wire [ARRAY_SIZE*DATA_WIDTH-1:0] col_data_in [ARRAY_SIZE-1:0];
wire [ARRAY_SIZE*DATA_WIDTH-1:0] row_data_out [ARRAY_SIZE-1:0];
wire [ARRAY_SIZE*DATA_WIDTH-1:0] col_data_out [ARRAY_SIZE-1:0];

/* pipeline broadcast registers */ /*pipeline depth == 1 */
reg [ARRAY_SIZE*DATA_WIDTH-1:0] row_data_reg [ARRAY_SIZE-1:0];
reg [ARRAY_SIZE*DATA_WIDTH-1:0] col_data_reg [ARRAY_SIZE-1:0];

genvar k;
generate
for(k = 0; k < ARRAY_SIZE; k = k + 1)
begin: pipeline
    always @(posedge clk)
    begin
        if(!rst_n)
        begin
            row_data_reg[k] <= 0;
            col_data_reg[k] <= 0;
        end
        else
        begin
            row_data_reg[k] <= row_data_out[k];
            col_data_reg[k] <= col_data_out[k];
        end
    end
end
endgenerate

reg [6:0] state;

`ifdef DEBUG
assign state_w = state;
`endif

/* State Machine */
always @(posedge clk)
begin
    if(!rst_n)
    begin
        ap_done <= 0;
        state <= SYS_IDLE;
        pe_start <= 0;
        
        cmd_m_axis_valid <= 0;
        cmd_m_axis_addr <= 0;
        cmd_m_axis_size <= 0;

        cmd_s_axis_valid <= 0;
        cmd_s_axis_addr <= 0;
        cmd_s_axis_size <= 0;
        
        m_axis_valid <= 0;
        s_axis_ready <= 1;
        
        datamover_rst_n <= 0;
    end
    else
    begin
        case(state)
            SYS_IDLE:
            begin
                ap_done <= 0;
                datamover_rst_n <= 1;
                
                if(ap_start)
                begin
                    state <= PE_FETCHC;
                    pe_start <= 1;
                    
                    cmd_m_axis_valid <= 1;
                    cmd_m_axis_addr <= BASEC;
                    cmd_m_axis_size <= ARRAY_SIZE * DATA_WIDTH * ARRAY_SIZE / 8;

                    cmd_s_axis_valid <= 1;
                    cmd_s_axis_addr <= BASEC;
                    cmd_s_axis_size <= ARRAY_SIZE * DATA_WIDTH * ARRAY_SIZE / 8;
                end
            end
            PE_FETCHC:
            begin
                cmd_m_axis_valid <= 0;
                cmd_s_axis_valid <= 0;

                if(pe_state == FETCHA)
                begin
                    state <= PE_FETCHA;
                    pe_start <= 0;

                    cmd_s_axis_valid <= 1;
                    cmd_s_axis_addr <= BASEA;
                    cmd_s_axis_size <= MATRIX_DEPTH * DATA_WIDTH * ARRAY_SIZE / 8;
                end
            end
            PE_FETCHA:
            begin
                cmd_s_axis_valid <= 0;

                if(pe_state == FETCHB)
                begin
                    state <= PE_FETCHB;

                    cmd_s_axis_valid <= 1;
                    cmd_s_axis_addr <= BASEB;
                    cmd_s_axis_size <= MATRIX_DEPTH * DATA_WIDTH * ARRAY_SIZE / 8; 
                end
            end
            PE_FETCHB:
            begin
                cmd_s_axis_valid <= 0;

                if(pe_state == BC0)
                begin
                    state <= PE_MULT;
                end
            end
            PE_MULT:
            begin
                if(pe_state == OUT)
                begin
                    state <= PE_OUT;
                    m_axis_valid <= 1;
                end
            end
            PE_OUT:
            begin
                if(pe_state == INIT)
                begin
                    state <= SYS_FINISH;
                    m_axis_valid <= 0;
                end
            end
            SYS_FINISH:
            begin
                ap_done <= 1;
                
            `ifdef DEBUG
                if(ap_next)
                begin
                    state <= SYS_IDLE;
                    datamover_rst_n <= 0;
                end
            `else
                state <= SYS_IDLE;
                datamover_rst_n <= 0;
            `endif
            end
        endcase
    end
end

/* generate row bus */
genvar m;
generate
for(m = 0; m < ARRAY_SIZE; m = m + 1)
begin: ROW
    row_data_bus #(
        .ARRAY_SIZE(ARRAY_SIZE),
        .DATA_WIDTH(DATA_WIDTH)
    ) bus (
        .clk(clk),
        .rst_n(rst_n),
        .ap_broadcast(pe_row_bc[m]),
        .data_in(row_data_in[m]),
        .data_out(row_data_out[m])
    );
end
endgenerate

/* generate col bus */
genvar n;
generate
for(n = 0; n < ARRAY_SIZE; n = n + 1)
begin: COL
    col_data_bus #(
        .ARRAY_SIZE(ARRAY_SIZE),
        .DATA_WIDTH(DATA_WIDTH)
    ) bus (
        .clk(clk),
        .rst_n(rst_n),
        .ap_broadcast({s_axis_valid, pe_col_bc[n]}),
        .data_in({s_axis_data[(n+1)*DATA_WIDTH-1:n*DATA_WIDTH], col_data_in[n]}),
        .data_out({m_axis_data[(n+1)*DATA_WIDTH-1:n*DATA_WIDTH], col_data_out[n]})
    );
end
endgenerate

/* generate pe */
genvar i;
genvar j;
generate
for(i = 0; i < ARRAY_SIZE; i = i + 1)
begin: row
    for(j = 0; j < ARRAY_SIZE; j = j + 1)
    begin: col
        wire pe_done_local;
        processing_element #(
            .DATA_WIDTH(DATA_WIDTH),
            .DOT_POSITION(DOT_POSITION),
            .MEM_DEPTH(1024),
            .DSP_DEPTH(3),
            .ARRAY_SIZE(ARRAY_SIZE),
            .MATRIX_DEPTH(MATRIX_DEPTH), //less than AB_DEPTH*ARRAY_SIZE
            .PIPELINE_DEPTH(PIPELINE_DEPTH),
            .ROW_I(i),
            .COL_J(j)
        ) PE (
            .clk(clk),
//            .mem_clk(mem_clk),
            .rst_n(rst_n),
            .ap_start(pe_start),
            .ap_ctrl(pe_ctrl),
            .ap_row_bc(pe_row_bc[i][j]),
            .ap_col_bc(pe_col_bc[j][i]),
            .ap_state(pe_state_t[i][j]),
            .row_read(row_data_reg[i][(j+1)*DATA_WIDTH-1:j*DATA_WIDTH]),
            .col_read(col_data_reg[j][(i+1)*DATA_WIDTH-1:i*DATA_WIDTH]),
            .row_write(row_data_in[i][(j+1)*DATA_WIDTH-1:j*DATA_WIDTH]),
            .col_write(col_data_in[j][(i+1)*DATA_WIDTH-1:i*DATA_WIDTH])
        );
    end
end
endgenerate

endmodule
