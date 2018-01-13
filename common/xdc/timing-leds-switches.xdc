# timing constraints for Zedboard LEDs and switches

# LEDs have zero setup/hold (min/max) timing requirements
set_output_delay -clock [get_clocks GCLOCK] -min 0.000 [get_ports {LED[*]}]
set_output_delay -clock [get_clocks GCLOCK] -max 0.000 [get_ports {LED[*]}]

# Switches have zero setup/hold (min/max) timing requirements
set_input_delay -clock [get_clocks GCLOCK] -min 0.000 [get_ports {SWITCH[*]}]
set_input_delay -clock [get_clocks GCLOCK] -max 0.000 [get_ports {SWITCH[*]}]
