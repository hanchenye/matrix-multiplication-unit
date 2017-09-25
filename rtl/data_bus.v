`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2017 11:47:22 AM
// Design Name: 
// Module Name: data_bus
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

module row_data_bus
#(
    parameter ARRAY_SIZE = 16,
    parameter DATA_WIDTH = 16,
    parameter PIPELINE_DEPTH = 1
)(
    input wire                             clk,
    input wire                             rst_n,
    input wire [ARRAY_SIZE-1:0]            valid_in,
    input wire [ARRAY_SIZE*DATA_WIDTH-1:0] data_in,
    output reg [ARRAY_SIZE-1:0]            valid_out,
    output reg [ARRAY_SIZE*DATA_WIDTH-1:0] data_out
);

wire [DATA_WIDTH-1:0] data_bus;

assign data_bus = (valid_in[0]? data_in[DATA_WIDTH-1:0]: 0) |
                  (valid_in[1]? data_in[2*DATA_WIDTH-1:DATA_WIDTH]: 0) |
                  (valid_in[2]? data_in[3*DATA_WIDTH-1:2*DATA_WIDTH]: 0) |
                  (valid_in[3]? data_in[4*DATA_WIDTH-1:3*DATA_WIDTH]: 0) |
                  (valid_in[4]? data_in[5*DATA_WIDTH-1:4*DATA_WIDTH]: 0) |
                  (valid_in[5]? data_in[6*DATA_WIDTH-1:5*DATA_WIDTH]: 0) |
                  (valid_in[6]? data_in[7*DATA_WIDTH-1:6*DATA_WIDTH]: 0) |
                  (valid_in[7]? data_in[8*DATA_WIDTH-1:7*DATA_WIDTH]: 0) |
                  (valid_in[8]? data_in[9*DATA_WIDTH-1:8*DATA_WIDTH]: 0) |
                  (valid_in[9]? data_in[10*DATA_WIDTH-1:9*DATA_WIDTH]: 0) |
                  (valid_in[10]? data_in[11*DATA_WIDTH-1:10*DATA_WIDTH]: 0) |
                  (valid_in[11]? data_in[12*DATA_WIDTH-1:11*DATA_WIDTH]: 0) |
                  (valid_in[12]? data_in[13*DATA_WIDTH-1:12*DATA_WIDTH]: 0) |
                  (valid_in[13]? data_in[14*DATA_WIDTH-1:13*DATA_WIDTH]: 0) |
                  (valid_in[14]? data_in[15*DATA_WIDTH-1:14*DATA_WIDTH]: 0) |
                  (valid_in[15]? data_in[16*DATA_WIDTH-1:15*DATA_WIDTH]: 0);
genvar i;
generate
for(i = 0; i < ARRAY_SIZE; i = i + 1)
begin: broadcast
    always @(posedge clk)
    begin
        if(!rst_n)
        begin
            valid_out[i] <= 0;
            data_out[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] <= 0;
        end
        else if(valid_in)
        begin
            valid_out[i] <= 1;
            data_out[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] <= data_bus;
        end
        else
        begin
            valid_out[i] <= 0;
            data_out[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] <= 0;    
        end
    end
end
endgenerate

endmodule



module col_data_bus
#(
    parameter ARRAY_SIZE = 16,
    parameter DATA_WIDTH = 16,
    parameter PIPELINE_DEPTH = 1
)(
    input wire                                 clk,
    input wire                                 rst_n,
    input wire [ARRAY_SIZE:0]                  valid_in,
    input wire [(ARRAY_SIZE+1)*DATA_WIDTH-1:0] data_in,
    output reg [ARRAY_SIZE:0]                  valid_out,
    output reg [(ARRAY_SIZE+1)*DATA_WIDTH-1:0] data_out
);

wire [DATA_WIDTH-1:0] data_bus;

assign data_bus = (valid_in[0]? data_in[DATA_WIDTH-1:0]: 0) |
                  (valid_in[1]? data_in[2*DATA_WIDTH-1:DATA_WIDTH]: 0) |
                  (valid_in[2]? data_in[3*DATA_WIDTH-1:2*DATA_WIDTH]: 0) |
                  (valid_in[3]? data_in[4*DATA_WIDTH-1:3*DATA_WIDTH]: 0) |
                  (valid_in[4]? data_in[5*DATA_WIDTH-1:4*DATA_WIDTH]: 0) |
                  (valid_in[5]? data_in[6*DATA_WIDTH-1:5*DATA_WIDTH]: 0) |
                  (valid_in[6]? data_in[7*DATA_WIDTH-1:6*DATA_WIDTH]: 0) |
                  (valid_in[7]? data_in[8*DATA_WIDTH-1:7*DATA_WIDTH]: 0) |
                  (valid_in[8]? data_in[9*DATA_WIDTH-1:8*DATA_WIDTH]: 0) |
                  (valid_in[9]? data_in[10*DATA_WIDTH-1:9*DATA_WIDTH]: 0) |
                  (valid_in[10]? data_in[11*DATA_WIDTH-1:10*DATA_WIDTH]: 0) |
                  (valid_in[11]? data_in[12*DATA_WIDTH-1:11*DATA_WIDTH]: 0) |
                  (valid_in[12]? data_in[13*DATA_WIDTH-1:12*DATA_WIDTH]: 0) |
                  (valid_in[13]? data_in[14*DATA_WIDTH-1:13*DATA_WIDTH]: 0) |
                  (valid_in[14]? data_in[15*DATA_WIDTH-1:14*DATA_WIDTH]: 0) |
                  (valid_in[15]? data_in[16*DATA_WIDTH-1:15*DATA_WIDTH]: 0) |
                  (valid_in[16]? data_in[17*DATA_WIDTH-1:16*DATA_WIDTH]: 0);
genvar i;
generate
for(i = 0; i < (ARRAY_SIZE+1); i = i + 1)
begin: broadcast
    always @(posedge clk)
    begin
        if(!rst_n)
        begin
            valid_out[i] <= 0;
            data_out[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] <= 0;
        end
        else if(valid_in)
        begin
            valid_out[i] <= 1;
            data_out[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] <= data_bus;
        end
        else
        begin
            valid_out[i] <= 0;
            data_out[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] <= 0;    
        end
    end
end
endgenerate

endmodule