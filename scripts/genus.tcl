# Script written by Samuel Pagliarini on April 2023. Works well in genus 21.10

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
set QRC_PATH		"../qrc/"

# DESIGN is a user variable. It is useful to make the script reusable for different designs
set DESIGN 		"sha256"

# Baseline Libraries
set LIB_LIST {  asap7sc7p5t_AO_LVT_TT_nldm_211120.lib   asap7sc7p5t_INVBUF_LVT_TT_nldm_220122.lib   asap7sc7p5t_OA_LVT_TT_nldm_211120.lib   asap7sc7p5t_SEQ_LVT_TT_nldm_220123.lib   asap7sc7p5t_SIMPLE_LVT_TT_nldm_211120.lib \
 		asap7sc7p5t_AO_SLVT_TT_nldm_211120.lib  asap7sc7p5t_INVBUF_SLVT_TT_nldm_220122.lib  asap7sc7p5t_OA_SLVT_TT_nldm_211120.lib  asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib  asap7sc7p5t_SIMPLE_SLVT_TT_nldm_211120.lib}

set LEF_LIST { asap7_tech_4x_201209.lef asap7sc7p5t_28_L_4x_220121a.lef asap7sc7p5t_28_R_4x_220121a.lef asap7sc7p5t_28_SL_4x_220121a.lef}

# All HDL files, separated by spaces
set RTL_LIST {sha256.v sha256_core.v sha256_k_constants.v sha256_w_mem.v  }

set_db init_lib_search_path "$LIB_PATH $LEF_PATH $TLEF_PATH"
set_db init_hdl_search_path $RTL_PATH 
set_db / .library "$LIB_LIST"
set_db lef_library "$LEF_LIST"


#set SYN_EFFORT		high
#set MAP_EFFORT		high
#set INC_EFFORT		high
# Optionally, you can define messages to be supressed from your logs/terminal reports. This is handy because usually there are dozens of benign warnings that pollute the screen.
#suppress_messages {LBR-30 LBR-31 LBR-40 LBR-41 LBR-72 LBR-77 LBR-162}
# !TODO! Task 1
#set_attribute hdl_track_filename_row_col true /
#set_attribute lp_power_unit mW /

set_db information_level 0


read_hdl ${RTL_LIST}

# Elaborate the top level
elaborate $DESIGN

# Read the constraint file
#TODO these are very simple constraints, you should probably use an SDC file instead
# the library uses picoseconds as time unit. this causes confusion because default unit in genus is ns
create_clock -name "clk" -period 1000 [get_ports clk]
set_input_delay -clock clk 1 [all_inputs]
set_output_delay -clock clk 300 [all_outputs]

# GENERIC SYNTHESIS
syn_generic

# MAPPING
syn_map

# OPT
syn_opt

#TODO this will overwrite any previous netlist you might have. comment out if you don't want this behavior
write_hdl > netlist.v

#TODO uncomment these lines to get reports directly on text files
# REPORTING (Timing, Area, Gates, Power)
#report timing > ./genus_timing.rep
#report area   > ./genus_area.rep
#report gates  > ./genus_cell.rep
#report power  > ./genus_power.rep


