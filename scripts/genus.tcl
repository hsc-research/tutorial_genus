
#look for !TODO! markers. these indicate locations where you should make changes to the script to exercise different aspects of synthesis

# RTL path is the folder than contains your RTL files, your inputs to synthesis
set RTL_PATH		"../sources/"
# LIB path is the folder than contains your Liberty files with the timing/power information about your standard cells
set LIB_PATH 		"../lib/"
# LEF_PATH refers to the folder that contains the LEF files that describe the physical dimentions of the cells and the locations of their pins. 
# this is not a full layout though, it is just a front-end view or abstract view of the cells
set LEF_PATH		"../lef/scaled/"
# TLEF_PATH is the folder that contains the technology LEF file which describes your metal stack: how many metals you have, how wide they are, what the vias between them look like and so on.
set TLEF_PATH		"../techlef/"
# QRC_PATH is the path that contains your QRC files used for extraction. It contains more detailed information about the metal layers than the LEF files, with precise R and C estimations for the wires based on how long/fat they are.
set QRC_PATH 		"../qrc/"
# DESIGN is a user variable. It is useful to make the script reusable for different designs
set DESIGN 		"sha256"

# Standard cell libraries to be used. The should be located in LIB_PATH
# !TODO! Task 9, Task 10
#set LIB_LIST {  asap7sc7p5t_AO_RVT_TT_nldm_211120.lib   asap7sc7p5t_INVBUF_RVT_TT_nldm_220122.lib   asap7sc7p5t_OA_RVT_TT_nldm_211120.lib   asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib   asap7sc7p5t_SIMPLE_RVT_TT_nldm_211120.lib }
set LIB_LIST {  asap7sc7p5t_AO_LVT_TT_nldm_211120.lib   asap7sc7p5t_INVBUF_LVT_TT_nldm_220122.lib   asap7sc7p5t_OA_LVT_TT_nldm_211120.lib   asap7sc7p5t_SEQ_LVT_TT_nldm_220123.lib   asap7sc7p5t_SIMPLE_LVT_TT_nldm_211120.lib }

# LEF files to be used. They should be located in LEF_PATH or TLEF_PATH
set LEF_LIST { asap7_tech_4x_201209.lef asap7sc7p5t_28_L_4x_220121a.lef asap7sc7p5t_28_R_4x_220121a.lef asap7sc7p5t_28_SL_4x_220121a.lef}

set QRC_FILE "qrcTechFile_typ03_scaled4xV06"

# All HDL files used in your design, separated by spaces
# Verilog files can be given in no specific order
set RTL_LIST {sha256.v sha256_core.v sha256_k_constants.v sha256_w_mem.v}

# !TODO! Task 11
#set RTL_LIST {sha256_pipe.v sha256_core.v sha256_k_constants.v sha256_w_mem.v}

set_db init_lib_search_path "$LIB_PATH $LEF_PATH $TLEF_PATH"
set_db init_hdl_search_path $RTL_PATH 
set_db / .library "$LIB_LIST"
set_db lef_library "$LEF_LIST"
set_db qrc_tech_file "$QRC_PATH/$QRC_FILE"

# !TODO! Task 8
#set_db syn_generic_effort high
#set_db syn_map_effort     high
#set_db syn_opt_effort	  high
#set_db lp_power_analysis_effort high
#set_db power_optimization_effort high
#set_db design_power_effort high

# Optionally, you can define messages to be supressed from your logs/terminal reports. This is handy because usually there are dozens of benign warnings that pollute the screen.
# !TODO! Task 12
#suppress_messages {LBR-30 LBR-31 LBR-40 LBR-41 LBR-72 LBR-77 LBR-162}

# !TODO! Task 6
#set_db lp_insert_clock_gating true

# !TODO! Task 10
#set_dont_use AOI22xp33_ASAP7_75t_L true

read_hdl ${RTL_LIST}

# Elaborate the top level
elaborate $DESIGN

# this is the preferred retiming flow, i.e., automated
# !TODO! Task 11
#set_db design:sha256 .retime true

# these are very simple constraints so we can do them inline here. in general, these are coded in a separate SDC file.
# !TODO! Task 7, Task 10
create_clock -name "clk" -period 1000 [get_ports clk]

# !TODO! Task 4
#set_input_delay -clock clk 300 [all_inputs]
#set_output_delay -clock clk 300 [all_outputs]

# GENERIC SYNTHESIS
syn_generic

## this is the old retiming flow
#retime -prepare
#retime -min_delay

# MAPPING
syn_map

# OPT
syn_opt

# !TODO! Task 11
#syn_opt -incremental

#this will overwrite any previous netlist you might have. comment out if you don't want this behavior
write_hdl > $DESIGN.netlist.v

# !TODO! Task 3 - uncomment these lines to get reports directly on text files every time you run this script.
# REPORTING (Timing, Area, Gates, Power)
#report clocks > ./$DESIGN.clocks.rep
#report timing > ./$DESIGN.timing.rep
#report area   > ./$DESIGN.area.rep
#report gates  > ./$DESIGN.gates.rep
#report power  > ./$DESIGN.power.rep


