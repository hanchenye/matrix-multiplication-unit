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
    parameter MEM_TYPE     = "36Kb", //18Kb / 36Kb
    parameter DATA_WIDTH   = 16, //10-18
    parameter DOT_POSITION = 0,

    /* PE Location Config */ /* MEM_DEPT = 1024 */
    parameter ARRAY_SIZE   = 16, //unchangable
    parameter MATRIX_DEPTH = 16, //less than MEM_DEPTH*ARRAY_SIZE/2

    /* pipeline config */
    parameter PIPELINE_DEPTH = 1
)(
`ifdef DEBUG
    /* debug interface */
    input wire ap_next,
    output wire [6:0] state_w,
//    output wire [7:0] pe_state_0_0_w,
//    output wire [7:0] pe_state_15_5_w,
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
    output wire m_axis_valid,
    input wire m_axis_ready,
    output wire [ARRAY_SIZE*DATA_WIDTH-1:0] m_axis_data,

    /* CMD AXI Stream Slave Interface */
    output reg cmd_s_axis_valid,
    input wire cmd_s_axis_ready,
    output wire [103:0] cmd_s_axis_data,

    /* CMD AXI Stream Master Interface */
    output reg cmd_m_axis_valid,
    input wire cmd_m_axis_ready,
    output wire [103:0] cmd_m_axis_data,

    /*axi lite slave Interface*/
    input wire        s_axil_awvalid,
    output reg        s_axil_awready,
    input wire [31:0] s_axil_awaddr,
    input wire [2:0]  s_axil_awprot,//no use

    input wire        s_axil_wvalid,
    output reg        s_axil_wready,
    input wire [31:0] s_axil_wdata,
    input wire [3:0]  s_axil_wstrb,//no use

    output reg        s_axil_bvalid,
    input wire        s_axil_bready,
    output reg [1:0]  s_axil_bresp,

    input wire        s_axil_arvalid,
    output reg        s_axil_arready,
    input wire [31:0] s_axil_araddr,
    input wire [2:0]  s_axil_arprot,//no use

    output reg        s_axil_rvalid,
    input wire        s_axil_rready,
    output reg [31:0] s_axil_rdata,
    output reg [1:0]  s_axil_rresp

);


/* axil register address */
localparam ADDR_BASEA = 8'h00,
           ADDR_BASEB = 8'h04,
           ADDR_BASEC = 8'h08,
           ADDR_WIDTHA = 8'h10,
           ADDR_WIDTHB = 8'h14,
           ADDR_DEPTH = 8'h20;

/* state */
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

/* axil register default value */
localparam REG_BASEA = 64'h0000_0000,
           REG_BASEB = 64'h1000_0000,
           REG_BASEC = 64'h2000_0000,
           REG_WIDTHA = ARRAY_SIZE,
           REG_WIDTHB = ARRAY_SIZE,
           REG_DEPTH = MATRIX_DEPTH;


/*state register */
reg [6:0] state;

`ifdef DEBUG
assign state_w = state;
`endif


/* aix lite Config register */
reg [31:0] basea;
reg [31:0] baseb;
reg [31:0] basec;
reg [31:0] widtha;
reg [31:0] widthb;
reg [31:0] depth;

wire s_axil_rden;
wire s_axil_wren;
assign s_axil_rden = s_axil_arvalid & s_axil_arready & ~s_axil_rvalid;
assign s_axil_wren = s_axil_wvalid & s_axil_wready & s_axil_awvalid & s_axil_awready;


/* pe control signal */
reg cnt;
reg pe_start;
//reg pe_ctrl;
wire [ARRAY_SIZE-1:0] pe_ctrl[ARRAY_SIZE-1:0];
wire [7:0] pe_state_t[ARRAY_SIZE-1:0][ARRAY_SIZE-1:0];
wire [7:0] pe_state;
//always @(posedge clk)
//begin
//    pe_ctrl <= s_axis_valid;
//end
assign pe_state = pe_state_t[0][0];

`ifdef DEBUG
//assign pe_state_0_0_w = pe_state_t[0][0];
//assign pe_state_15_5_w = pe_state_t[15][5];
`endif

wire [ARRAY_SIZE-1:0] pe_row_bc [ARRAY_SIZE-1:0];
wire [ARRAY_SIZE-1:0] pe_col_bc [ARRAY_SIZE-1:0];
wire [ARRAY_SIZE*DATA_WIDTH-1:0] row_data_in [ARRAY_SIZE-1:0];
wire [ARRAY_SIZE*DATA_WIDTH-1:0] col_data_in [ARRAY_SIZE-1:0];
wire [ARRAY_SIZE*DATA_WIDTH-1:0] row_data_out [ARRAY_SIZE-1:0];
wire [ARRAY_SIZE*DATA_WIDTH-1:0] col_data_out [ARRAY_SIZE-1:0];

wire [31:0] pe_matrix_depth;
assign pe_matrix_depth = depth;


/* CMD axis signal */
reg [64:0] cmd_s_axis_addr;
reg [22:0] cmd_s_axis_size;
reg [64:0] cmd_m_axis_addr;
reg [22:0] cmd_m_axis_size;
assign cmd_s_axis_data = {8'h00, cmd_s_axis_addr, 8'h40, 1'b1, cmd_s_axis_size};
assign cmd_m_axis_data = {8'h00, cmd_m_axis_addr, 8'h40, 1'b1, cmd_m_axis_size};

wire [22:0] axis_size_c;
wire [22:0] axis_size_a;
wire [22:0] axis_size_b;
assign axis_size_c = widtha * widthb * DATA_WIDTH / 8;
assign axis_size_a = widtha * depth * DATA_WIDTH / 8;
assign axis_size_b = depth * widthb * DATA_WIDTH / 8;

wire [ARRAY_SIZE-1:0] axis_ctrl;
assign m_axis_valid = ((state == PE_OUT) || (state == SYS_FINISH)) && axis_ctrl[0];


/* pipeline broadcast registers */ /*pipeline depth == 1 */
//reg [ARRAY_SIZE*DATA_WIDTH-1:0] row_data_reg [ARRAY_SIZE-1:0];
//reg [ARRAY_SIZE*DATA_WIDTH-1:0] col_data_reg [ARRAY_SIZE-1:0];

//genvar k;
//generate
//for(k = 0; k < ARRAY_SIZE; k = k + 1)
//begin: pipeline
//    always @(posedge clk)
//    begin
//        if(!rst_n)
//        begin
//            row_data_reg[k] <= 0;
//            col_data_reg[k] <= 0;
//        end
//        else
//        begin
//            row_data_reg[k] <= row_data_out[k];
//            col_data_reg[k] <= col_data_out[k];
//        end
//    end
//end
//endgenerate


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
        
        //m_axis_valid <= 0;
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
                    cmd_m_axis_addr <= basec;
                    cmd_m_axis_size <= axis_size_c;

                    cmd_s_axis_valid <= 1;
                    cmd_s_axis_addr <= basec;
                    cmd_s_axis_size <= axis_size_c;
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
                    cmd_s_axis_addr <= basea;
                    cmd_s_axis_size <= axis_size_a;
                end
            end
            PE_FETCHA:
            begin
                cmd_s_axis_valid <= 0;

                if(pe_state == FETCHB)
                begin
                    state <= PE_FETCHB;

                    cmd_s_axis_valid <= 1;
                    cmd_s_axis_addr <= baseb;
                    cmd_s_axis_size <= axis_size_b; 
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
                    //m_axis_valid <= 1;
                end
            end
            PE_OUT:
            begin
                if(pe_state == INIT)
                begin
                    state <= SYS_FINISH;
                    //m_axis_valid <= 0;
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
        .DATA_WIDTH(DATA_WIDTH),
        .PIPELINE_DEPTH(PIPELINE_DEPTH)
    ) bus (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(pe_row_bc[m]),
        .data_in(row_data_in[m]),
        .valid_out(),
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
        .DATA_WIDTH(DATA_WIDTH),
        .PIPELINE_DEPTH(PIPELINE_DEPTH)
    ) bus (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in({s_axis_valid, pe_col_bc[n]}),
        .data_in({s_axis_data[(n+1)*DATA_WIDTH-1:n*DATA_WIDTH], col_data_in[n]}),
        .valid_out({axis_ctrl[n], pe_ctrl[n]}),
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
            .MEM_TYPE(MEM_TYPE),
            .DATA_WIDTH(DATA_WIDTH),
            .DOT_POSITION(DOT_POSITION),
            .MEM_DEPTH(MEM_TYPE=="36Kb"?2048:1024),
            .DSP_DEPTH(3),
            .ARRAY_SIZE(ARRAY_SIZE),
            .MATRIX_DEPTH(MATRIX_DEPTH), //less than AB_DEPTH*ARRAY_SIZE
            .PIPELINE_DEPTH(PIPELINE_DEPTH),
            .ROW_I(i),
            .COL_J(j)
        ) PE (
            .clk(clk),
            .rst_n(rst_n),
            .ap_start(pe_start),
            .ap_ctrl(pe_ctrl[i][j]),
            .ap_matrix_depth(pe_matrix_depth),
            .ap_row_bc(pe_row_bc[i][j]),
            .ap_col_bc(pe_col_bc[j][i]),
            .ap_state(pe_state_t[i][j]),
            .row_read(row_data_out[i][(j+1)*DATA_WIDTH-1:j*DATA_WIDTH]),
            .col_read(col_data_out[j][(i+1)*DATA_WIDTH-1:i*DATA_WIDTH]),
            .row_write(row_data_in[i][(j+1)*DATA_WIDTH-1:j*DATA_WIDTH]),
            .col_write(col_data_in[j][(i+1)*DATA_WIDTH-1:i*DATA_WIDTH])
        );
    end
end
endgenerate

/* axi lite logic */
always @(posedge clk)
begin
    if (!rst_n)
    begin
        s_axil_awready <= 1;
        s_axil_wready <= 1;
        s_axil_arready <= 1;
    end
    else
    begin
        s_axil_awready <= s_axil_awready;
        s_axil_wready <= s_axil_wready;
        s_axil_arready <= s_axil_arready;
    end
end

always @(posedge clk)
begin
    if (!rst_n)
    begin
        s_axil_bvalid <= 0;
        s_axil_bresp <= 0;
    end
    else if (s_axil_wvalid && s_axil_wready && ~s_axil_bvalid &&
             s_axil_awvalid && s_axil_awready)
    begin
        s_axil_bvalid <= 1;
        s_axil_bresp <= 0;
    end
    else if (s_axil_bvalid && s_axil_bready)
    begin
        s_axil_bvalid <= 0;
        s_axil_bresp <= 0;
    end
    else
    begin
        s_axil_bvalid <= s_axil_bvalid;
        s_axil_bresp <= s_axil_bresp;
    end
end

always @(posedge clk)
begin
    if (!rst_n)
    begin
        s_axil_rvalid <= 0;
        s_axil_rresp <= 0;
    end
    else if (s_axil_arvalid && s_axil_arready && ~s_axil_rvalid)
    begin
        s_axil_rvalid <= 1;
        s_axil_rresp <= 0;
    end
    else if (s_axil_rvalid && s_axil_rready)
    begin
        s_axil_rvalid <= 0;
        s_axil_rresp <= 0;
    end
    else
    begin
        s_axil_rvalid <= s_axil_rvalid;
        s_axil_rresp <= s_axil_rresp;
    end
end

always @(posedge clk)
begin
    if (!rst_n)
        s_axil_rdata <= 32'hFFFF_FFFF;
    else if (s_axil_rden)
        case (s_axil_araddr[7:0])
            ADDR_BASEA: s_axil_rdata <= basea;
            ADDR_BASEB: s_axil_rdata <= baseb;
            ADDR_BASEC: s_axil_rdata <= basec;
            ADDR_WIDTHA: s_axil_rdata <= widtha;
            ADDR_WIDTHB: s_axil_rdata <= widthb;
            ADDR_DEPTH: s_axil_rdata <= depth;
        endcase
    else
        s_axil_rdata <= s_axil_rdata;
end

always @(posedge clk)
begin
    if(!rst_n)
    begin
        basea <= REG_BASEA;
        baseb <= REG_BASEB;
        basec <= REG_BASEC;
        widtha <= REG_WIDTHA;
        widthb <= REG_WIDTHB;
        depth <= REG_DEPTH;
    end
    else if(s_axil_wren)
    begin
        case(s_axil_awaddr[7:0])
            ADDR_BASEA: basea <= s_axil_wdata;
            ADDR_BASEB: baseb <= s_axil_wdata;
            ADDR_BASEC: basec <= s_axil_wdata;
            ADDR_WIDTHA: widtha <= s_axil_wdata;
            ADDR_WIDTHB: widthb <= s_axil_wdata;
            ADDR_DEPTH: depth <= s_axil_wdata;
        endcase
    end
end

endmodule
