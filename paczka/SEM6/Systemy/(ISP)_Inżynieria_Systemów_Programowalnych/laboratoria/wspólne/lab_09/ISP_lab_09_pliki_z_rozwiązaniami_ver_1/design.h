#include "systemc.h"

SC_MODULE (gray_counter) {
  sc_in_clk     clock;
  sc_in<bool>   reset;
  sc_out<sc_uint<3>> led_o;

  sc_signal<sc_uint<3>> state;

  void gray_process() {
    if (reset.read() == 1) {
        state.write(0);
        led_o.write(0);
    } else if (clock.posedge()) {
        sc_uint<3> next_state = (state.read() + 1) & 0b111;
        state.write(next_state);

        led_o.write((next_state >> 1) ^ next_state);
    }
  }


  SC_CTOR(gray_counter) {
    cout << "Executing new" << endl;
    SC_METHOD(gray_process);
    sensitive << reset;
    sensitive << clock.pos();
  }

};
