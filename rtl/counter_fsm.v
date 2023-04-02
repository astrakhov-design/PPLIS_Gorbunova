module counter_fsm(
  input           clc_i,              //4Hz
  input           rst_i,              //reset button

  input           v_i,                //input select button
  input   [7:0]   din_i,              //input data select switch

  output  [7:0]   dind_out,           //output indication data (7 dight display)
  output  [7:0]   N1_out,             //output of N1 data
  output  [7:0]   N2_out,             //output of N2 data
  output  [7:0]   sawtooth_cntr_out,  //sawtooth counter output
  output  [1:0]   debug_out,          //output current state data (7 dight display)


);

  //FSM state description
  localparam [1:0]  IDLE      = 2'd0,
                    N1_SELECT = 2'd1,
                    N2_SELECT = 2'd2,
                    CALC      = 2'd3;
              
  reg [1:0]   state;
  reg [1:0]   next;

  reg [7:0]   N1_data_current;     //N1 saved data
  reg [7:0]   N1_data_next;        //N1 containing data

  reg [7:0]   N2_data_current;     //N2 saved data
  reg [7:0]   N2_data_next;        //N2 containing data

  reg [7:0]   dind_current;        //inidication N1/N2 data
  reg [7:0]   dind_next;

  reg [7:0]   sawtooth_cntr_current;
  reg [7:0]   sawtooth_cntr_next;

  reg         direction_current;
  reg         direction_next;

  reg [1:0]   debug_current;
  reg [1:0]   debug_next;

  always @ (posedge clc_i, negedge rst_i) begin
    if(!rst_i) begin 
      state <= IDLE;
      N1_data_current       <=  8'd0;
      N2_data_current       <=  8'd1; //(N2 > N1 always!!!)
      dind_current          <=  8'd0;
      debug_current         <=  8'd0;
      sawtooth_cntr_current <=  8'd0;
      direction_current     <=  1'b0;
    end
    else begin
      state                 <=  next; 
      N1_data_current       <=  N1_data_next;
      N2_data_current       <=  N2_data_next;
      debug_current         <=  debug_next;
      dind_current          <=  dind_next;
      sawtooth_cntr_current <=  sawtooth_cntr_next;
    end
  end 

  always @ * begin
    next          = current;
    N1_data_next  = N1_data_current;
    N2_data_next  = N2_data_current;
    debug_next    = debug_current;
    dind_next     = dind_current;
    case(current)
      IDLE: begin
        if(v_i)
          next = N1_SELECT;
      end
      N1_SELECT: begin
        debug_next  = 2'd1;
        dind_next   = din_i;
        if(v_i) begin 
          N1_data_next        = din_i;
          next                = N2_SELECT;
        end
      end 
      N2_SELECT: begin 
        debug_next  = 2'd2;
        dind_next   = din_i;
        if(v_i) begin 
          N2_data_next  = din_i;
          next          = CALC;
        end
      end
      CALC: begin
        debug_next  = 2'd3;
        dind_next   = sawtooth_cntr_current;
        if(v_i)
          next = N1_SELECT;
        else begin
          if(!direction_next) begin
            sawtooth_cntr_next = sawtooth_cntr_current + 1'b1; 
            if(sawtooth_cntr_next == N2_data_current)
              direction_next = 1'b1;
          end
          else begin
            sawtooth_cntr_next = sawtooth_cntr_current - 1'b1;
            if(sawtooth_cntr_next == N1_data_current)
              direction_next = 1'b0;
          end
        end
      end
    endcase
  end

  assign  dind_out          = dind_current;
  assign  N1_out            = N1_data_current;
  assign  N2_out            = N2_data_current;
  assign  sawtooth_cntr_out = sawtooth_cntr_current;
  assign  debug_out         = debug_current;

endmodule