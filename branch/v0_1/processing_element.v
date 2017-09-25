`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2017 06:00:28 PM
// Design Name: 
// Module Name: processing_element
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

module processing_element
#(
    /* PE Calculation Config */
    parameter DATA_WIDTH   = 16,
    parameter DOT_POSITION = 0,
    parameter MEM_DEPTH    = 1024,
    parameter DSP_DEPTH    = 3,
    
    /* PE Location Config */
    parameter ARRAY_SIZE   = 16,
    parameter MATRIX_DEPTH = 8000, //less than MEM_DEPTH*ARRAY_SIZE/2
    parameter ROW_I        = 2,
    parameter COL_J        = 2,

    /* pipeline config */
    parameter PIPELINE_DEPTH = 1
)(
    input wire                  clk,
//    input wire                  mem_clk, //double clk
    input wire                  rst_n,
    input wire                  ap_start,
    input wire                  ap_ctrl,
    output reg                  ap_row_bc,
    output reg                  ap_col_bc,
//    output reg                  ap_busy,
    output wire [7:0]           ap_state,
    input wire [DATA_WIDTH-1:0] row_read,
    input wire [DATA_WIDTH-1:0] col_read,
    output reg [DATA_WIDTH-1:0] row_write,
    output reg [DATA_WIDTH-1:0] col_write
);

function integer log2
(
    input integer x
);
    integer acc;
    begin
        acc=0;
        while ((2**acc) < x)
          acc = acc + 1;
        log2 = acc;
    end
endfunction

localparam ADDR_WIDTH = log2(MEM_DEPTH);
localparam POSI_WIDTH = log2(MATRIX_DEPTH);
localparam AB_DEPTH = MEM_DEPTH / 2;

localparam INIT      = 8'b1,
           FETCHA    = 8'b10,
           FETCHB    = 8'b100,
           BC0       = 8'b1000,
           BC_UPDATE = 8'b1_0000,
           UPDATE0   = 8'b10_0000,
           FLUSH     = 8'b100_0000,
           OUT       = 8'b1000_0000;

localparam BASEA     = 0,
           BASEB     = AB_DEPTH;

reg [7:0] state;
reg [POSI_WIDTH:0] p;//position pointer
reg [3:0] cnt;
reg flag;
reg [47:0] accum;

assign ap_state = state;

/* Define DSP */
reg mac_ce;
reg mac_sclr;
reg [DATA_WIDTH-1:0] mac_a;
reg [DATA_WIDTH-1:0] mac_b;
wire [47:0] mac_c;

DSP16 mac(
    .CLK(clk),
    .CE(mac_ce),
    .SCLR(mac_sclr),
    .A({2'b0, mac_a}),
    .B({2'b0, mac_b}),
    .C(mac_c),
    .P(mac_c)
);

/* Define BRAM */
reg [ADDR_WIDTH-1:0] addra;
reg [DATA_WIDTH-1:0] dina;
wire [DATA_WIDTH-1:0] douta;
reg wea;

reg [ADDR_WIDTH-1:0] addrb;
reg [DATA_WIDTH-1:0] dinb;
wire [DATA_WIDTH-1:0] doutb;
reg web;

BRAM16_16Kb mem(
    .clka(clk),
    .addra(addra),
    .dina(dina),
    .douta(douta),
    .wea(wea),
    .clkb(clk),
    .addrb(addrb),
    .dinb(dinb),
    .doutb(doutb),
    .web(web)
);

/* State Machine */
always @(posedge clk)
begin
    if(!rst_n)
    begin
//        ap_done <= 0;
//        ap_busy <= 0;
        ap_row_bc <= 0;
        ap_col_bc <= 0;
        p <= 0;
        state <= INIT;
        cnt <= 0;
        flag <= 0;
        
        mac_ce <= 0;
        mac_sclr <= 0;
        mac_a <= 0;
        mac_b <= 0;
        accum <= 0;
        
        addra <= 0;
        dina <= 0;
        wea <= 0;
        addrb <= 0;
        dinb <= 0;
        web <= 0;
        
        row_write <= 0;
        col_write <= 0;
    end
    else
    begin
        if(ap_row_bc == 1)
        begin
            ap_row_bc <= 0;
        end
        
        if(ap_col_bc == 1)
        begin
            ap_col_bc <= 0;
        end
        
        if(wea == 1)
        begin
            wea <= 0;
        end
        
        if(web == 1)
        begin
            web <= 0;
        end

        case(state)
            INIT:
            begin
                /* mac init */
                mac_sclr <= 1;
                
                if(ap_start && p == (ARRAY_SIZE - 1) && ap_ctrl)
                begin
                    state <= FETCHA;
                    p <= 0;
                    
                    /* mac init */ 
                    mac_sclr <= 0;
                end

                if(p != (ARRAY_SIZE - 1) && ap_ctrl) 
                begin
                    p <= p + 1;
                end

                /* distribute initial C */
                if((p % ARRAY_SIZE) == ROW_I && ap_ctrl)
                begin
                    accum <= (col_read << DOT_POSITION);
                    addra <= BASEA;
                    addrb <= BASEB;
                end
            end

            FETCHA:
            begin
                if(p == (MATRIX_DEPTH - 1) && ap_ctrl)
                begin
                    state <= FETCHB;
                    p <= 0;
                end
                else if(ap_ctrl)
                begin
                    p <= p + 1;
                end

                /* distribute A to local mem*/
                if((p % ARRAY_SIZE) == ROW_I && ap_ctrl)
                begin
                    dina <= col_read;
                    wea <= 1;
                end

                if(wea == 1)
                begin
                    addra <= addra + 1;
                end
            end

            FETCHB:
            begin
                if(p == (MATRIX_DEPTH - 1) && ap_ctrl)
                begin
                    state <= BC0;
                    p <= 0;
//                    flag <= 1; //prepare for BC0
                    mac_ce <= 1; //prepare for BC_UPDATE
                end
                else if(ap_ctrl)
                begin
                    p <= p + 1;
                end

                /* distribute B to local mem */
                if((p % ARRAY_SIZE) == ROW_I && ap_ctrl)
                begin
                    dinb <= col_read;
                    web <= 1;
                end

                if(web == 1)
                begin
                    addrb <= addrb + 1;
                end
            end

            BC0:
            begin
//                ap_busy <= 1;
                addra <= BASEA; //prepare for BC0
                addrb <= BASEB; //prepare for BC0
                flag <= 1;
                
                if(flag)
                begin
                    state <= BC_UPDATE;
                    flag <= 0;
                    
//                    /* broadcast rank0 A */
//                    if(COL_J == 0)
//                    begin
//                        ap_row_bc <= 1;
//                        row_write <= douta;
//                        addra <= addra + 1;
//                    end

//                    /* broadcast rank0 B */
//                    if(ROW_I == 0)
//                    begin
//                        ap_col_bc <= 1;
//                        col_write <= doutb;
//                        addrb <= addrb + 1;
//                    end
                end
            end

            BC_UPDATE:
            begin
                if(p == (MATRIX_DEPTH + PIPELINE_DEPTH - 1))
                begin
                    state <= UPDATE0;
                    p <= 0;
                end
                else
                begin
                    p <= p + 1;
                end

                /* broadcast rank(p+1) A */
                if(((p % ARRAY_SIZE) == COL_J) && (p < MATRIX_DEPTH))
                begin
                    ap_row_bc <= 1;
                    row_write <= douta;
                    addra <= addra + 1;
                end

                /* prepare rank(p-1) A */
                if(p > (PIPELINE_DEPTH - 1))
                begin
                    mac_a <= row_read;
                end

                /* broadcast rank(p+1) B */
                if(((p % ARRAY_SIZE) == ROW_I) && (p < MATRIX_DEPTH))
                begin
                    ap_col_bc <= 1;
                    col_write <= doutb;
                    addrb <= addrb + 1;
                end

                /* prepare rank(p-1) B */
                if(p > (PIPELINE_DEPTH - 1))
                begin
                    mac_b <= col_read;
                end
            end

            UPDATE0:
            begin
                state <= FLUSH;

                /* prepare rank(MATRIX_DEPTH-1) A & B) */
                mac_a <= row_read;
                mac_b <= col_read;

                /* prepare for flush */
                cnt <= 0;
            end

            FLUSH:
            begin
                if(cnt == DSP_DEPTH)
                begin
                    state <= OUT;
//                    ap_done <= 1;
                    mac_ce <= 0;
                end
                else
                begin
                    cnt <= cnt + 1;
                end
                
                mac_a <= 0;
                mac_b <= 0;
            end

            OUT:
            begin              
                if(p == (ARRAY_SIZE - 1))
                begin
//                    ap_done <= 0;
                    state <= INIT;
                    p <= 0;
                end
                else
                begin
                    p <= p + 1;
                end
                
                if((p % ARRAY_SIZE) == ROW_I)
                begin
                    ap_col_bc <= 1;
                    col_write <= (mac_c + accum) >> DOT_POSITION;
                end
            end

            default:
            begin
               state <= INIT;
            end
        endcase
    end
end

endmodule
