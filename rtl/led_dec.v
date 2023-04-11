module led_dec(
    input           clc_i,
    input           rst_i,
    input   [7:0]   N1_data_i,
    input   [7:0]   N2_data_i,
    input   [7:0]   sawtooth_cntr_i,

    output  [17:0]  led_out
);

wire [7:0]  dimension;

reg [20:0] led_reg;

assign dimension = N2_data_i - N1_data_i;


assign led_out = 18{1'b1};

/*
always @ (posedge clc_i, negedge rst_i) begin
    if(!rst_i)
        led_reg <= 19'h0;
    else begin
*/

endmodule