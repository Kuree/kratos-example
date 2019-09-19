from kratos import Generator, verilog, const


class VendingMachine1(Generator):
    def __init__(self):
        super().__init__("VendingMachine")
        nickel = self.input("nickel", 1)
        dime = self.input("dime", 1)
        vend = self.output("vend", 1)
        self.clock("clk")
        self.reset("rst")

        fsm = self.add_fsm("VEND")
        reset = fsm.add_state("Reset")
        five = fsm.add_state("Five")
        ten = fsm.add_state("Ten")
        fifteen = fsm.add_state("Fifteen")
        twenty = fsm.add_state("Twenty")

        fsm.set_start_state(reset)
        reset.next(five, nickel == 1)
        reset.next(ten, dime == 1)
        five.next(ten, nickel == 1)
        five.next(fifteen, dime == 1)
        ten.next(fifteen, nickel == 1)
        ten.next(twenty, dime == 1)
        fifteen.next(twenty, nickel == 1)
        fifteen.next(twenty, dime == 1)
        twenty.next(reset, None)

        fsm.output(vend)
        for state in [reset, five, ten, fifteen]:
            state.output(vend, const(0, 1))
        twenty.output(vend, const(1, 1))
        fsm.dot_graph("vending_machine.dot")


class VendingMachine2(Generator):
    def __init__(self, goal):
        super().__init__("VendingMachine")
        goal = goal // 5 + 1

        nickel = self.input("nickel", 1)
        dime = self.input("dime", 1)
        vend = self.output("vend", 1)
        self.clock("clk")
        self.reset("rst")

        fsm = self.add_fsm("VEND")
        states = []
        for i in range(goal):
            states.append(fsm.add_state("S{0}".format(i)))

        for i in range(goal - 1):
            if i < goal - 2:
                states[i].next(states[i + 1], nickel == 1)
                states[i].next(states[i + 2], dime == 1)
            else:
                states[i].next(states[-1], nickel == 1)
                states[i].next(states[-1], dime == 1)
        states[-1].next(states[0], None)
        fsm.output(vend)
        for i in range(goal - 1):
            states[i].output(vend, const(0, 1))
        states[-1].output(vend, const(1, 1))
        fsm.set_start_state(states[0])



if __name__ == "__main__":
    v = VendingMachine1()
    verilog(v, filename="vending_machine1.sv")
    v2 = VendingMachine2(20)
    verilog(v2, filename="vending_machine2.sv")
