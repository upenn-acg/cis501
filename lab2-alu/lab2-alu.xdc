# ----------------------------------------------------------------------------
#     _____
#    /     \
#   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET Design Resource Center
#      \======/         www.em.avnet.com/drc
#       \====/    
# ----------------------------------------------------------------------------
# 
#  Created With Avnet UCF Generator V0.4.0 
#     Date: Saturday, June 30, 2012 
#     Time: 12:18:55 AM 
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#  
#  Please direct any questions to:
#     ZedBoard.org Community Forums
#     http://www.zedboard.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2012 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Notes:
# 
#  10 August 2012
#     IO standards based upon Bank 34 and Bank 35 Vcco supply options of 1.8V, 
#     2.5V, or 3.3V are possible based upon the Vadj jumper (J18) settings.  
#     By default, Vadj is expected to be set to 1.8V but if a different 
#     voltage is used for a particular design, then the corresponding IO 
#     standard within this UCF should also be updated to reflect the actual 
#     Vadj jumper selection.
# 
#  09 September 2012
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.  
#     HDL net names are adjusted to contain no hyphen characters '-' but 
#     rather use underscore '_' characters.  Comment net name with the hyphen 
#     characters will remain in place since these are intended to match the 
#     schematic net names in order to better enable schematic search.
#
#  17 April 2014
#     Pin constraint for toggle switch SW7 was corrected to M15 location.
#
#  16 April 2015
#     Corrected the way that entire banks are assigned to a particular IO
#     standard so that it works with more recent versions of Vivado Design
#     Suite and moved the IO standard constraints to the end of the file 
#     along with some better organization and notes like we do with our SOMs.
#
#   6 June 2016
#     Corrected error in signal name for package pin N19 (FMC Expansion Connector)
#	
#
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y9 [get_ports {oled_ctrl_clk}];  # "GCLK"


# ----------------------------------------------------------------------------
# OLED Display - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN U10  [get_ports {oled_dc}];  # "OLED-DC"
set_property PACKAGE_PIN U9   [get_ports {oled_res}];  # "OLED-RES"
set_property PACKAGE_PIN AB12 [get_ports {oled_sclk}];  # "OLED-SCLK"
set_property PACKAGE_PIN AA12 [get_ports {oled_sdin}];  # "OLED-SDIN"
set_property PACKAGE_PIN U11  [get_ports {oled_vbat}];  # "OLED-VBAT"
set_property PACKAGE_PIN U12  [get_ports {oled_vdd}];  # "OLED-VDD"

# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN U14 [get_ports {LED[7]}]
set_property PACKAGE_PIN U19 [get_ports {LED[6]}]
set_property PACKAGE_PIN W22 [get_ports {LED[5]}]
set_property PACKAGE_PIN V22 [get_ports {LED[4]}]
set_property PACKAGE_PIN U21 [get_ports {LED[3]}]
set_property PACKAGE_PIN U22 [get_ports {LED[2]}]
set_property PACKAGE_PIN T21 [get_ports {LED[1]}]
set_property PACKAGE_PIN T22 [get_ports {LED[0]}]

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN T18 [get_ports {btnU}];  # "BTNU"
#set_property PACKAGE_PIN R16 [get_ports {btnD}];  # "BTND"
set_property PACKAGE_PIN N15 [get_ports {btnL}];  # "BTNL"
#set_property PACKAGE_PIN R18 [get_ports {btnR}];  # "BTNR"
#set_property PACKAGE_PIN P16 [get_ports {btnC}];  # "BTNC"

# ----------------------------------------------------------------------------
# User DIP Switches - Bank 35
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN F22 [get_ports {SWITCH[0]}];
set_property PACKAGE_PIN G22 [get_ports {SWITCH[1]}];
set_property PACKAGE_PIN H22 [get_ports {SWITCH[2]}];
set_property PACKAGE_PIN F21 [get_ports {SWITCH[3]}];
set_property PACKAGE_PIN H19 [get_ports {SWITCH[4]}];
set_property PACKAGE_PIN H18 [get_ports {SWITCH[5]}];
set_property PACKAGE_PIN H17 [get_ports {SWITCH[6]}];
set_property PACKAGE_PIN M15 [get_ports {SWITCH[7]}];


# ----------------------------------------------------------------------------
# IOSTANDARD Constraints
#
# Note that these IOSTANDARD constraints are applied to all IOs currently
# assigned within an I/O bank.  If these IOSTANDARD constraints are 
# evaluated prior to other PACKAGE_PIN constraints being applied, then 
# the IOSTANDARD specified will likely not be applied properly to those 
# pins.  Therefore, bank wide IOSTANDARD constraints should be placed 
# within the XDC file in a location that is evaluated AFTER all 
# PACKAGE_PIN constraints within the target bank have been evaluated.
#
# Un-comment one or more of the following IOSTANDARD constraints according to
# the bank pin assignments that are required within a design.
# ---------------------------------------------------------------------------- 

# Set the bank voltage for the buttons to 1.8V by default.
#set_property IOSTANDARD LVCMOS18 [get_ports {btnU}];
#set_property IOSTANDARD LVCMOS18 [get_ports {btnD}];
set_property IOSTANDARD LVCMOS18 [get_ports {btnL}];
#set_property IOSTANDARD LVCMOS18 [get_ports {btnR}];
#set_property IOSTANDARD LVCMOS18 [get_ports {btnC}];

# Set the voltage for the switches to 1.8V, though they can also be 2.5V or 3.3V
# (commented out below) if desired
#set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[*]}];
#set_property IOSTANDARD LVCMOS25 [get_ports {SWITCH[*]}];
set_property IOSTANDARD LVCMOS18 [get_ports {SWITCH[*]}];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports {oled_ctrl_clk}];
set_property IOSTANDARD LVCMOS33 [get_ports {oled_dc}];
set_property IOSTANDARD LVCMOS33 [get_ports {oled_res}];
set_property IOSTANDARD LVCMOS33 [get_ports {oled_sclk}];
set_property IOSTANDARD LVCMOS33 [get_ports {oled_sdin}];
set_property IOSTANDARD LVCMOS33 [get_ports {oled_vbat}];
set_property IOSTANDARD LVCMOS33 [get_ports {oled_vdd}];

# Note that the voltage for the LEDs is fixed to 3.3V on the ZedBoard
set_property IOSTANDARD LVCMOS33 [get_ports {LED[*]}];

# 100MHz clock for OLED controller
create_clock -period 10.000 -name oled_ctrl_clk -waveform {0.000 5.000} [get_ports oled_ctrl_clk]

