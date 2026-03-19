set sdc_version 2.0

# set_units -capacitance 1000fF
# set_units -time 1000ps

# Set the current design
current_design sha256

create_clock -name "clk" -period 1000 [get_ports clk]

#/**********************************************************
# Set Input and Output Delays on I/O Pins of Top Module
#**********************************************************/ 
#set_input_delay -clock clk 300 [all_inputs]
#set_output_delay -clock clk 300 [all_outputs]

#/**********************************************************
# Set the Load to Derive the Output of Top Module
#**********************************************************/ 
#set_clock_transition 0.0 [get_clocks C]
#set_load -pin_load 10.0 [get_ports DONE]



