import unittest

from nmigen import *
from nmigen.back.pysim import *

from heavycomps import uart


class Loopback:
    def __init__(self, tuning_word=2**31):
        self.tx = uart.RS232TX(tuning_word)
        self.rx = uart.RS232RX(tuning_word)

    def elaborate(self, platform):
        m = Module()
        m.submodules.tx = self.tx
        m.submodules.rx = self.rx
        m.d.comb += self.rx.rx.eq(self.tx.tx)
        return m


class TestUART(unittest.TestCase):
    def test_loopback(self):
        dut = Loopback()
        test_vector = [32, 129, 201, 39, 0, 255]

        with Simulator(Fragment.get(dut, None)) as sim:
            sim.add_clock(1e-6)

            def send():
                for value in test_vector:
                    yield from dut.tx.write(value)

            def receive():
                for value in test_vector:
                    received = yield from dut.rx.read()
                    self.assertEqual(received, value)

            sim.add_sync_process(send)
            sim.add_sync_process(receive)
            sim.run()
