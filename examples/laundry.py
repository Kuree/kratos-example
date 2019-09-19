from kratos import Generator, const, verilog


def set_washer(washer, mod):
    washer.output(mod.ports.washer_done)
    water_fill = washer.add_state("WaterFill")
    spin = washer.add_state("Spin")
    drain = washer.add_state("Drain")
    washer_done = washer.add_state("Done")

    water_fill.next(spin, None)
    spin.next(drain, None)
    drain.next(washer_done, None)

    for state in (water_fill, spin, drain):
        state.output(mod.ports.washer_done, const(0, 1))
    washer_done.output(mod.ports.washer_done, const(1, 1))


def set_dryer(dryer, mod):
    dryer.output(mod.ports.dryer_done)
    heating = dryer.add_state("Heating")
    spin = dryer.add_state("Spin")
    cool_down = dryer.add_state("CoolDown")
    dryer_done = dryer.add_state("Done")
    heating.next(spin, None)
    spin.next(cool_down, None)
    cool_down.next(dryer_done, None)

    for state in (heating, spin, cool_down):
        state.output(mod.ports.dryer_done, const(0, 1))
    dryer_done.output(mod.ports.dryer_done, const(1, 1))


def main():
    mod = Generator("LaundryMachine")
    washer_door = mod.input("washer_door", 1)
    dryer_door = mod.input("dryer_door", 1)
    clothes = mod.input("clothes", 1)
    washer_done = mod.output("washer_done", 1)
    dryer_done = mod.output("dryer_done", 1)
    done_laundry = mod.output("done", 1)
    mod.clock("clk")
    mod.reset("rst")

    main_fsm = mod.add_fsm("Laundry")
    washer = mod.add_fsm("Washer")
    dryer = mod.add_fsm("Dryer")
    main_fsm.add_child_fsm(washer)
    main_fsm.add_child_fsm(dryer)

    # add sub states
    set_washer(washer, mod)
    set_dryer(dryer, mod)

    # set the main state
    reset = main_fsm.add_state("Reset")
    main_fsm.set_start_state(reset)
    start_washing = main_fsm.add_state("Washing")
    start_drying = main_fsm.add_state("Drying")
    done = main_fsm.add_state("Done")

    reset.next(start_washing, washer_door == 1)
    start_washing.next(washer["WaterFill"], None)
    washer["Done"].next(start_drying, None)
    start_drying.next(dryer["Heating"], dryer_door == 1)
    dryer["Done"].next(done, None)
    done.next(reset, None)

    main_fsm.output(done_laundry)
    for state in (reset, start_washing, start_drying):
        state.output(done_laundry, const(0, 1))
    done.output(done_laundry, const(1, 1))

    verilog(mod, filename="laundry.sv")
    main_fsm.dot_graph("laundry.dot")

if __name__ == "__main__":
    main()
