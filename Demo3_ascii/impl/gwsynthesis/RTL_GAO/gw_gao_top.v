module gw_gao(
    \lcd_inst/font_addr[10] ,
    \lcd_inst/font_addr[9] ,
    \lcd_inst/font_addr[8] ,
    \lcd_inst/font_addr[7] ,
    \lcd_inst/font_addr[6] ,
    \lcd_inst/font_addr[5] ,
    \lcd_inst/font_addr[4] ,
    \lcd_inst/font_addr[3] ,
    \lcd_inst/font_addr[2] ,
    \lcd_inst/font_addr[1] ,
    \lcd_inst/font_addr[0] ,
    \lcd_inst/font_data[7] ,
    \lcd_inst/font_data[6] ,
    \lcd_inst/font_data[5] ,
    \lcd_inst/font_data[4] ,
    \lcd_inst/font_data[3] ,
    \lcd_inst/font_data[2] ,
    \lcd_inst/font_data[1] ,
    \lcd_inst/font_data[0] ,
    \lcd_inst/horizontal[10] ,
    \lcd_inst/horizontal[9] ,
    \lcd_inst/horizontal[8] ,
    \lcd_inst/horizontal[7] ,
    \lcd_inst/horizontal[6] ,
    \lcd_inst/horizontal[5] ,
    \lcd_inst/horizontal[4] ,
    \lcd_inst/horizontal[3] ,
    \lcd_inst/horizontal[2] ,
    \lcd_inst/horizontal[1] ,
    \lcd_inst/horizontal[0] ,
    \lcd_inst/vertical[9] ,
    \lcd_inst/vertical[8] ,
    \lcd_inst/vertical[7] ,
    \lcd_inst/vertical[6] ,
    \lcd_inst/vertical[5] ,
    \lcd_inst/vertical[4] ,
    \lcd_inst/vertical[3] ,
    \lcd_inst/vertical[2] ,
    \lcd_inst/vertical[1] ,
    \lcd_inst/vertical[0] ,
    CLK_PIX,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \lcd_inst/font_addr[10] ;
input \lcd_inst/font_addr[9] ;
input \lcd_inst/font_addr[8] ;
input \lcd_inst/font_addr[7] ;
input \lcd_inst/font_addr[6] ;
input \lcd_inst/font_addr[5] ;
input \lcd_inst/font_addr[4] ;
input \lcd_inst/font_addr[3] ;
input \lcd_inst/font_addr[2] ;
input \lcd_inst/font_addr[1] ;
input \lcd_inst/font_addr[0] ;
input \lcd_inst/font_data[7] ;
input \lcd_inst/font_data[6] ;
input \lcd_inst/font_data[5] ;
input \lcd_inst/font_data[4] ;
input \lcd_inst/font_data[3] ;
input \lcd_inst/font_data[2] ;
input \lcd_inst/font_data[1] ;
input \lcd_inst/font_data[0] ;
input \lcd_inst/horizontal[10] ;
input \lcd_inst/horizontal[9] ;
input \lcd_inst/horizontal[8] ;
input \lcd_inst/horizontal[7] ;
input \lcd_inst/horizontal[6] ;
input \lcd_inst/horizontal[5] ;
input \lcd_inst/horizontal[4] ;
input \lcd_inst/horizontal[3] ;
input \lcd_inst/horizontal[2] ;
input \lcd_inst/horizontal[1] ;
input \lcd_inst/horizontal[0] ;
input \lcd_inst/vertical[9] ;
input \lcd_inst/vertical[8] ;
input \lcd_inst/vertical[7] ;
input \lcd_inst/vertical[6] ;
input \lcd_inst/vertical[5] ;
input \lcd_inst/vertical[4] ;
input \lcd_inst/vertical[3] ;
input \lcd_inst/vertical[2] ;
input \lcd_inst/vertical[1] ;
input \lcd_inst/vertical[0] ;
input CLK_PIX;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \lcd_inst/font_addr[10] ;
wire \lcd_inst/font_addr[9] ;
wire \lcd_inst/font_addr[8] ;
wire \lcd_inst/font_addr[7] ;
wire \lcd_inst/font_addr[6] ;
wire \lcd_inst/font_addr[5] ;
wire \lcd_inst/font_addr[4] ;
wire \lcd_inst/font_addr[3] ;
wire \lcd_inst/font_addr[2] ;
wire \lcd_inst/font_addr[1] ;
wire \lcd_inst/font_addr[0] ;
wire \lcd_inst/font_data[7] ;
wire \lcd_inst/font_data[6] ;
wire \lcd_inst/font_data[5] ;
wire \lcd_inst/font_data[4] ;
wire \lcd_inst/font_data[3] ;
wire \lcd_inst/font_data[2] ;
wire \lcd_inst/font_data[1] ;
wire \lcd_inst/font_data[0] ;
wire \lcd_inst/horizontal[10] ;
wire \lcd_inst/horizontal[9] ;
wire \lcd_inst/horizontal[8] ;
wire \lcd_inst/horizontal[7] ;
wire \lcd_inst/horizontal[6] ;
wire \lcd_inst/horizontal[5] ;
wire \lcd_inst/horizontal[4] ;
wire \lcd_inst/horizontal[3] ;
wire \lcd_inst/horizontal[2] ;
wire \lcd_inst/horizontal[1] ;
wire \lcd_inst/horizontal[0] ;
wire \lcd_inst/vertical[9] ;
wire \lcd_inst/vertical[8] ;
wire \lcd_inst/vertical[7] ;
wire \lcd_inst/vertical[6] ;
wire \lcd_inst/vertical[5] ;
wire \lcd_inst/vertical[4] ;
wire \lcd_inst/vertical[3] ;
wire \lcd_inst/vertical[2] ;
wire \lcd_inst/vertical[1] ;
wire \lcd_inst/vertical[0] ;
wire CLK_PIX;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i({\lcd_inst/horizontal[10] ,\lcd_inst/horizontal[9] ,\lcd_inst/horizontal[8] ,\lcd_inst/horizontal[7] ,\lcd_inst/horizontal[6] ,\lcd_inst/horizontal[5] ,\lcd_inst/horizontal[4] ,\lcd_inst/horizontal[3] ,\lcd_inst/horizontal[2] ,\lcd_inst/horizontal[1] ,\lcd_inst/horizontal[0] ,\lcd_inst/vertical[9] ,\lcd_inst/vertical[8] ,\lcd_inst/vertical[7] ,\lcd_inst/vertical[6] ,\lcd_inst/vertical[5] ,\lcd_inst/vertical[4] ,\lcd_inst/vertical[3] ,\lcd_inst/vertical[2] ,\lcd_inst/vertical[1] ,\lcd_inst/vertical[0] }),
    .data_i({\lcd_inst/font_addr[10] ,\lcd_inst/font_addr[9] ,\lcd_inst/font_addr[8] ,\lcd_inst/font_addr[7] ,\lcd_inst/font_addr[6] ,\lcd_inst/font_addr[5] ,\lcd_inst/font_addr[4] ,\lcd_inst/font_addr[3] ,\lcd_inst/font_addr[2] ,\lcd_inst/font_addr[1] ,\lcd_inst/font_addr[0] ,\lcd_inst/font_data[7] ,\lcd_inst/font_data[6] ,\lcd_inst/font_data[5] ,\lcd_inst/font_data[4] ,\lcd_inst/font_data[3] ,\lcd_inst/font_data[2] ,\lcd_inst/font_data[1] ,\lcd_inst/font_data[0] ,\lcd_inst/horizontal[10] ,\lcd_inst/horizontal[9] ,\lcd_inst/horizontal[8] ,\lcd_inst/horizontal[7] ,\lcd_inst/horizontal[6] ,\lcd_inst/horizontal[5] ,\lcd_inst/horizontal[4] ,\lcd_inst/horizontal[3] ,\lcd_inst/horizontal[2] ,\lcd_inst/horizontal[1] ,\lcd_inst/horizontal[0] ,\lcd_inst/vertical[9] ,\lcd_inst/vertical[8] ,\lcd_inst/vertical[7] ,\lcd_inst/vertical[6] ,\lcd_inst/vertical[5] ,\lcd_inst/vertical[4] ,\lcd_inst/vertical[3] ,\lcd_inst/vertical[2] ,\lcd_inst/vertical[1] ,\lcd_inst/vertical[0] }),
    .clk_i(CLK_PIX)
);

endmodule
