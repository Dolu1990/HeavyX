from nmigen import *


class RoundRobin:
    def __init__(self, n):
        self.n = n
        self.request = Signal(n)
        self.grant = Signal(max=n)

    def elaborate(self, platform):
        m = Module()
        n = self.n
        if n > 1:
            with m.Switch(self.grant):
                for i in range(n):
                    with m.Case(i):
                        with m.If(~self.request[i]):
                            for j in reversed(range(i+1, i+n)):
                                t = j % n
                                with m.If(self.request[t]):
                                    m.d.sync += self.grant.eq(t)
        else:
            m.d.comb += self.grant.eq(0)
        return m
