module sawtooth_counter_top(
  input         clk_i,    // 50MHz
  input         rst_i,    // reset input button
  input         v_i,      // Select input button
  input         ST_i,     // START counting button 
  input   [7:0] din_i,    // Input data for N1, N2

  output  [17:0] Q_o,     // Output of counter LEDs

  //Segment indicator output wires
  output [6:0]  sseg0,  //dind ones
  output [6:0]  sseg1,  //dind tens
  output [6:0]  sseg2,  //dind hundreds
  output [6:0]  sseg3   //debug wire {2'b00, [1:0] }

);

wire clc; //4 Hz clock

//inverted input wires
wire v_inv;         //inverted select input button
wire ST_inv;        //inverted START counting button
wire [7:0] din_inv; //inverted data for N1, N2

wire [7:0]  dind;     //indication
wire [7:0]  N1_data;  //N1 data
wire [7:0]  N2_data;  //N2 data
wire [7:0]  sawtooth_counter;
wire [2:0]  debug_data;

//decimal decoded data
wire [3:0] dind_ones;
wire [3:0] dind_tens;
wire [1:0] dind_hundreds;

wire [7:0] din_sync;
wire       ST_sync;
wire       v_sync;

//inverted signals declaration
assign v_inv    = ~v_i;
assign ST_inv   = ~ST_i;
assign din_inv  = ~din_i; 

//Sync din_i shifter data
input_sync #(
  .WIRE_WIDTH(8)
) din_sync_module (
  .clk_i(clc),
  .rstn(rst_i),
  .input_wire(din_i),
  .output_wire(din_sync)
);

//Sync ST_i button data
input_sync #(
  .WIRE_WIDTH(1)
) st_sync_module(
  .clk_i(clc),
  .rstn(rst_i),
  .input_wire(ST_inv),
  .output_wire(ST_sync)
);

//Sync V button data
input_sync #(
  .WIRE_WIDTH(1)
) v_sync_module(
  .clk_i(clc),
  .rstn(rst_i),
  .input_wire(v_inv),
  .output_wire(v_sync)
);

clk_div clock_divider(
  .clk_i(clk_i),
  .rst_i(rst_i),
  .clc_o(clc)
);

counter_fsm fsm(
  .clc_i(clc),
  .rst_i(rst_i),
  .v_i(v_sync),
  .ST_i(ST_sync),
  .din_i(din_sync),
  .dind_out(dind),
  .N1_out(N1_data),
  .N2_out(N2_data),
  .sawtooth_cntr_out(sawtooth_counter),
  .debug_out(debug_data)
);

//BCD decode dind_out_wire
bcd_decoder_8bit bcd_decoder(
  .A(dind),
  .ones(dind_ones),
  .tens(dind_tens),
  .hundreds(dind_hundreds)
);

//for dind ones
sseg_dec  sseg_dind_ones(
  .data_i(dind_ones),
  .seg_out(sseg0)
);

//for dind tens
sseg_dec sseg_dind_tens(
  .data_i(dind_tens),
  .seg_out(sseg1)
);

//for dind hundreds
sseg_dec sseg_dind_hundreds(
  .data_i({2'b00, dind_hundreds}),
  .seg_out(sseg2)
);

//for debug state
sseg_dec debug_sseg(
  .data_i({1'b0, debug_data}),
  .seg_out(sseg3)
);

//led decimal (dummy module in current)
led_dec led_dec(
  .clc_i(clc),
  .rst_i(rst_i),
  .N1_data_i(N1_data),
  .N2_data_i(N2_data),
  .sawtooth_cntr_i(sawtooth_counter),
  .led_out(Q_o)
);


endmodule