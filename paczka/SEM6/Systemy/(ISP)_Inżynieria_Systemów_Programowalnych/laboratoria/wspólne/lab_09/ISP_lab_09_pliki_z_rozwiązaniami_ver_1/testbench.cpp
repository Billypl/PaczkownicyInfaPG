#include "systemc.h"
#include "design.h"

int sc_main(int argc, char* argv[]) {
    sc_signal<bool> clock;
    sc_signal<bool> reset;
    sc_signal<sc_uint<3>> led_o;

    gray_counter counter("COUNTER");
    counter.clock(clock);
    counter.reset(reset);
    counter.led_o(led_o);

    sc_trace_file *wf = sc_create_vcd_trace_file("gray_counter");
    sc_trace(wf, clock, "clock");
    sc_trace(wf, reset, "reset");
    sc_trace(wf, led_o, "led_o");

    reset = 0;
    clock = 0;

    sc_uint<3> current_number = 0;
    sc_uint<3> current_number_gray;

    for (int cycle = 0; cycle < 20; ++cycle) {
        clock = 1;
        sc_start(5, SC_NS); 
        clock = 0;
        sc_start(5, SC_NS); 

        if (cycle == 0) {
            reset = 1;
        } else if (cycle == 2) {
            reset = 0;
        }

        if (reset.read() == 0) {
            current_number = (current_number + 1) & 0b111; 
            current_number_gray = (current_number >> 1) ^ current_number;

            if (led_o.read() != current_number_gray) {
                cout << "Error at cycle " << cycle << ": Expected "
                     << current_number_gray << ", got " << led_o.read() << endl;
            }
        } else {
            current_number = 0;
        }
    }

    sc_close_vcd_trace_file(wf);
    cout << "Simulation completed" << endl;

    return 0;
}