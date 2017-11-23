################################################################################
##
## CAN with Flexible Data-Rate IP Core 
##
## Copyright (C) 2015 Ondrej Ille <ondrej.ille@gmail.com>
##
## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 2
## of the License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## The CAN protocol is developed by Robert Bosch GmbH and     
## protected by patents. Anybody who wants to implement this    
## IP core on silicon has to obtain a CAN protocol license
## from Bosch.
##  
## Description:
## 			TX Arbitrator unit test handling script
################################################################################
global TCOMP

start_CAN_simulation "tx_arb_unit_test_wrapper"

################################################################################
# Adding the waves
################################################################################

#Add common waves for each test entity
add_test_status_waves
add_system_waves

#Add circuit specific signals
add wave -noupdate -divider -height 20 "DUT inputs (generated)"									 
add wave -label "Buffer 1 allowed" $TCOMP/drv_allow_txt1								
add wave -label "Buffer 2 allowed" $TCOMP/drv_allow_txt2
add wave -label "Buffer 1 Output" -hexadecimal $TCOMP/txt1_buffer_in
add wave -label "Buffer 2 Output" -hexadecimal $TCOMP/txt2_buffer_in
add wave -label "Timestamp" -unsigned $TCOMP/timestamp

add wave -noupdate -divider -height 20 "DUT outputs"
add wave -label "Data output" -hexadecimal $TCOMP/tran_data_out
add wave -label "Identifier output" -hexadecimal $TCOMP/tran_ident_out
add wave -label "DLC" $TCOMP/tran_dlc_out
add wave -label "RTR" $TCOMP/tran_is_rtr
add wave -label "Identifier type" $TCOMP/tran_ident_type_out
add wave -label "Frame format" $TCOMP/tran_frame_type_out
add wave -label "BRS" $TCOMP/tran_brs_out
add wave -label "Output frame is valid" $TCOMP/tran_frame_valid_out

add wave -noupdate -divider -height 20 "Internal DUT signals"								
add wave $TCOMP/tx_arbitrator_comp/valid_join
add wave $TCOMP/tx_arbitrator_comp/mess_src
add wave $TCOMP/tx_arbitrator_comp/mess_time1
add wave $TCOMP/tx_arbitrator_comp/mess_time2
add wave $TCOMP/tx_arbitrator_comp/ts_valid
add wave $TCOMP/tx_arbitrator_comp/id_1_dec
add wave $TCOMP/tx_arbitrator_comp/id_2_dec
									 
################################################################################
# Execute the simulation, gather results
################################################################################
run_simulation
get_test_results


