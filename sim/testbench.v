`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2017 06:40:09 PM
// Design Name: 
// Module Name: testbench
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


module testbench(

    );
    
    reg clk;
    reg rst_n;
    reg ap_start;
    wire ap_done;
    
    reg s_axis_valid;
    reg [255:0] s_axis_data;
    
    integer i;
    
//    wire [15:0] i;
    
    initial
    begin
        clk = 1;
        rst_n = 1;
        ap_start = 0;
        s_axis_valid = 0;
        s_axis_data = 0;
        #10 rst_n = 0;
        #20 rst_n = 1;
        #30 ap_start = 1;
        #40 ap_start = 0;
        
        for (i = 0; i < 16; i = i + 1)
        begin
            #10 s_axis_valid = 1;
            s_axis_data = 0;
        end
        
        #10 s_axis_valid = 0;
        for (i = 0; i < 16; i = i + 1)
        begin
            #10 s_axis_valid = 1;
//            case(i%4)
//                0:
//                begin
                    s_axis_data = 256'h000f_000e_000d_000c_000b_000a_0009_0008_0007_0006_0005_0004_0003_0002_0001_0000;
//                end
                
//                1:
//                begin
//                    s_axis_data = 256'h001f_001e_001d_001c_001b_001a_0019_0018_0017_0016_0015_0014_0013_0012_0011_0010;
//                end
                
//                2:
//                begin
//                    s_axis_data = 256'h002f_002e_002d_002c_002b_002a_0029_0028_0027_0026_0025_0024_0023_0022_0021_0020;
//                end
                
//                3:
//                begin
//                    s_axis_data = 256'h003f_003e_003d_003c_003b_003a_0039_0038_0037_0036_0035_0034_0033_0032_0031_0030;
//                end
//            endcase
            
//            #10 s_axis_valid = 0;
        end
        
        #10 s_axis_valid = 0;
        
        #10 s_axis_valid = 1;
            s_axis_data = 256'h0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
        #10 s_axis_data = 256'h0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001_0001;
        #10 s_axis_data = 256'h0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002_0002;
        #10 s_axis_data = 256'h0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003_0003;
        #10 s_axis_data = 256'h0004_0004_0004_0004_0004_0004_0004_0004_0004_0004_0004_0004_0004_0004_0004_0004;
        #10 s_axis_data = 256'h0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005_0005;
        #10 s_axis_data = 256'h0006_0006_0006_0006_0006_0006_0006_0006_0006_0006_0006_0006_0006_0006_0006_0006;
        #10 s_axis_data = 256'h0007_0007_0007_0007_0007_0007_0007_0007_0007_0007_0007_0007_0007_0007_0007_0007;
        #10 s_axis_data = 256'h0008_0008_0008_0008_0008_0008_0008_0008_0008_0008_0008_0008_0008_0008_0008_0008;
        #10 s_axis_data = 256'h0009_0009_0009_0009_0009_0009_0009_0009_0009_0009_0009_0009_0009_0009_0009_0009;
        #10 s_axis_data = 256'h000a_000a_000a_000a_000a_000a_000a_000a_000a_000a_000a_000a_000a_000a_000a_000a;
        #10 s_axis_data = 256'h000b_000b_000b_000b_000b_000b_000b_000b_000b_000b_000b_000b_000b_000b_000b_000b;
        #10 s_axis_data = 256'h000c_000c_000c_000c_000c_000c_000c_000c_000c_000c_000c_000c_000c_000c_000c_000c;
        #10 s_axis_data = 256'h000d_000d_000d_000d_000d_000d_000d_000d_000d_000d_000d_000d_000d_000d_000d_000d;
        #10 s_axis_data = 256'h000e_000e_000e_000e_000e_000e_000e_000e_000e_000e_000e_000e_000e_000e_000e_000e;
        #10 s_axis_data = 256'h000f_000f_000f_000f_000f_000f_000f_000f_000f_000f_000f_000f_000f_000f_000f_000f;
            
//        for (i = 0; i < 16; i = i + 1)
//        begin
//            #10 s_axis_valid = 1;
//            s_axis_data = 
//        end
        
        #10 s_axis_valid = 0;
    end
    
    always
    begin
        #5 clk= ~clk;
    end
    
    matrix_multiplication_unit mmu_inst(
    .clk(clk),
    .rst_n(rst_n),
    .ap_start(ap_start),
    .ap_done(ap_done),
    
    .s_axis_valid(s_axis_valid),
    .s_axis_data(s_axis_data) 
    );
endmodule
