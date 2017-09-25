// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (lin64) Build 1756540 Mon Jan 23 19:11:19 MST 2017
// Date        : Mon Sep 11 19:16:19 2017
// Host        : server142 running 64-bit Ubuntu 16.04.3 LTS
// Command     : write_verilog -force -mode funcsim -rename_top DSP_0 -prefix
//               DSP_0_ DSP16_sim_netlist.v
// Design      : DSP16
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "DSP16,xbip_dsp48_macro_v3_0_13,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "xbip_dsp48_macro_v3_0_13,Vivado 2016.4" *) 
(* NotValidForBitStream *)
module DSP_0
   (CLK,
    CE,
    SCLR,
    A,
    B,
    C,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) input CE;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) input [17:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) input [17:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 c_intf DATA" *) input [47:0]C;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) output [47:0]P;

  wire [17:0]A;
  wire [17:0]B;
  wire [47:0]C;
  wire CE;
  wire CLK;
  wire [47:0]P;
  wire SCLR;
  wire NLW_U0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_U0_CARRYOUT_UNCONNECTED;
  wire [29:0]NLW_U0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_U0_BCOUT_UNCONNECTED;
  wire [47:0]NLW_U0_PCOUT_UNCONNECTED;

  (* C_A_WIDTH = "18" *) 
  (* C_B_WIDTH = "18" *) 
  (* C_CONCAT_WIDTH = "48" *) 
  (* C_CONSTANT_1 = "1" *) 
  (* C_C_WIDTH = "48" *) 
  (* C_D_WIDTH = "18" *) 
  (* C_HAS_A = "1" *) 
  (* C_HAS_ACIN = "0" *) 
  (* C_HAS_ACOUT = "0" *) 
  (* C_HAS_B = "1" *) 
  (* C_HAS_BCIN = "0" *) 
  (* C_HAS_BCOUT = "0" *) 
  (* C_HAS_C = "1" *) 
  (* C_HAS_CARRYCASCIN = "0" *) 
  (* C_HAS_CARRYCASCOUT = "0" *) 
  (* C_HAS_CARRYIN = "0" *) 
  (* C_HAS_CARRYOUT = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_CEA = "0" *) 
  (* C_HAS_CEB = "0" *) 
  (* C_HAS_CEC = "0" *) 
  (* C_HAS_CECONCAT = "0" *) 
  (* C_HAS_CED = "0" *) 
  (* C_HAS_CEM = "0" *) 
  (* C_HAS_CEP = "0" *) 
  (* C_HAS_CESEL = "0" *) 
  (* C_HAS_CONCAT = "0" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_INDEP_CE = "0" *) 
  (* C_HAS_INDEP_SCLR = "0" *) 
  (* C_HAS_PCIN = "0" *) 
  (* C_HAS_PCOUT = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SCLRA = "0" *) 
  (* C_HAS_SCLRB = "0" *) 
  (* C_HAS_SCLRC = "0" *) 
  (* C_HAS_SCLRCONCAT = "0" *) 
  (* C_HAS_SCLRD = "0" *) 
  (* C_HAS_SCLRM = "0" *) 
  (* C_HAS_SCLRP = "0" *) 
  (* C_HAS_SCLRSEL = "0" *) 
  (* C_LATENCY = "128" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_OPMODES = "000000000011010100000000" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "47" *) 
  (* C_REG_CONFIG = "00000000000011000011000001000100" *) 
  (* C_SEL_WIDTH = "0" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  DSP_0_xbip_dsp48_macro_v3_0_13 U0
       (.A(A),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_U0_ACOUT_UNCONNECTED[29:0]),
        .B(B),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_U0_BCOUT_UNCONNECTED[17:0]),
        .C(C),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_U0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYOUT(NLW_U0_CARRYOUT_UNCONNECTED),
        .CE(CE),
        .CEA(1'b1),
        .CEA1(1'b1),
        .CEA2(1'b1),
        .CEA3(1'b1),
        .CEA4(1'b1),
        .CEB(1'b1),
        .CEB1(1'b1),
        .CEB2(1'b1),
        .CEB3(1'b1),
        .CEB4(1'b1),
        .CEC(1'b1),
        .CEC1(1'b1),
        .CEC2(1'b1),
        .CEC3(1'b1),
        .CEC4(1'b1),
        .CEC5(1'b1),
        .CECONCAT(1'b1),
        .CECONCAT3(1'b1),
        .CECONCAT4(1'b1),
        .CECONCAT5(1'b1),
        .CED(1'b1),
        .CED1(1'b1),
        .CED2(1'b1),
        .CED3(1'b1),
        .CEM(1'b1),
        .CEP(1'b1),
        .CESEL(1'b1),
        .CESEL1(1'b1),
        .CESEL2(1'b1),
        .CESEL3(1'b1),
        .CESEL4(1'b1),
        .CESEL5(1'b1),
        .CLK(CLK),
        .CONCAT({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .P(P),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_U0_PCOUT_UNCONNECTED[47:0]),
        .SCLR(SCLR),
        .SCLRA(1'b0),
        .SCLRB(1'b0),
        .SCLRC(1'b0),
        .SCLRCONCAT(1'b0),
        .SCLRD(1'b0),
        .SCLRM(1'b0),
        .SCLRP(1'b0),
        .SCLRSEL(1'b0),
        .SEL(1'b0));
endmodule

(* C_A_WIDTH = "18" *) (* C_B_WIDTH = "18" *) (* C_CONCAT_WIDTH = "48" *) 
(* C_CONSTANT_1 = "1" *) (* C_C_WIDTH = "48" *) (* C_D_WIDTH = "18" *) 
(* C_HAS_A = "1" *) (* C_HAS_ACIN = "0" *) (* C_HAS_ACOUT = "0" *) 
(* C_HAS_B = "1" *) (* C_HAS_BCIN = "0" *) (* C_HAS_BCOUT = "0" *) 
(* C_HAS_C = "1" *) (* C_HAS_CARRYCASCIN = "0" *) (* C_HAS_CARRYCASCOUT = "0" *) 
(* C_HAS_CARRYIN = "0" *) (* C_HAS_CARRYOUT = "0" *) (* C_HAS_CE = "1" *) 
(* C_HAS_CEA = "0" *) (* C_HAS_CEB = "0" *) (* C_HAS_CEC = "0" *) 
(* C_HAS_CECONCAT = "0" *) (* C_HAS_CED = "0" *) (* C_HAS_CEM = "0" *) 
(* C_HAS_CEP = "0" *) (* C_HAS_CESEL = "0" *) (* C_HAS_CONCAT = "0" *) 
(* C_HAS_D = "0" *) (* C_HAS_INDEP_CE = "0" *) (* C_HAS_INDEP_SCLR = "0" *) 
(* C_HAS_PCIN = "0" *) (* C_HAS_PCOUT = "0" *) (* C_HAS_SCLR = "1" *) 
(* C_HAS_SCLRA = "0" *) (* C_HAS_SCLRB = "0" *) (* C_HAS_SCLRC = "0" *) 
(* C_HAS_SCLRCONCAT = "0" *) (* C_HAS_SCLRD = "0" *) (* C_HAS_SCLRM = "0" *) 
(* C_HAS_SCLRP = "0" *) (* C_HAS_SCLRSEL = "0" *) (* C_LATENCY = "128" *) 
(* C_MODEL_TYPE = "0" *) (* C_OPMODES = "000000000011010100000000" *) (* C_P_LSB = "0" *) 
(* C_P_MSB = "47" *) (* C_REG_CONFIG = "00000000000011000011000001000100" *) (* C_SEL_WIDTH = "0" *) 
(* C_TEST_CORE = "0" *) (* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "kintex7" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module DSP_0_xbip_dsp48_macro_v3_0_13
   (CLK,
    CE,
    SCLR,
    SEL,
    CARRYCASCIN,
    CARRYIN,
    PCIN,
    ACIN,
    BCIN,
    A,
    B,
    C,
    D,
    CONCAT,
    ACOUT,
    BCOUT,
    CARRYOUT,
    CARRYCASCOUT,
    PCOUT,
    P,
    CED,
    CED1,
    CED2,
    CED3,
    CEA,
    CEA1,
    CEA2,
    CEA3,
    CEA4,
    CEB,
    CEB1,
    CEB2,
    CEB3,
    CEB4,
    CECONCAT,
    CECONCAT3,
    CECONCAT4,
    CECONCAT5,
    CEC,
    CEC1,
    CEC2,
    CEC3,
    CEC4,
    CEC5,
    CEM,
    CEP,
    CESEL,
    CESEL1,
    CESEL2,
    CESEL3,
    CESEL4,
    CESEL5,
    SCLRD,
    SCLRA,
    SCLRB,
    SCLRCONCAT,
    SCLRC,
    SCLRM,
    SCLRP,
    SCLRSEL);
  input CLK;
  input CE;
  input SCLR;
  input [0:0]SEL;
  input CARRYCASCIN;
  input CARRYIN;
  input [47:0]PCIN;
  input [29:0]ACIN;
  input [17:0]BCIN;
  input [17:0]A;
  input [17:0]B;
  input [47:0]C;
  input [17:0]D;
  input [47:0]CONCAT;
  output [29:0]ACOUT;
  output [17:0]BCOUT;
  output CARRYOUT;
  output CARRYCASCOUT;
  output [47:0]PCOUT;
  output [47:0]P;
  input CED;
  input CED1;
  input CED2;
  input CED3;
  input CEA;
  input CEA1;
  input CEA2;
  input CEA3;
  input CEA4;
  input CEB;
  input CEB1;
  input CEB2;
  input CEB3;
  input CEB4;
  input CECONCAT;
  input CECONCAT3;
  input CECONCAT4;
  input CECONCAT5;
  input CEC;
  input CEC1;
  input CEC2;
  input CEC3;
  input CEC4;
  input CEC5;
  input CEM;
  input CEP;
  input CESEL;
  input CESEL1;
  input CESEL2;
  input CESEL3;
  input CESEL4;
  input CESEL5;
  input SCLRD;
  input SCLRA;
  input SCLRB;
  input SCLRCONCAT;
  input SCLRC;
  input SCLRM;
  input SCLRP;
  input SCLRSEL;

  wire [17:0]A;
  wire [29:0]ACIN;
  wire [29:0]ACOUT;
  wire [17:0]B;
  wire [17:0]BCIN;
  wire [17:0]BCOUT;
  wire [47:0]C;
  wire CARRYCASCIN;
  wire CARRYCASCOUT;
  wire CARRYOUT;
  wire CE;
  wire CLK;
  wire [47:0]P;
  wire [47:0]PCIN;
  wire [47:0]PCOUT;
  wire SCLR;

  (* C_A_WIDTH = "18" *) 
  (* C_B_WIDTH = "18" *) 
  (* C_CONCAT_WIDTH = "48" *) 
  (* C_CONSTANT_1 = "1" *) 
  (* C_C_WIDTH = "48" *) 
  (* C_D_WIDTH = "18" *) 
  (* C_HAS_A = "1" *) 
  (* C_HAS_ACIN = "0" *) 
  (* C_HAS_ACOUT = "0" *) 
  (* C_HAS_B = "1" *) 
  (* C_HAS_BCIN = "0" *) 
  (* C_HAS_BCOUT = "0" *) 
  (* C_HAS_C = "1" *) 
  (* C_HAS_CARRYCASCIN = "0" *) 
  (* C_HAS_CARRYCASCOUT = "0" *) 
  (* C_HAS_CARRYIN = "0" *) 
  (* C_HAS_CARRYOUT = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_CEA = "0" *) 
  (* C_HAS_CEB = "0" *) 
  (* C_HAS_CEC = "0" *) 
  (* C_HAS_CECONCAT = "0" *) 
  (* C_HAS_CED = "0" *) 
  (* C_HAS_CEM = "0" *) 
  (* C_HAS_CEP = "0" *) 
  (* C_HAS_CESEL = "0" *) 
  (* C_HAS_CONCAT = "0" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_INDEP_CE = "0" *) 
  (* C_HAS_INDEP_SCLR = "0" *) 
  (* C_HAS_PCIN = "0" *) 
  (* C_HAS_PCOUT = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SCLRA = "0" *) 
  (* C_HAS_SCLRB = "0" *) 
  (* C_HAS_SCLRC = "0" *) 
  (* C_HAS_SCLRCONCAT = "0" *) 
  (* C_HAS_SCLRD = "0" *) 
  (* C_HAS_SCLRM = "0" *) 
  (* C_HAS_SCLRP = "0" *) 
  (* C_HAS_SCLRSEL = "0" *) 
  (* C_LATENCY = "128" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_OPMODES = "000000000011010100000000" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "47" *) 
  (* C_REG_CONFIG = "00000000000011000011000001000100" *) 
  (* C_SEL_WIDTH = "0" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  DSP_0_xbip_dsp48_macro_v3_0_13_viv i_synth
       (.A(A),
        .ACIN(ACIN),
        .ACOUT(ACOUT),
        .B(B),
        .BCIN(BCIN),
        .BCOUT(BCOUT),
        .C(C),
        .CARRYCASCIN(CARRYCASCIN),
        .CARRYCASCOUT(CARRYCASCOUT),
        .CARRYIN(1'b0),
        .CARRYOUT(CARRYOUT),
        .CE(CE),
        .CEA(1'b0),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEA3(1'b0),
        .CEA4(1'b0),
        .CEB(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEB3(1'b0),
        .CEB4(1'b0),
        .CEC(1'b0),
        .CEC1(1'b0),
        .CEC2(1'b0),
        .CEC3(1'b0),
        .CEC4(1'b0),
        .CEC5(1'b0),
        .CECONCAT(1'b0),
        .CECONCAT3(1'b0),
        .CECONCAT4(1'b0),
        .CECONCAT5(1'b0),
        .CED(1'b0),
        .CED1(1'b0),
        .CED2(1'b0),
        .CED3(1'b0),
        .CEM(1'b0),
        .CEP(1'b0),
        .CESEL(1'b0),
        .CESEL1(1'b0),
        .CESEL2(1'b0),
        .CESEL3(1'b0),
        .CESEL4(1'b0),
        .CESEL5(1'b0),
        .CLK(CLK),
        .CONCAT({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .P(P),
        .PCIN(PCIN),
        .PCOUT(PCOUT),
        .SCLR(SCLR),
        .SCLRA(1'b0),
        .SCLRB(1'b0),
        .SCLRC(1'b0),
        .SCLRCONCAT(1'b0),
        .SCLRD(1'b0),
        .SCLRM(1'b0),
        .SCLRP(1'b0),
        .SCLRSEL(1'b0),
        .SEL(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
Imcj5dzp84zlDYWCBppi7yNWTwzNqG3FkqH+fqzm2TQWQzZ0E0aAVHvIdlEiTui9+yTBhqfrd8xD
L1LA6fSIPA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
PcEQa/E6pSNIAFQ4ujV39SYV1v8vWhB5YNytayWhn2sxtt5nwpGith0LiE5Fup3kgMi2+57qXNiC
Cdf0t+i/XSxjVms15BNMjamRxPaXCtXhL9G3zLXOTWDb8Zo+lCXXa2AFBcQeyBYoj0ULdLtz0o4G
dNxfLYGQXpAVAbjbe+Y=

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
xP7GlIOF4GFV/OUJ4uY5XUzC8PmStPPYDjVP+OsDJvEMGy/3J9js5bCg2p+Tu/ZdIZPHHs/OpaFz
75HWDp9KmLjZtkWF3IXUvjXcwh+Gvte0CIXnBQarH8yW/xAGWgn41DkdtIYZuREcMLnJduDsdlRr
W/iPac1s06K1hL0wyow=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
za4oTiHoz7JxYfBdP1DVCEe1o2RTD+ELhRS4Lpbplb4UcrRNQj3NxbNZbLekvpGzZzoVdn9+N4CR
yRWRDGuNTq3mQ9DDYs2p9GWQmkK7reXJha+LuDL8s6NmXABbPn7du1HdKXfU08nFrwXtsdugYW3a
ErBp1Gce3HOvNk2yL7+8jNHrdDNxOyVPq95iRT867OtkiVfLZzfZPAMOvpUHp80MVWBGNhhhkcKC
1y8zU1tlI/P86XNcJqk/pJFfDpkieY/bdjRHTYccCiBHsECs46M+4SPi78FJLMR3C6ZPCiO3OHLm
fm+okJX5sy8ZnXR73eX8UHDC3dw9OeWXlqA2tA==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rcNes+W8ih1bjpayqWFxqATnSL02F0mNOgxd8CnsYgMbRHS0XNxSb8YMGq2SQXfaV1BxiIkrznqT
prO63cEAK2L/Ed6xbOelKZdGNkGwDKMog+b6O7MxaDZHcvcg/xyDtXxf/vwOHVKOV8Ba4iq8nXDS
3fgtDC5ReNmeyRVMlpUySWRgMRgYoL7ldkZ13VBs324uxTMu1S1oderBJJ2YnCPTDkUj7w9FsqTb
BdHdoktsLVb5uxXq5cMhCosxoGDmr62eTmBsL2BRgy++8OdBUNi+Q855XJti1Eq4rRiG3CnscpuW
ilTY3EhQ9x0SKHfkCLPqWGp4CnN4xeqidK8StA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinx_2016_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Xv7e5H8YmLzuuS6qHEMswMjrJ0rusuTkdlPpfth82AKAxyxG1ChUZr93qobfvbqwVP6vAb4w9kz9
ng6RG17euBbG9YuHYvzUdi3uKxwukYAlwCZL0yJOp9tH0BJsS5rru8SxiPs/QT6MuWW6f1RXYe75
LvZXlft3H+0LRAnYfwb6kjyHPuDRp5i7tJSU9suzzPDsnPRk37o7oiW291nxZZu3anSUDg1zQJSf
qZfeNmJldalAMAwrF5wApoC06DQ0DWnpGGb2cZekaooL6yeTv4LMOZdu21WzIiKdtVL186GSxQ1+
0QwesnxWGjeFC2K0eaJnhNYEJ+R1f+YtspAYeQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="base64", line_length=76, bytes=256)
`pragma protect key_block
Im3rIFqO8Umb2V4oqLreoSB0szutTqUGhNH1iDdbmyf+o7fw/UslwFBRKFJlvL+KnQm86wQAADoG
3aT4BSJc21QIiQMkjVF3bjsY8Oj/u7I/2wfpOfigwnP4q+dsclEu5Imldu1BuCpZppBJaBpSvnlA
DWlGmN6HdT9YU1X1jsyyke+Suk/lOYVQlCxfSQR70GCJIIshlMY64JkNbYK/ip+SK803G54OROZf
aFHixDLmbmxKpLc5RgfaI0JnMgENMnNPSolgXxL1x388B9Hi01bg9zzQyPr7p70whPgV6iTR4hAz
Y7As/FPcXnnrRS1yjOwdhnnyDcagQra31R7sUA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP05_001", key_method="rsa"
`pragma protect encoding = (enctype="base64", line_length=76, bytes=256)
`pragma protect key_block
bVCUWxgtILZXF2Oa/YMiHLecj69RqTi8vbaDYmBhmBTE5DPW6mo0evDeNf09r6YD5wLr+4nLHb5G
G5XckN3ytA5z7Ugpmu/x7H9hQOBDoztb4T9H3qmYRjEkX0a/jsaT5gwr4Vlj/sQYql9//pmmqbfa
xEmmrYl9TZD/hAJGv9b42h0Yw1jJI4iGOUwCkcfR1/csTKLhosmjf+pf+FF+78nFy3v3x4KbIePo
0fUP1VGcLUGa5rTGJJf18W8abw6c9N3N/yvXTuUQCeW5dVcNhNkQjsFjdO/2g5h4JWE86y2QaOHM
ygUxWaFyuilhoZouREUDPoDb+cWlP5TbJ1UNhg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 8640)
`pragma protect data_block
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
me4G3OOvMi/NSfoNkhu9mF8NbNxJ7wcYzjeRYA==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
