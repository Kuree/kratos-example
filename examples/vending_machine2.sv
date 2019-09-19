module VendingMachine (
  input logic  clk,
  input logic  dime,
  input logic  nickel,
  input logic  rst,
  output logic  vend
);

typedef enum logic[2:0] {
  S0 = 3'h0,
  S1 = 3'h1,
  S2 = 3'h2,
  S3 = 3'h3,
  S4 = 3'h4
} VEND_state;
VEND_state   VEND_current_state;
VEND_state   VEND_next_state;

always_ff @(posedge clk, posedge rst) begin
  if (rst) begin
    VEND_current_state <= S0;
  end
  else VEND_current_state <= VEND_next_state;
end
always_comb begin
  unique case (VEND_current_state)
    S0: if (nickel == 1'h1) begin
      VEND_next_state = S1;
    end
    else if (dime == 1'h1) begin
      VEND_next_state = S2;
    end
    else VEND_next_state = S0;
    S1: if (nickel == 1'h1) begin
      VEND_next_state = S2;
    end
    else if (dime == 1'h1) begin
      VEND_next_state = S3;
    end
    else VEND_next_state = S1;
    S2: if (nickel == 1'h1) begin
      VEND_next_state = S3;
    end
    else if (dime == 1'h1) begin
      VEND_next_state = S4;
    end
    else VEND_next_state = S2;
    S3: if (nickel == 1'h1) begin
      VEND_next_state = S4;
    end
    else if (dime == 1'h1) begin
      VEND_next_state = S4;
    end
    else VEND_next_state = S3;
    S4: VEND_next_state = S0;
  endcase
end
always_comb begin
  unique case (VEND_current_state)
    S0: begin :VEND_S0_Output
        vend = 1'h0;
      end :VEND_S0_Output
    S1: begin :VEND_S1_Output
        vend = 1'h0;
      end :VEND_S1_Output
    S2: begin :VEND_S2_Output
        vend = 1'h0;
      end :VEND_S2_Output
    S3: begin :VEND_S3_Output
        vend = 1'h0;
      end :VEND_S3_Output
    S4: begin :VEND_S4_Output
        vend = 1'h1;
      end :VEND_S4_Output
  endcase
end
endmodule   // VendingMachine

