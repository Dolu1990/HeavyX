from nmigen import *
from nmigen.back import verilog

from heavycomps import uart


class Top:
    def __init__(self, clk_freq=156e6, baudrate=115200):
        self.clk_freq = clk_freq
        self.baudrate = baudrate
        self.clk156_p = Signal()
        self.clk156_n = Signal()
        self.serial_tx = Signal()

    def elaborate(self, platform):
        m = Module()

        cd_sync = ClockDomain(reset_less=True)
        m.domains += cd_sync
        m.submodules.clock = Instance("IBUFGDS",
            i_I=self.clk156_p, i_IB=self.clk156_n, o_O=cd_sync.clk)

        tx = uart.RS232TX(round(2**32*self.baudrate/self.clk_freq))
        m.submodules.tx = tx
        m.d.comb += [
            tx.stb.eq(1),
            tx.data.eq(ord("A")),
            self.serial_tx.eq(tx.tx)
        ]
        
        return m


def main():
    top = Top()
    output = verilog.convert(Fragment.get(top, None),
        ports=(top.clk156_p, top.clk156_n, top.serial_tx))
    print(output)

if __name__ == "__main__":
    main()
