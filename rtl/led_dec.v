module led_dec(
    input           clc_i,
    input           rst_i,
    input   [7:0]   N1_data_i,
    input   [7:0]   N2_data_i,
    input           led_en_i,
    input           led_wait_i,
    input           direction_i,
    output  [17:0]  led_out
);

wire [7:0]  dimension;

reg [17:0] led_reg;

reg [3:0] dimension_div;
reg [7:0] dimension_cntr;

assign dimension = N2_data_i - N1_data_i;

always @ * begin
  if(dimension <= 8'd18)
    dimension_div = 4'd1;
  else if(dimension > 8'd19 && dimension <= 8'd36)
    dimension_div = 4'd2;
  else if(dimension > 8'd37 && dimension <= 8'd54)
    dimension_div = 4'd3;
  else if(dimension > 8'd54 && dimension <= 8'd72)
    dimension_div = 4'd4;
  else if(dimension > 8'd72 && dimension <= 8'd90)
    dimension_div = 4'd5;
  else if(dimension > 8'd90 && dimension <= 8'd108)
    dimension_div = 4'd6;
  else if(dimension > 8'd108 && dimension <= 8'd126)
    dimension_div = 4'd7;
  else if(dimension > 8'd126 && dimension <= 8'd144)
    dimension_div = 4'd8;
  else if(dimension > 8'd144 && dimension <= 8'd162)
    dimension_div = 4'd9;
  else if(dimension > 8'd162 && dimension <= 8'd180)
    dimension_div = 4'd10;
  else if(dimension > 8'd180 && dimension <= 8'd198)
    dimension_div = 4'd11;
  else if(dimension > 8'd198 && dimension <= 8'd216)
    dimension_div = 4'd12;
  else if(dimension > 8'd216 && dimension <= 8'd234)
    dimension_div = 4'd13;
  else if(dimension > 8'd234 && dimension <= 8'd252)
    dimension_div = 4'd14;
  else if(dimension > 8'd252 && dimension <= 8'd255)
    dimension_div = 4'd15;
  else 
    dimension_div = 4'd1;
end 

always @ (posedge clc_i, negedge rst_i) begin
  if(!rst_i) begin
    dimension_cntr  <=  8'h0;
    led_reg         <=  18'h0;
  end
  else if(led_en_i) begin
    if(dimension_cntr == dimension_div) begin
      dimension_cntr <= 8'h0;
      if(!direction_i)
        led_reg <= {1'b1,   led_reg[17:1]};
      else
        led_reg <= {led_reg[16:0], 1'b0};
    end
    else begin
      dimension_cntr <= dimension_cntr + 1'b1;
      led_reg        <= led_reg;
    end
  end
  else if(led_wait_i) begin
    dimension_cntr  <=  dimension_cntr;
    led_reg         <=  led_reg;
  end
  else begin
    dimension_cntr  <=  8'h0;
    led_reg         <=  18'h0;
  end
end
    
assign led_out = led_reg;

endmodule