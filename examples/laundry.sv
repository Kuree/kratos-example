module LaundryMachine (
  input logic  clk,
  input logic  clothes,
  output logic  done,
  output logic  dryer_done,
  input logic  dryer_door,
  input logic  rst,
  output logic  washer_done,
  input logic  washer_door
);

typedef enum logic[3:0] {
  Dryer_CoolDown = 4'h8,
  Dryer_Done = 4'hA,
  Dryer_Heating = 4'h4,
  Dryer_Spin = 4'h6,
  Laundry_Done = 4'h0,
  Laundry_Drying = 4'h1,
  Laundry_Reset = 4'h2,
  Laundry_Washing = 4'h3,
  Washer_Done = 4'hB,
  Washer_Drain = 4'h9,
  Washer_Spin = 4'h7,
  Washer_WaterFill = 4'h5
} Laundry_state;
Laundry_state   Laundry_current_state;
Laundry_state   Laundry_next_state;

always_ff @(posedge clk, posedge rst) begin
  if (rst) begin
    Laundry_current_state <= Laundry_Reset;
  end
  else Laundry_current_state <= Laundry_next_state;
end
always_comb begin
  unique case (Laundry_current_state)
    Laundry_Done: Laundry_next_state = Laundry_Reset;
    Laundry_Drying: if (dryer_door == 1'h1) begin
      Laundry_next_state = Dryer_Heating;
    end
    else Laundry_next_state = Laundry_Drying;
    Laundry_Reset: if (washer_door == 1'h1) begin
      Laundry_next_state = Laundry_Washing;
    end
    else Laundry_next_state = Laundry_Reset;
    Laundry_Washing: Laundry_next_state = Washer_WaterFill;
    Dryer_Heating: Laundry_next_state = Dryer_Spin;
    Washer_WaterFill: Laundry_next_state = Washer_Spin;
    Dryer_Spin: Laundry_next_state = Dryer_CoolDown;
    Washer_Spin: Laundry_next_state = Washer_Drain;
    Dryer_CoolDown: Laundry_next_state = Dryer_Done;
    Washer_Drain: Laundry_next_state = Washer_Done;
    Dryer_Done: Laundry_next_state = Laundry_Done;
    Washer_Done: Laundry_next_state = Laundry_Drying;
  endcase
end
always_comb begin
  unique case (Laundry_current_state)
    Laundry_Done: begin :Laundry_Laundry_Done_Output
        done = 1'h1;
      end :Laundry_Laundry_Done_Output
    Laundry_Drying: begin :Laundry_Laundry_Drying_Output
        done = 1'h0;
      end :Laundry_Laundry_Drying_Output
    Laundry_Reset: begin :Laundry_Laundry_Reset_Output
        done = 1'h0;
      end :Laundry_Laundry_Reset_Output
    Laundry_Washing: begin :Laundry_Laundry_Washing_Output
        done = 1'h0;
      end :Laundry_Laundry_Washing_Output
    Dryer_Heating: begin :Laundry_Dryer_Heating_Output
        dryer_done = 1'h0;
      end :Laundry_Dryer_Heating_Output
    Washer_WaterFill: begin :Laundry_Washer_WaterFill_Output
        washer_done = 1'h0;
      end :Laundry_Washer_WaterFill_Output
    Dryer_Spin: begin :Laundry_Dryer_Spin_Output
        dryer_done = 1'h0;
      end :Laundry_Dryer_Spin_Output
    Washer_Spin: begin :Laundry_Washer_Spin_Output
        washer_done = 1'h0;
      end :Laundry_Washer_Spin_Output
    Dryer_CoolDown: begin :Laundry_Dryer_CoolDown_Output
        dryer_done = 1'h0;
      end :Laundry_Dryer_CoolDown_Output
    Washer_Drain: begin :Laundry_Washer_Drain_Output
        washer_done = 1'h0;
      end :Laundry_Washer_Drain_Output
    Dryer_Done: begin :Laundry_Dryer_Done_Output
        dryer_done = 1'h1;
      end :Laundry_Dryer_Done_Output
    Washer_Done: begin :Laundry_Washer_Done_Output
        washer_done = 1'h1;
      end :Laundry_Washer_Done_Output
  endcase
end
endmodule   // LaundryMachine

