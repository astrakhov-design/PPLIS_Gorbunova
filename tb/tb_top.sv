`timescale 1ns/1ns

module tb_top;

logic clk = 0;
logic rstn = 1;

//4 Hz clock from RTL divider
logic div_clc;

//debug wires 
logic [2:0] state_display;
logic [7:0] N1_display;
logic [7:0] N2_display;
logic [7:0] sawtooth_cntr_display;
logic [7:0] dind_current_display;

logic v_button = 1;
logic ST_button = 1;
logic [7:0] din_in = 0;

logic [6:0] sseg0;
logic [6:0] sseg1;
logic [6:0] sseg2;
logic [6:0] sseg3;

logic [17:0] Q_led;

sawtooth_counter_top DUT(
  .clk_i(clk),
  .rst_i(rstn),
  .v_i(v_button),
  .ST_i(ST_button),
  .din_i(din_in),
  .Q_o(Q_led),
  .sseg0(sseg0),
  .sseg1(sseg1),
  .sseg2(sseg2),
  .sseg3(sseg3)
);

//initiate clock in 50 MHz
always #20ns clk <= ~clk;

assign div_clc = DUT.clc;
assign state_display = DUT.fsm.state;
assign N1_display = DUT.fsm.N1_out;
assign N2_display = DUT.fsm.N2_out;
assign sawtooth_cntr_display = DUT.fsm.sawtooth_cntr_out;
assign dind_current_display = DUT.fsm.dind_out;


initial begin 
  reset(5);
  switch_button();
  wait_clc(2);
  set_data(20);
  wait_clc(2);
  set_data(40);
  wait_clc(4);
  set_st();
  repeat (50) @ (posedge div_clc);
  set_st();
  repeat (15) @ (posedge div_clc);
  set_st();
  repeat (15) @ (posedge div_clc);
  switch_button();
  wait_clc(2);
  set_data(15);
  wait_clc(2);
  set_data(76);
  set_st();
  repeat (100) @ (posedge div_clc);
  set_st();
  repeat(20) @ (posedge div_clc);
  $stop;
end


task reset(input int T);
  rstn = 0;
  repeat(T) @ (posedge clk);
  rstn = 1;
endtask

task switch_button();
  v_button = 0;
  $display("Switch Button");
  repeat(1) @ (posedge div_clc);
  v_button = 1;
endtask

task wait_clc(input int T);
  repeat(T) @ (posedge div_clc);
endtask

task set_data(bit [7:0] data);
  din_in = data;
  v_button = 1'b0;
  repeat(1) @ (posedge div_clc);
  $display("Data: %d", din_in);
  v_button = 1'b1;
  din_in = 8'd0;
endtask

task set_st();
  ST_button = 0;
  $display("Switch on START button");
  repeat(1) @ (posedge div_clc);
  ST_button = 1;
endtask

always @ (posedge div_clc) begin
  $display("------------------");
  $display("Time: %0t", $realtime);
  $display("CURRENT STATE: %d", state_display);
  $display("N1 data: %d", N1_display);
  $display("N2 data: %d", N2_display);
  $display("Sawtooth counter: %d", sawtooth_cntr_display);
  $display("Dind output: %d", dind_current_display);
end



endmodule