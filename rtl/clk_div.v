module clk_div(
  input clk_i,    //50 MHz
  input rst_i,    //reset input

  output clc_o    //output clock (4Hz)
);

  //4 Hz -> 0.25s -> 250_000_000ns
  //250_000_000ns / 40ns = 6_250_000

  reg [22:0]  clk_cnt;

  always @ (posedge clk_i, negedge rst_i) begin
    if(!rst_i)
      clk_cnt <= 23'h0;
    else if(clk_cnt == 23'd6_250_001)
      clk_cnt <= 23'h0;
    else 
      clk_cnt <= clk_cnt + 1'b1;
  end

  assign clc_o = (clk_cnt == 23'd6_250_000) ? 1'b1 : 1'b0;

endmodule 
