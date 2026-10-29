// Verilog netlist created by Tang Dynasty v5.6.71036
// Fri Sep 22 12:01:28 2023

`timescale 1ns / 1ps
module w40_d512_fifo  // w40_d512_fifo.v(14)
  (
  clk,
  di,
  re,
  rst,
  we,
  dout,
  empty_flag,
  full_flag,
  rdusedw,
  wrusedw
  );

  input clk;  // w40_d512_fifo.v(24)
  input [39:0] di;  // w40_d512_fifo.v(23)
  input re;  // w40_d512_fifo.v(25)
  input rst;  // w40_d512_fifo.v(22)
  input we;  // w40_d512_fifo.v(24)
  output [39:0] dout;  // w40_d512_fifo.v(27)
  output empty_flag;  // w40_d512_fifo.v(28)
  output full_flag;  // w40_d512_fifo.v(29)
  output [8:0] rdusedw;  // w40_d512_fifo.v(30)
  output [8:0] wrusedw;  // w40_d512_fifo.v(31)

  wire logic_ramfifo_syn_1;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_2;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_3;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_4;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_5;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_6;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_7;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_8;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_9;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_10;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_11;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_12;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_13;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_14;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_15;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_16;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_17;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_18;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_19;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_20;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_21;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_22;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_23;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_24;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_25;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_26;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_27;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_37;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_38;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_39;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_40;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_41;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_42;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_43;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_44;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_45;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_46;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_47;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_48;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_49;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_50;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_51;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_52;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_53;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_54;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_55;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_56;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_57;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_58;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_59;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_60;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_61;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_62;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_64;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_65;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_66;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_67;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_68;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_69;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_70;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_71;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_72;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_73;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_74;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_75;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_76;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_77;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_78;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_79;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_80;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_81;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_82;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_83;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_84;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_85;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_86;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_87;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_88;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_89;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_152;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_154;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_158;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_159;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_160;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_161;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_162;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_163;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_164;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_165;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_166;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_167;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_171;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_173;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_227;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_247;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_248;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_249;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_250;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_251;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_252;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_253;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_254;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_255;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_271;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_273;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_275;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_277;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_279;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_281;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_283;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_285;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_290;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_292;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_294;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_296;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_298;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_300;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_302;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_306;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_308;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_310;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_312;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_314;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_316;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_318;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_320;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_325;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_327;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_329;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_331;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_333;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_335;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_337;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_533;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_534;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_535;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_536;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_537;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_538;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_539;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_540;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_541;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_542;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_543;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_544;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_545;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_546;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_547;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_548;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_549;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_587;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_588;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_589;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_590;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_591;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_592;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_593;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_594;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_595;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_596;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_597;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_598;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_599;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_600;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_601;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_602;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_603;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_642;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_643;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_644;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_645;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_646;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_647;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_648;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_649;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_650;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_690;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_691;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_692;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_693;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_694;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_695;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_696;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_697;  // w40_d512_fifo.v(39)
  wire logic_ramfifo_syn_698;  // w40_d512_fifo.v(39)
  wire clk_syn_1;  // w40_d512_fifo.v(24)
  wire clk_syn_2;  // w40_d512_fifo.v(24)
  wire clk_syn_3;  // w40_d512_fifo.v(24)
  wire clk_syn_4;  // w40_d512_fifo.v(24)
  wire clk_syn_5;  // w40_d512_fifo.v(24)
  wire clk_syn_6;  // w40_d512_fifo.v(24)
  wire clk_syn_7;  // w40_d512_fifo.v(24)
  wire clk_syn_8;  // w40_d512_fifo.v(24)
  wire clk_syn_9;  // w40_d512_fifo.v(24)
  wire clk_syn_10;  // w40_d512_fifo.v(24)
  wire clk_syn_12;  // w40_d512_fifo.v(24)
  wire clk_syn_14;  // w40_d512_fifo.v(24)
  wire clk_syn_16;  // w40_d512_fifo.v(24)
  wire clk_syn_18;  // w40_d512_fifo.v(24)
  wire clk_syn_20;  // w40_d512_fifo.v(24)
  wire clk_syn_22;  // w40_d512_fifo.v(24)
  wire clk_syn_24;  // w40_d512_fifo.v(24)
  wire clk_syn_26;  // w40_d512_fifo.v(24)
  wire clk_syn_28;  // w40_d512_fifo.v(24)
  wire clk_syn_34;  // w40_d512_fifo.v(24)
  wire clk_syn_36;  // w40_d512_fifo.v(24)
  wire clk_syn_38;  // w40_d512_fifo.v(24)
  wire clk_syn_40;  // w40_d512_fifo.v(24)
  wire clk_syn_42;  // w40_d512_fifo.v(24)
  wire clk_syn_44;  // w40_d512_fifo.v(24)
  wire clk_syn_46;  // w40_d512_fifo.v(24)
  wire clk_syn_48;  // w40_d512_fifo.v(24)
  wire clk_syn_50;  // w40_d512_fifo.v(24)
  wire clk_syn_52;  // w40_d512_fifo.v(24)
  wire clk_syn_54;  // w40_d512_fifo.v(24)
  wire clk_syn_56;  // w40_d512_fifo.v(24)
  wire clk_syn_58;  // w40_d512_fifo.v(24)
  wire clk_syn_60;  // w40_d512_fifo.v(24)
  wire clk_syn_62;  // w40_d512_fifo.v(24)
  wire clk_syn_64;  // w40_d512_fifo.v(24)
  wire clk_syn_66;  // w40_d512_fifo.v(24)
  wire clk_syn_67;  // w40_d512_fifo.v(24)
  wire clk_syn_68;  // w40_d512_fifo.v(24)
  wire clk_syn_69;  // w40_d512_fifo.v(24)
  wire clk_syn_70;  // w40_d512_fifo.v(24)
  wire clk_syn_71;  // w40_d512_fifo.v(24)
  wire clk_syn_72;  // w40_d512_fifo.v(24)
  wire clk_syn_73;  // w40_d512_fifo.v(24)
  wire clk_syn_74;  // w40_d512_fifo.v(24)
  wire clk_syn_75;  // w40_d512_fifo.v(24)
  wire clk_syn_76;  // w40_d512_fifo.v(24)
  wire clk_syn_78;  // w40_d512_fifo.v(24)
  wire clk_syn_79;  // w40_d512_fifo.v(24)
  wire clk_syn_80;  // w40_d512_fifo.v(24)
  wire clk_syn_81;  // w40_d512_fifo.v(24)
  wire clk_syn_82;  // w40_d512_fifo.v(24)
  wire clk_syn_83;  // w40_d512_fifo.v(24)
  wire clk_syn_84;  // w40_d512_fifo.v(24)
  wire clk_syn_85;  // w40_d512_fifo.v(24)
  wire clk_syn_86;  // w40_d512_fifo.v(24)
  wire clk_syn_87;  // w40_d512_fifo.v(24)
  wire clk_syn_89;  // w40_d512_fifo.v(24)
  wire clk_syn_93;  // w40_d512_fifo.v(24)
  wire clk_syn_95;  // w40_d512_fifo.v(24)
  wire clk_syn_97;  // w40_d512_fifo.v(24)
  wire clk_syn_99;  // w40_d512_fifo.v(24)
  wire clk_syn_101;  // w40_d512_fifo.v(24)
  wire clk_syn_103;  // w40_d512_fifo.v(24)
  wire clk_syn_105;  // w40_d512_fifo.v(24)
  wire clk_syn_107;  // w40_d512_fifo.v(24)
  wire clk_syn_111;  // w40_d512_fifo.v(24)
  wire clk_syn_113;  // w40_d512_fifo.v(24)
  wire clk_syn_115;  // w40_d512_fifo.v(24)
  wire clk_syn_117;  // w40_d512_fifo.v(24)
  wire clk_syn_119;  // w40_d512_fifo.v(24)
  wire clk_syn_121;  // w40_d512_fifo.v(24)
  wire clk_syn_123;  // w40_d512_fifo.v(24)
  wire clk_syn_125;  // w40_d512_fifo.v(24)
  wire clk_syn_127;  // w40_d512_fifo.v(24)
  wire clk_syn_129;  // w40_d512_fifo.v(24)
  wire clk_syn_131;  // w40_d512_fifo.v(24)
  wire clk_syn_133;  // w40_d512_fifo.v(24)
  wire clk_syn_135;  // w40_d512_fifo.v(24)
  wire clk_syn_137;  // w40_d512_fifo.v(24)
  wire clk_syn_139;  // w40_d512_fifo.v(24)
  wire clk_syn_141;  // w40_d512_fifo.v(24)
  wire clk_syn_143;  // w40_d512_fifo.v(24)
  wire clk_syn_144;  // w40_d512_fifo.v(24)
  wire clk_syn_145;  // w40_d512_fifo.v(24)
  wire clk_syn_146;  // w40_d512_fifo.v(24)
  wire clk_syn_147;  // w40_d512_fifo.v(24)
  wire clk_syn_148;  // w40_d512_fifo.v(24)
  wire clk_syn_149;  // w40_d512_fifo.v(24)
  wire clk_syn_150;  // w40_d512_fifo.v(24)
  wire clk_syn_151;  // w40_d512_fifo.v(24)
  wire clk_syn_152;  // w40_d512_fifo.v(24)
  wire clk_syn_153;  // w40_d512_fifo.v(24)
  wire re_syn_2;  // w40_d512_fifo.v(25)
  wire we_syn_2;  // w40_d512_fifo.v(24)
  wire _al_n1_syn_4;
  wire _al_n1_syn_6;
  wire _al_n1_syn_8;
  wire _al_n1_syn_10;
  wire _al_n1_syn_12;
  wire _al_n1_syn_14;
  wire _al_n1_syn_16;
  wire _al_n1_syn_24;
  wire _al_n1_syn_26;
  wire _al_n1_syn_28;
  wire _al_n1_syn_30;
  wire _al_n1_syn_32;
  wire _al_n1_syn_34;
  wire _al_n1_syn_36;

  and _al_n1_syn_11 (_al_n1_syn_12, _al_n1_syn_10, clk_syn_24);
  and _al_n1_syn_13 (_al_n1_syn_14, _al_n1_syn_12, clk_syn_26);
  and _al_n1_syn_15 (_al_n1_syn_16, _al_n1_syn_14, clk_syn_28);
  and _al_n1_syn_23 (_al_n1_syn_24, clk_syn_107, clk_syn_93);
  and _al_n1_syn_25 (_al_n1_syn_26, _al_n1_syn_24, clk_syn_95);
  and _al_n1_syn_27 (_al_n1_syn_28, _al_n1_syn_26, clk_syn_97);
  and _al_n1_syn_29 (_al_n1_syn_30, _al_n1_syn_28, clk_syn_99);
  and _al_n1_syn_3 (_al_n1_syn_4, clk_syn_14, clk_syn_16);
  and _al_n1_syn_31 (_al_n1_syn_32, _al_n1_syn_30, clk_syn_101);
  and _al_n1_syn_33 (_al_n1_syn_34, _al_n1_syn_32, clk_syn_103);
  and _al_n1_syn_35 (_al_n1_syn_36, _al_n1_syn_34, clk_syn_105);
  and _al_n1_syn_5 (_al_n1_syn_6, _al_n1_syn_4, clk_syn_18);
  and _al_n1_syn_7 (_al_n1_syn_8, _al_n1_syn_6, clk_syn_20);
  and _al_n1_syn_9 (_al_n1_syn_10, _al_n1_syn_8, clk_syn_22);
  not clk_syn_100 (clk_syn_101, clk_syn_83);  // w40_d512_fifo.v(24)
  not clk_syn_102 (clk_syn_103, clk_syn_84);  // w40_d512_fifo.v(24)
  not clk_syn_104 (clk_syn_105, clk_syn_85);  // w40_d512_fifo.v(24)
  not clk_syn_106 (clk_syn_107, clk_syn_78);  // w40_d512_fifo.v(24)
  or clk_syn_11 (clk_syn_12, clk_syn_10, clk_syn_9);  // w40_d512_fifo.v(24)
  xor clk_syn_110 (clk_syn_111, clk_syn_79, clk_syn_78);  // w40_d512_fifo.v(24)
  and clk_syn_112 (clk_syn_113, clk_syn_79, clk_syn_107);  // w40_d512_fifo.v(24)
  xor clk_syn_114 (clk_syn_115, clk_syn_80, clk_syn_113);  // w40_d512_fifo.v(24)
  and clk_syn_116 (clk_syn_117, clk_syn_80, _al_n1_syn_24);  // w40_d512_fifo.v(24)
  xor clk_syn_118 (clk_syn_119, clk_syn_81, clk_syn_117);  // w40_d512_fifo.v(24)
  and clk_syn_120 (clk_syn_121, clk_syn_81, _al_n1_syn_26);  // w40_d512_fifo.v(24)
  xor clk_syn_122 (clk_syn_123, clk_syn_82, clk_syn_121);  // w40_d512_fifo.v(24)
  and clk_syn_124 (clk_syn_125, clk_syn_82, _al_n1_syn_28);  // w40_d512_fifo.v(24)
  xor clk_syn_126 (clk_syn_127, clk_syn_83, clk_syn_125);  // w40_d512_fifo.v(24)
  and clk_syn_128 (clk_syn_129, clk_syn_83, _al_n1_syn_30);  // w40_d512_fifo.v(24)
  not clk_syn_13 (clk_syn_14, clk_syn_1);  // w40_d512_fifo.v(24)
  xor clk_syn_130 (clk_syn_131, clk_syn_84, clk_syn_129);  // w40_d512_fifo.v(24)
  and clk_syn_132 (clk_syn_133, clk_syn_84, _al_n1_syn_32);  // w40_d512_fifo.v(24)
  xor clk_syn_134 (clk_syn_135, clk_syn_85, clk_syn_133);  // w40_d512_fifo.v(24)
  and clk_syn_136 (clk_syn_137, clk_syn_85, _al_n1_syn_34);  // w40_d512_fifo.v(24)
  xor clk_syn_138 (clk_syn_139, clk_syn_86, clk_syn_137);  // w40_d512_fifo.v(24)
  and clk_syn_140 (clk_syn_141, clk_syn_89, _al_n1_syn_36);  // w40_d512_fifo.v(24)
  xor clk_syn_142 (clk_syn_143, clk_syn_87, clk_syn_141);  // w40_d512_fifo.v(24)
  not clk_syn_15 (clk_syn_16, clk_syn_2);  // w40_d512_fifo.v(24)
  not clk_syn_17 (clk_syn_18, clk_syn_3);  // w40_d512_fifo.v(24)
  not clk_syn_19 (clk_syn_20, clk_syn_4);  // w40_d512_fifo.v(24)
  not clk_syn_21 (clk_syn_22, clk_syn_5);  // w40_d512_fifo.v(24)
  not clk_syn_23 (clk_syn_24, clk_syn_6);  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_232 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_67),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_1));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_233 (
    .ar(1'b0),
    .as(rst),
    .clk(clk),
    .d(clk_syn_68),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_2));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_234 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_69),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_3));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_235 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_70),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_4));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_236 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_71),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_5));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_237 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_72),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_6));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_238 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_73),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_7));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_239 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_74),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_8));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_240 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_75),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_9));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_241 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_76),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_10));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_242 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_144),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_78));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_243 (
    .ar(1'b0),
    .as(rst),
    .clk(clk),
    .d(clk_syn_145),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_79));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_244 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_146),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_80));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_245 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_147),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_81));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_246 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_148),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_82));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_247 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_149),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_83));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_248 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_150),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_84));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_249 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_151),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_85));  // w40_d512_fifo.v(24)
  not clk_syn_25 (clk_syn_26, clk_syn_7);  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_250 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_152),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_86));  // w40_d512_fifo.v(24)
  AL_DFF_X clk_syn_251 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(clk_syn_153),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(clk_syn_87));  // w40_d512_fifo.v(24)
  not clk_syn_27 (clk_syn_28, clk_syn_8);  // w40_d512_fifo.v(24)
  xor clk_syn_33 (clk_syn_34, clk_syn_2, clk_syn_1);  // w40_d512_fifo.v(24)
  and clk_syn_35 (clk_syn_36, clk_syn_2, clk_syn_14);  // w40_d512_fifo.v(24)
  xor clk_syn_37 (clk_syn_38, clk_syn_3, clk_syn_36);  // w40_d512_fifo.v(24)
  and clk_syn_39 (clk_syn_40, clk_syn_3, _al_n1_syn_4);  // w40_d512_fifo.v(24)
  xor clk_syn_41 (clk_syn_42, clk_syn_4, clk_syn_40);  // w40_d512_fifo.v(24)
  and clk_syn_43 (clk_syn_44, clk_syn_4, _al_n1_syn_6);  // w40_d512_fifo.v(24)
  xor clk_syn_45 (clk_syn_46, clk_syn_5, clk_syn_44);  // w40_d512_fifo.v(24)
  and clk_syn_47 (clk_syn_48, clk_syn_5, _al_n1_syn_8);  // w40_d512_fifo.v(24)
  xor clk_syn_49 (clk_syn_50, clk_syn_6, clk_syn_48);  // w40_d512_fifo.v(24)
  and clk_syn_51 (clk_syn_52, clk_syn_6, _al_n1_syn_10);  // w40_d512_fifo.v(24)
  xor clk_syn_53 (clk_syn_54, clk_syn_7, clk_syn_52);  // w40_d512_fifo.v(24)
  and clk_syn_55 (clk_syn_56, clk_syn_7, _al_n1_syn_12);  // w40_d512_fifo.v(24)
  xor clk_syn_57 (clk_syn_58, clk_syn_8, clk_syn_56);  // w40_d512_fifo.v(24)
  and clk_syn_59 (clk_syn_60, clk_syn_8, _al_n1_syn_14);  // w40_d512_fifo.v(24)
  xor clk_syn_61 (clk_syn_62, clk_syn_9, clk_syn_60);  // w40_d512_fifo.v(24)
  and clk_syn_63 (clk_syn_64, clk_syn_12, _al_n1_syn_16);  // w40_d512_fifo.v(24)
  xor clk_syn_65 (clk_syn_66, clk_syn_10, clk_syn_64);  // w40_d512_fifo.v(24)
  or clk_syn_88 (clk_syn_89, clk_syn_87, clk_syn_86);  // w40_d512_fifo.v(24)
  not clk_syn_92 (clk_syn_93, clk_syn_79);  // w40_d512_fifo.v(24)
  not clk_syn_94 (clk_syn_95, clk_syn_80);  // w40_d512_fifo.v(24)
  not clk_syn_96 (clk_syn_97, clk_syn_81);  // w40_d512_fifo.v(24)
  not clk_syn_98 (clk_syn_99, clk_syn_82);  // w40_d512_fifo.v(24)
  PH1_PHY_CONFIG_V2 #(
    .JTAG_PERSISTN("DISABLE"),
    .SPIX4_PERSISTN("ENABLE"))
    config_inst ();
  not logic_ramfifo_syn_151 (logic_ramfifo_syn_152, logic_ramfifo_syn_44);  // w40_d512_fifo.v(39)
  not logic_ramfifo_syn_153 (logic_ramfifo_syn_154, logic_ramfifo_syn_45);  // w40_d512_fifo.v(39)
  not logic_ramfifo_syn_157 (logic_ramfifo_syn_158, full_flag);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_170 (logic_ramfifo_syn_171, logic_ramfifo_syn_27, logic_ramfifo_syn_26);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_172 (logic_ramfifo_syn_173, logic_ramfifo_syn_9, logic_ramfifo_syn_8);  // w40_d512_fifo.v(39)
  not logic_ramfifo_syn_226 (logic_ramfifo_syn_227, empty_flag);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_270 (logic_ramfifo_syn_271, logic_ramfifo_syn_45, logic_ramfifo_syn_44);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_272 (logic_ramfifo_syn_273, logic_ramfifo_syn_271, logic_ramfifo_syn_43);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_274 (logic_ramfifo_syn_275, logic_ramfifo_syn_273, logic_ramfifo_syn_42);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_276 (logic_ramfifo_syn_277, logic_ramfifo_syn_275, logic_ramfifo_syn_41);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_278 (logic_ramfifo_syn_279, logic_ramfifo_syn_277, logic_ramfifo_syn_40);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_280 (logic_ramfifo_syn_281, logic_ramfifo_syn_279, logic_ramfifo_syn_39);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_282 (logic_ramfifo_syn_283, logic_ramfifo_syn_281, logic_ramfifo_syn_38);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_284 (logic_ramfifo_syn_285, logic_ramfifo_syn_283, logic_ramfifo_syn_37);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_289 (logic_ramfifo_syn_290, logic_ramfifo_syn_173, logic_ramfifo_syn_7);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_291 (logic_ramfifo_syn_292, logic_ramfifo_syn_290, logic_ramfifo_syn_6);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_293 (logic_ramfifo_syn_294, logic_ramfifo_syn_292, logic_ramfifo_syn_5);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_295 (logic_ramfifo_syn_296, logic_ramfifo_syn_294, logic_ramfifo_syn_4);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_297 (logic_ramfifo_syn_298, logic_ramfifo_syn_296, logic_ramfifo_syn_3);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_299 (logic_ramfifo_syn_300, logic_ramfifo_syn_298, logic_ramfifo_syn_2);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_301 (logic_ramfifo_syn_302, logic_ramfifo_syn_300, logic_ramfifo_syn_1);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_305 (logic_ramfifo_syn_306, logic_ramfifo_syn_72, logic_ramfifo_syn_71);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_307 (logic_ramfifo_syn_308, logic_ramfifo_syn_306, logic_ramfifo_syn_70);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_309 (logic_ramfifo_syn_310, logic_ramfifo_syn_308, logic_ramfifo_syn_69);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_311 (logic_ramfifo_syn_312, logic_ramfifo_syn_310, logic_ramfifo_syn_68);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_313 (logic_ramfifo_syn_314, logic_ramfifo_syn_312, logic_ramfifo_syn_67);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_315 (logic_ramfifo_syn_316, logic_ramfifo_syn_314, logic_ramfifo_syn_66);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_317 (logic_ramfifo_syn_318, logic_ramfifo_syn_316, logic_ramfifo_syn_65);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_319 (logic_ramfifo_syn_320, logic_ramfifo_syn_318, logic_ramfifo_syn_64);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_324 (logic_ramfifo_syn_325, logic_ramfifo_syn_171, logic_ramfifo_syn_25);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_326 (logic_ramfifo_syn_327, logic_ramfifo_syn_325, logic_ramfifo_syn_24);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_328 (logic_ramfifo_syn_329, logic_ramfifo_syn_327, logic_ramfifo_syn_23);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_330 (logic_ramfifo_syn_331, logic_ramfifo_syn_329, logic_ramfifo_syn_22);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_332 (logic_ramfifo_syn_333, logic_ramfifo_syn_331, logic_ramfifo_syn_21);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_334 (logic_ramfifo_syn_335, logic_ramfifo_syn_333, logic_ramfifo_syn_20);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_336 (logic_ramfifo_syn_337, logic_ramfifo_syn_335, logic_ramfifo_syn_19);  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_362 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_159),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_1));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_363 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_160),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_2));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_364 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_161),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_3));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_365 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_162),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_4));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_366 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_163),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_5));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_367 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_164),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_6));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_368 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_165),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_7));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_369 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_166),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_8));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_370 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_167),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_9));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_371 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_1),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_10));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_372 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_2),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_11));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_373 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_3),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_12));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_374 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_4),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_13));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_375 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_5),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_14));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_376 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_6),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_15));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_377 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_7),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_16));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_378 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_8),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_17));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_379 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_9),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_18));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_383 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_247),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_19));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_384 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_248),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_20));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_385 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_249),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_21));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_386 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_250),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_22));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_387 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_251),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_23));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_388 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_252),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_24));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_389 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_253),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_25));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_390 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_254),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_26));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_391 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_255),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_27));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_401 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_19),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_37));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_402 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_20),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_38));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_403 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_21),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_39));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_404 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_22),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_40));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_405 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_23),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_41));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_406 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_24),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_42));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_407 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_25),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_43));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_408 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_26),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_44));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_409 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_27),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_45));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_410 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_285),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_46));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_411 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_283),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_47));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_412 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_281),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_48));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_413 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_279),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_49));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_414 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_277),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_50));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_415 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_275),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_51));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_416 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_273),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_52));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_417 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_271),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_53));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_418 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_45),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_54));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_419 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_302),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_55));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_420 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_300),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_56));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_421 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_298),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_57));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_422 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_296),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_58));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_423 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_294),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_59));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_424 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_292),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_60));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_425 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_290),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_61));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_426 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_173),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_62));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_428 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_10),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_64));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_429 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_11),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_65));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_430 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_12),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_66));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_431 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_13),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_67));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_432 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_14),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_68));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_433 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_15),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_69));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_434 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_16),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_70));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_435 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_17),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_71));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_436 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_18),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_72));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_437 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_320),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_73));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_438 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_318),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_74));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_439 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_316),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_75));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_440 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_314),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_76));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_441 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_312),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_77));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_442 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_310),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_78));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_443 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_308),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_79));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_444 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_306),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_80));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_445 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_72),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_81));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_446 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_337),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_82));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_447 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_335),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_83));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_448 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_333),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_84));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_449 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_331),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_85));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_450 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_329),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_86));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_451 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_327),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_87));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_452 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_325),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_88));  // w40_d512_fifo.v(39)
  AL_DFF_X logic_ramfifo_syn_453 (
    .ar(rst),
    .as(1'b0),
    .clk(clk),
    .d(logic_ramfifo_syn_171),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(logic_ramfifo_syn_89));  // w40_d512_fifo.v(39)
  // address_offset=0;data_offset=0;depth=256;width=40;num_section=1;width_per_section=40;section_size=40;working_depth=512;working_width=40;working_numbyte=1;mode_ecc=1;address_step=1;bytes_in_per_section=1;
  // logic_ramfifo_syn_339_256x40
  PH1_PHY_ERAM #(
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("SIG"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("SIG"),
    .DATA_WIDTH_A("40"),
    .DATA_WIDTH_B("40"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .MODE("DP20K"),
    .OCEAMUX("1"),
    .OCEBMUX("1"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE_A("SYNC"),
    .RESETMODE_B("SYNC"),
    .WEAMUX("1"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    logic_ramfifo_syn_455 (
    .addra({1'b0,logic_ramfifo_syn_173,logic_ramfifo_syn_7,logic_ramfifo_syn_6,logic_ramfifo_syn_5,logic_ramfifo_syn_4,logic_ramfifo_syn_3,logic_ramfifo_syn_2,logic_ramfifo_syn_1,5'b11111}),
    .addrb({1'b0,logic_ramfifo_syn_171,logic_ramfifo_syn_25,logic_ramfifo_syn_24,logic_ramfifo_syn_23,logic_ramfifo_syn_22,logic_ramfifo_syn_21,logic_ramfifo_syn_20,logic_ramfifo_syn_19,5'b11111}),
    .clka(clk),
    .clkb(clk),
    .csa({we_syn_2,open_n227,open_n228}),
    .csb({re_syn_2,open_n229,open_n230}),
    .dia(di[15:0]),
    .dia_extra(di[35:32]),
    .dib(di[31:16]),
    .dib_extra(di[39:36]),
    .ecc_dbiterrinj(1'b0),
    .ecc_sbiterrinj(1'b0),
    .orsta(rst),
    .orstb(rst),
    .doa(dout[15:0]),
    .doa_extra(dout[35:32]),
    .dob(dout[31:16]),
    .dob_extra(dout[39:36]));  // w40_d512_fifo.v(39)
  not logic_ramfifo_syn_496 (full_flag, logic_ramfifo_syn_549);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_497 (logic_ramfifo_syn_533, logic_ramfifo_syn_1, logic_ramfifo_syn_37);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_498 (logic_ramfifo_syn_534, logic_ramfifo_syn_2, logic_ramfifo_syn_38);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_499 (logic_ramfifo_syn_535, logic_ramfifo_syn_3, logic_ramfifo_syn_39);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_500 (logic_ramfifo_syn_536, logic_ramfifo_syn_4, logic_ramfifo_syn_40);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_501 (logic_ramfifo_syn_537, logic_ramfifo_syn_5, logic_ramfifo_syn_41);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_502 (logic_ramfifo_syn_538, logic_ramfifo_syn_6, logic_ramfifo_syn_42);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_503 (logic_ramfifo_syn_539, logic_ramfifo_syn_7, logic_ramfifo_syn_43);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_504 (logic_ramfifo_syn_540, logic_ramfifo_syn_8, logic_ramfifo_syn_152);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_505 (logic_ramfifo_syn_541, logic_ramfifo_syn_9, logic_ramfifo_syn_154);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_506 (logic_ramfifo_syn_542, logic_ramfifo_syn_533, logic_ramfifo_syn_534);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_507 (logic_ramfifo_syn_543, logic_ramfifo_syn_535, logic_ramfifo_syn_536);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_508 (logic_ramfifo_syn_544, logic_ramfifo_syn_542, logic_ramfifo_syn_543);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_509 (logic_ramfifo_syn_545, logic_ramfifo_syn_537, logic_ramfifo_syn_538);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_510 (logic_ramfifo_syn_546, logic_ramfifo_syn_540, logic_ramfifo_syn_541);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_511 (logic_ramfifo_syn_547, logic_ramfifo_syn_539, logic_ramfifo_syn_546);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_512 (logic_ramfifo_syn_548, logic_ramfifo_syn_545, logic_ramfifo_syn_547);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_513 (logic_ramfifo_syn_549, logic_ramfifo_syn_544, logic_ramfifo_syn_548);  // w40_d512_fifo.v(39)
  not logic_ramfifo_syn_550 (empty_flag, logic_ramfifo_syn_603);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_551 (logic_ramfifo_syn_587, logic_ramfifo_syn_64, logic_ramfifo_syn_19);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_552 (logic_ramfifo_syn_588, logic_ramfifo_syn_65, logic_ramfifo_syn_20);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_553 (logic_ramfifo_syn_589, logic_ramfifo_syn_66, logic_ramfifo_syn_21);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_554 (logic_ramfifo_syn_590, logic_ramfifo_syn_67, logic_ramfifo_syn_22);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_555 (logic_ramfifo_syn_591, logic_ramfifo_syn_68, logic_ramfifo_syn_23);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_556 (logic_ramfifo_syn_592, logic_ramfifo_syn_69, logic_ramfifo_syn_24);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_557 (logic_ramfifo_syn_593, logic_ramfifo_syn_70, logic_ramfifo_syn_25);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_558 (logic_ramfifo_syn_594, logic_ramfifo_syn_71, logic_ramfifo_syn_26);  // w40_d512_fifo.v(39)
  xor logic_ramfifo_syn_559 (logic_ramfifo_syn_595, logic_ramfifo_syn_72, logic_ramfifo_syn_27);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_560 (logic_ramfifo_syn_596, logic_ramfifo_syn_587, logic_ramfifo_syn_588);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_561 (logic_ramfifo_syn_597, logic_ramfifo_syn_589, logic_ramfifo_syn_590);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_562 (logic_ramfifo_syn_598, logic_ramfifo_syn_596, logic_ramfifo_syn_597);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_563 (logic_ramfifo_syn_599, logic_ramfifo_syn_591, logic_ramfifo_syn_592);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_564 (logic_ramfifo_syn_600, logic_ramfifo_syn_594, logic_ramfifo_syn_595);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_565 (logic_ramfifo_syn_601, logic_ramfifo_syn_593, logic_ramfifo_syn_600);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_566 (logic_ramfifo_syn_602, logic_ramfifo_syn_599, logic_ramfifo_syn_601);  // w40_d512_fifo.v(39)
  or logic_ramfifo_syn_567 (logic_ramfifo_syn_603, logic_ramfifo_syn_598, logic_ramfifo_syn_602);  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB_CARRY"))
    logic_ramfifo_syn_604 (
    .a(1'b0),
    .o({logic_ramfifo_syn_642,open_n297}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_605 (
    .a(logic_ramfifo_syn_55),
    .b(logic_ramfifo_syn_46),
    .c(logic_ramfifo_syn_642),
    .o({logic_ramfifo_syn_643,wrusedw[0]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_606 (
    .a(logic_ramfifo_syn_56),
    .b(logic_ramfifo_syn_47),
    .c(logic_ramfifo_syn_643),
    .o({logic_ramfifo_syn_644,wrusedw[1]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_607 (
    .a(logic_ramfifo_syn_57),
    .b(logic_ramfifo_syn_48),
    .c(logic_ramfifo_syn_644),
    .o({logic_ramfifo_syn_645,wrusedw[2]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_608 (
    .a(logic_ramfifo_syn_58),
    .b(logic_ramfifo_syn_49),
    .c(logic_ramfifo_syn_645),
    .o({logic_ramfifo_syn_646,wrusedw[3]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_609 (
    .a(logic_ramfifo_syn_59),
    .b(logic_ramfifo_syn_50),
    .c(logic_ramfifo_syn_646),
    .o({logic_ramfifo_syn_647,wrusedw[4]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_610 (
    .a(logic_ramfifo_syn_60),
    .b(logic_ramfifo_syn_51),
    .c(logic_ramfifo_syn_647),
    .o({logic_ramfifo_syn_648,wrusedw[5]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_611 (
    .a(logic_ramfifo_syn_61),
    .b(logic_ramfifo_syn_52),
    .c(logic_ramfifo_syn_648),
    .o({logic_ramfifo_syn_649,wrusedw[6]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_612 (
    .a(logic_ramfifo_syn_62),
    .b(logic_ramfifo_syn_53),
    .c(logic_ramfifo_syn_649),
    .o({logic_ramfifo_syn_650,wrusedw[7]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_613 (
    .a(logic_ramfifo_syn_18),
    .b(logic_ramfifo_syn_54),
    .c(logic_ramfifo_syn_650),
    .o({open_n298,wrusedw[8]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB_CARRY"))
    logic_ramfifo_syn_652 (
    .a(1'b0),
    .o({logic_ramfifo_syn_690,open_n301}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_653 (
    .a(logic_ramfifo_syn_73),
    .b(logic_ramfifo_syn_82),
    .c(logic_ramfifo_syn_690),
    .o({logic_ramfifo_syn_691,rdusedw[0]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_654 (
    .a(logic_ramfifo_syn_74),
    .b(logic_ramfifo_syn_83),
    .c(logic_ramfifo_syn_691),
    .o({logic_ramfifo_syn_692,rdusedw[1]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_655 (
    .a(logic_ramfifo_syn_75),
    .b(logic_ramfifo_syn_84),
    .c(logic_ramfifo_syn_692),
    .o({logic_ramfifo_syn_693,rdusedw[2]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_656 (
    .a(logic_ramfifo_syn_76),
    .b(logic_ramfifo_syn_85),
    .c(logic_ramfifo_syn_693),
    .o({logic_ramfifo_syn_694,rdusedw[3]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_657 (
    .a(logic_ramfifo_syn_77),
    .b(logic_ramfifo_syn_86),
    .c(logic_ramfifo_syn_694),
    .o({logic_ramfifo_syn_695,rdusedw[4]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_658 (
    .a(logic_ramfifo_syn_78),
    .b(logic_ramfifo_syn_87),
    .c(logic_ramfifo_syn_695),
    .o({logic_ramfifo_syn_696,rdusedw[5]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_659 (
    .a(logic_ramfifo_syn_79),
    .b(logic_ramfifo_syn_88),
    .c(logic_ramfifo_syn_696),
    .o({logic_ramfifo_syn_697,rdusedw[6]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_660 (
    .a(logic_ramfifo_syn_80),
    .b(logic_ramfifo_syn_89),
    .c(logic_ramfifo_syn_697),
    .o({logic_ramfifo_syn_698,rdusedw[7]}));  // w40_d512_fifo.v(39)
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    logic_ramfifo_syn_661 (
    .a(logic_ramfifo_syn_81),
    .b(logic_ramfifo_syn_45),
    .c(logic_ramfifo_syn_698),
    .o({open_n302,rdusedw[8]}));  // w40_d512_fifo.v(39)
  and re_syn_1 (re_syn_2, re, logic_ramfifo_syn_227);  // w40_d512_fifo.v(25)
  AL_MUX re_syn_569 (
    .i0(clk_syn_78),
    .i1(clk_syn_107),
    .sel(re_syn_2),
    .o(clk_syn_144));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_574 (
    .i0(clk_syn_79),
    .i1(clk_syn_111),
    .sel(re_syn_2),
    .o(clk_syn_145));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_579 (
    .i0(clk_syn_80),
    .i1(clk_syn_115),
    .sel(re_syn_2),
    .o(clk_syn_146));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_584 (
    .i0(clk_syn_81),
    .i1(clk_syn_119),
    .sel(re_syn_2),
    .o(clk_syn_147));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_589 (
    .i0(clk_syn_82),
    .i1(clk_syn_123),
    .sel(re_syn_2),
    .o(clk_syn_148));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_594 (
    .i0(clk_syn_83),
    .i1(clk_syn_127),
    .sel(re_syn_2),
    .o(clk_syn_149));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_599 (
    .i0(clk_syn_84),
    .i1(clk_syn_131),
    .sel(re_syn_2),
    .o(clk_syn_150));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_604 (
    .i0(clk_syn_85),
    .i1(clk_syn_135),
    .sel(re_syn_2),
    .o(clk_syn_151));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_609 (
    .i0(clk_syn_86),
    .i1(clk_syn_139),
    .sel(re_syn_2),
    .o(clk_syn_152));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_614 (
    .i0(clk_syn_87),
    .i1(clk_syn_143),
    .sel(re_syn_2),
    .o(clk_syn_153));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_619 (
    .i0(logic_ramfifo_syn_19),
    .i1(clk_syn_79),
    .sel(re_syn_2),
    .o(logic_ramfifo_syn_247));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_624 (
    .i0(logic_ramfifo_syn_20),
    .i1(clk_syn_80),
    .sel(re_syn_2),
    .o(logic_ramfifo_syn_248));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_629 (
    .i0(logic_ramfifo_syn_21),
    .i1(clk_syn_81),
    .sel(re_syn_2),
    .o(logic_ramfifo_syn_249));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_634 (
    .i0(logic_ramfifo_syn_22),
    .i1(clk_syn_82),
    .sel(re_syn_2),
    .o(logic_ramfifo_syn_250));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_639 (
    .i0(logic_ramfifo_syn_23),
    .i1(clk_syn_83),
    .sel(re_syn_2),
    .o(logic_ramfifo_syn_251));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_644 (
    .i0(logic_ramfifo_syn_24),
    .i1(clk_syn_84),
    .sel(re_syn_2),
    .o(logic_ramfifo_syn_252));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_649 (
    .i0(logic_ramfifo_syn_25),
    .i1(clk_syn_85),
    .sel(re_syn_2),
    .o(logic_ramfifo_syn_253));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_654 (
    .i0(logic_ramfifo_syn_26),
    .i1(clk_syn_86),
    .sel(re_syn_2),
    .o(logic_ramfifo_syn_254));  // w40_d512_fifo.v(25)
  AL_MUX re_syn_659 (
    .i0(logic_ramfifo_syn_27),
    .i1(clk_syn_87),
    .sel(re_syn_2),
    .o(logic_ramfifo_syn_255));  // w40_d512_fifo.v(25)
  and we_syn_1 (we_syn_2, we, logic_ramfifo_syn_158);  // w40_d512_fifo.v(24)
  AL_MUX we_syn_104 (
    .i0(logic_ramfifo_syn_7),
    .i1(clk_syn_8),
    .sel(we_syn_2),
    .o(logic_ramfifo_syn_165));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_109 (
    .i0(logic_ramfifo_syn_8),
    .i1(clk_syn_9),
    .sel(we_syn_2),
    .o(logic_ramfifo_syn_166));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_114 (
    .i0(logic_ramfifo_syn_9),
    .i1(clk_syn_10),
    .sel(we_syn_2),
    .o(logic_ramfifo_syn_167));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_24 (
    .i0(clk_syn_1),
    .i1(clk_syn_14),
    .sel(we_syn_2),
    .o(clk_syn_67));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_29 (
    .i0(clk_syn_2),
    .i1(clk_syn_34),
    .sel(we_syn_2),
    .o(clk_syn_68));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_34 (
    .i0(clk_syn_3),
    .i1(clk_syn_38),
    .sel(we_syn_2),
    .o(clk_syn_69));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_39 (
    .i0(clk_syn_4),
    .i1(clk_syn_42),
    .sel(we_syn_2),
    .o(clk_syn_70));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_44 (
    .i0(clk_syn_5),
    .i1(clk_syn_46),
    .sel(we_syn_2),
    .o(clk_syn_71));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_49 (
    .i0(clk_syn_6),
    .i1(clk_syn_50),
    .sel(we_syn_2),
    .o(clk_syn_72));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_54 (
    .i0(clk_syn_7),
    .i1(clk_syn_54),
    .sel(we_syn_2),
    .o(clk_syn_73));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_59 (
    .i0(clk_syn_8),
    .i1(clk_syn_58),
    .sel(we_syn_2),
    .o(clk_syn_74));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_64 (
    .i0(clk_syn_9),
    .i1(clk_syn_62),
    .sel(we_syn_2),
    .o(clk_syn_75));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_69 (
    .i0(clk_syn_10),
    .i1(clk_syn_66),
    .sel(we_syn_2),
    .o(clk_syn_76));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_74 (
    .i0(logic_ramfifo_syn_1),
    .i1(clk_syn_2),
    .sel(we_syn_2),
    .o(logic_ramfifo_syn_159));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_79 (
    .i0(logic_ramfifo_syn_2),
    .i1(clk_syn_3),
    .sel(we_syn_2),
    .o(logic_ramfifo_syn_160));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_84 (
    .i0(logic_ramfifo_syn_3),
    .i1(clk_syn_4),
    .sel(we_syn_2),
    .o(logic_ramfifo_syn_161));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_89 (
    .i0(logic_ramfifo_syn_4),
    .i1(clk_syn_5),
    .sel(we_syn_2),
    .o(logic_ramfifo_syn_162));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_94 (
    .i0(logic_ramfifo_syn_5),
    .i1(clk_syn_6),
    .sel(we_syn_2),
    .o(logic_ramfifo_syn_163));  // w40_d512_fifo.v(24)
  AL_MUX we_syn_99 (
    .i0(logic_ramfifo_syn_6),
    .i1(clk_syn_7),
    .sel(we_syn_2),
    .o(logic_ramfifo_syn_164));  // w40_d512_fifo.v(24)

  // synthesis translate_off
  glbl glbl();
  always @(*) begin
    glbl.gsr <= PH1_PHY_GSR.gsr;
    glbl.gsrn <= PH1_PHY_GSR.gsrn;
    glbl.done_gwe <= PH1_PHY_GSR.done_gwe;
    glbl.usr_gsrn_en <= PH1_PHY_GSR.usr_gsrn_en;
  end
  // synthesis translate_on

endmodule 

