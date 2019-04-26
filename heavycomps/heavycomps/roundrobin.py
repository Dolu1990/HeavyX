from nmigen import *


class RoundRobin(Elaboratable):
    def __init__(self, n):
        self.n = n
        self.request = Signal(n)
        self.grant = Signal(max=n)

    def elaborate(self, platform):
        m = Module()
        with m.Switch(self.grant):
            for i in range(self.n):
                with m.Case(i):
                    with m.If(~self.request[i]):
                        for j in reversed(range(i+1, i+self.n)):
                            t = j % self.n
                            with m.If(self.request[t]):
                                m.d.sync += self.grant.eq(t)
        return m
