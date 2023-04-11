module input_sync # (
  parameter WIRE_WIDTH = 1
)
(
  input clk_i,
  input rstn,
  input [WIRE_WIDTH-1:0] input_wire,
  output [WIRE_WIDTH-1:0] output_wire
);

reg [WIRE_WIDTH-1:0] sync_reg;

always @ (posedge clk_i, negedge rstn) begin
  if(!rstn)
    sync_reg <= 0;
  else 
    sync_reg <= input_wire;
end

assign output_wire = sync_reg;

endmodule