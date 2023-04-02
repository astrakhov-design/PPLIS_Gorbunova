// Indication decoder module

module sseg_dec(
  input [3:0] data_i,
  output [6:0] seg_out 
);

  reg [6:0] seg_reg;

  always @ (*) begin
    case(data_i)
      4'h0: seg_reg = 7'b0000_001; //0
      4'h1: seg_reg = 7'b1001_111; //1
      4'h2: seg_reg = 7'b0010_010; //2
      4'h3: seg_reg = 7'b0000_110; //3
      4'h4: seg_reg = 7'b1001_100; //4
      4'h5: seg_reg = 7'b0100_100; //5
      4'h6: seg_reg = 7'b0100_000; //6
      4'h7: seg_reg = 7'b0001_111; //7
      4'h8: seg_reg = 7'b0000_000; //8
      4'h9: seg_reg = 7'b0000_100; //9
      //латиница
      4'hA: seg_reg = 7'b0001_000; //A
      4'hB: seg_reg = 7'b1100_000; //B
      4'hC: seg_reg = 7'b0110_001; //C
      4'hD: seg_reg = 7'b1000_010; //D
      4'hE: seg_reg = 7'b0110_000; //E
      4'hF: seg_reg = 7'b0111_000; //F
			default: seg_reg = 7'b1111_110;
    endcase
  end 

  assign seg_out = seg_reg;

endmodule
