from kratos import Generator, verilog, const, always, posedge, clog2

# this translated from the original Chisel paper

class Fifo(Generator):
    def __init__(self, width, depth):
        super().__init__("FIFO")
        in_ = self.input("in", width)
        out = self.output("out", width)
        ren = self.input("ren", 1)
        wen = self.input("wen", 1)
        data = self.var("data", width, size=depth)
        clk = self.clock("clk")
        reset = self.reset("rst")
        read_ptr = self.var("read_ptr", clog2(depth))
        write_ptr = self.var("write_ptr", clog2(depth))
        full = self.output("is_full", 1)
        empty = self.output("is_empty", 1)
        full_next = self.var("is_full_next", 1)
        self.wire(empty, ~full & (read_ptr == write_ptr))

        def comb():
            if wen & (~ren) & ((write_ptr + 1) == read_ptr):
                full_next = True
            elif wen and full:
                full_next = False
            else:
                full_next = full

        @always((posedge, "clk"), (posedge, "rst"))
        def seq():
            if reset:
                read_ptr = 0
                write_ptr = 0
                full = 0
            else:
                if ren:
                    read_ptr = read_ptr + 1
                    out = data[read_ptr]
                if wen:
                    write_ptr = write_ptr + 1
                    data[write_ptr] = in_
                full = full_next

        self.add_code(comb)
        self.add_code(seq)

if __name__ == "__main__":
    fifo = Fifo(8, 16)
    verilog(fifo, filename="fifo.sv")
