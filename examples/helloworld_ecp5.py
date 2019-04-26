from nmigen import *
from nmigen.back import rtlil

from heavycomps import uart


class Top(Elaboratable):
    def __init__(self, baudrate=115200):
        self.baudrate = baudrate
        self.clk100 = Signal()
        self.serial_tx = Signal()

    def elaborate(self, platform):
        m = Module()

        cd_sync = ClockDomain(reset_less=True)
        m.domains += cd_sync
        m.d.comb += cd_sync.clk.eq(self.clk100)

        string = "Hello World!\r\n"
        mem = Memory(width=8, depth=len(string),
                     init=[ord(c) for c in string])
        m.submodules.rdport = rdport = mem.read_port(synchronous=False)

        tx = uart.RS232TX(round(2**32*self.baudrate/100e6))
        m.submodules.tx = tx
        m.d.comb += [
            tx.stb.eq(1),
            tx.data.eq(rdport.data),
            self.serial_tx.eq(tx.tx)
        ]

        with m.If(tx.ack):
            with m.If(rdport.addr == len(string) - 1):
                m.d.sync += rdport.addr.eq(0)
            with m.Else():
                m.d.sync += rdport.addr.eq(rdport.addr + 1)
        
        return m


def main():
    top = Top()
    output = rtlil.convert(Fragment.get(top, None),
        ports=(top.clk100, top.serial_tx))
    print(output)

if __name__ == "__main__":
    main()
