module sawtooth_counter_top(
  input         clk_i,    // 50MHz
  input         rst_i,    // reset input button
  input         v_i,      // Select input button
  input   [7:0] din_i,    // Input data for N1, N2

  output  [20:0] Q_o,     // Output of counter LEDs

  //Segment indicator output wires
  output [6:0]  sseg0,  //indicator [3:0]
  output [6:0]  sseg1,  //indicator [7:4]
  output [6:0]  sseg3   //debug wire {2'b00, [1:0] }

);

wire clc; //4 Hz clock

wire [7:0]  dind;     //indication
wire [7:0]  N1_data;  //N1 data
wire [7:0]  N2_data;  //N2 data
wire [7:0]  sawtooth_counter;
wire [1:0]  debug_data;


  clk_div clock_divider(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .clc_o(clc)
  );

  counter_fsm fsm(
    .clc_i(clc),
    .rst_i(rst_i),
    .v_i(v_i),
    .din_i(din_i),
    .dind_out(dind),
    .N1_out(N1_data),
    .N2_out(N2_data),
    .sawtooth_cntr_out(sawtooth_counter),
    .debug_out(debug_data)
  );


  //set sseg indication module
  sseg_dec  sseg_dind0 (
    .data_i(dind[3:0]),
    .seg_out(sseg0)
  );

  sseg_dec sseg_dind1 (
    .data_i(dind[7:4]),
    .seg_out(sseg1)
  );

  sseg_dec sseg_debug(
    .data_i({2'b00, debug_data}),
    .seg_out(sseg3)
  );



endmodule