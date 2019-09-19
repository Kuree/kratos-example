module VendingMachine (
  input logic  clk,
  input logic  dime,
  input logic  nickel,
  input logic  rst,
  output logic  vend
);

typedef enum logic[2:0] {
  Fifteen = 3'h0,
  Five = 3'h1,
  Reset = 3'h2,
  Ten = 3'h3,
  Twenty = 3'h4
} VEND_state;
VEND_state   VEND_current_state;
VEND_state   VEND_next_state;

always_ff @(posedge clk, posedge rst) begin
  if (rst) begin
    VEND_current_state <= Reset;
  end
  else VEND_current_state <= VEND_next_state;
end
always_comb begin
  unique case (VEND_current_state)
    Fifteen: if (nickel == 1'h1) begin
      VEND_next_state = Twenty;
    end
    else if (dime == 1'h1) begin
      VEND_next_state = Twenty;
    end
    else VEND_next_state = Fifteen;
    Five: if (dime == 1'h1) begin
      VEND_next_state = Fifteen;
    end
    else if (nickel == 1'h1) begin
      VEND_next_state = Ten;
    end
    else VEND_next_state = Five;
    Reset: if (nickel == 1'h1) begin
      VEND_next_state = Five;
    end
    else if (dime == 1'h1) begin
      VEND_next_state = Ten;
    end
    else VEND_next_state = Reset;
    Ten: if (nickel == 1'h1) begin
      VEND_next_state = Fifteen;
    end
    else if (dime == 1'h1) begin
      VEND_next_state = Twenty;
    end
    else VEND_next_state = Ten;
    Twenty: VEND_next_state = Reset;
  endcase
end
always_comb begin
  unique case (VEND_current_state)
    Fifteen: begin :VEND_Fifteen_Output
        vend = 1'h0;
      end :VEND_Fifteen_Output
    Five: begin :VEND_Five_Output
        vend = 1'h0;
      end :VEND_Five_Output
    Reset: begin :VEND_Reset_Output
        vend = 1'h0;
      end :VEND_Reset_Output
    Ten: begin :VEND_Ten_Output
        vend = 1'h0;
      end :VEND_Ten_Output
    Twenty: begin :VEND_Twenty_Output
        vend = 1'h1;
      end :VEND_Twenty_Output
  endcase
end
endmodule   // VendingMachine

