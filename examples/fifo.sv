module FIFO (
  input logic  clk,
  input logic [7:0] in,
  output logic  is_empty,
  output logic  is_full,
  output logic [7:0] out,
  input logic  ren,
  input logic  rst,
  input logic  wen
);

logic  [7:0] data[15:0];
logic   is_full_next;
logic  [3:0] read_ptr;
logic  [3:0] write_ptr;
assign is_empty = (~is_full) & (read_ptr == write_ptr);
always_comb begin
  if (wen & (~ren) & ((write_ptr + 4'h1) == read_ptr)) begin
    is_full_next = 1'h1;
  end
  else if (is_full) begin
    is_full_next = 1'h0;
  end
  else is_full_next = is_full;
end

always_ff @(posedge clk, posedge rst) begin
  if (rst) begin
    read_ptr <= 4'h0;
    write_ptr <= 4'h0;
    is_full <= 1'h0;
  end
  else begin
    if (ren) begin
      read_ptr <= read_ptr + 4'h1;
      out <= data[read_ptr];
    end
    if (wen) begin
      write_ptr <= write_ptr + 4'h1;
      data[write_ptr] <= in;
    end
    is_full <= is_full_next;
  end
end
endmodule   // FIFO

