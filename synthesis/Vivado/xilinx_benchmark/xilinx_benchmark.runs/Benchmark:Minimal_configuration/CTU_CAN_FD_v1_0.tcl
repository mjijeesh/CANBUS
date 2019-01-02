# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z007sclg225-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/synthesis/Vivado/xilinx_benchmark/xilinx_benchmark.cache/wt [current_project]
set_property parent.project_path /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/synthesis/Vivado/xilinx_benchmark/xilinx_benchmark.xpr [current_project]
set_property default_lib lib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo /DOKUMENTY/Skola/CVUT-FEL/CAN_FD_IP_Core/synthesis/Vivado/xilinx_benchmark/xilinx_benchmark.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
set_property generic {dummy=Minimal_configuration use_logger=false rx_buffer_size=32 use_sync=true ID=1 sup_filtA=false sup_filtB=false sup_filtC=false sup_range=false logger_size=8} [current_fileset]
read_vhdl -vhdl2008 -library lib {
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/lib/can_fd_frame_format.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_clean/src/ID_transfer.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/memory_registers/generated/access_signaler.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/memory_registers/generated/address_decoder.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/lib/id_transfer.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/lib/can_constants.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/lib/can_types.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/memory_registers/generated/can_registers_pkg.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_clean/src/Registers_Memory_Interface/generated/can_registers_pkg.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/lib/can_components.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/lib/cmn_lib.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/lib/drv_stat_pkg.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/common/endian_swap.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_clean/src/endian_swap.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/lib/reduce_lib.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/lib/can_fd_register_map.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/lib/synth_context.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/apb/apb_ifc.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_core/bit_destuffing/bit_destuffing.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/frame_filters/bit_filter.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_core/bit_stuffing/bit_stuffing.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/bus_sampling/bus_sampling.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_core/bus_traffic_counters/bus_traffic_counters.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_core/operation_control/operation_control.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_core/protocol_control/protocol_control.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_core/fault_confinement/fault_confinement.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_core/crc/crc_wrapper.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_core/can_core.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_core/crc/can_crc.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/memory_registers/memory_registers.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/rx_buffer/rx_buffer.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/tx_arbitrator/tx_arbitrator.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/frame_filters/frame_filters.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/interrupts/int_manager.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/prescaler/prescaler.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/common/rst_sync.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_top_level.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/memory_registers/generated/cmn_reg_map_pkg.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_clean/src/Registers_Memory_Interface/generated/cmn_reg_map_pkg.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/memory_registers/generated/control_registers_reg_map.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_core/crc/crc_calc.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/memory_registers/generated/data_mux.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/common/dff_arst.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/event_logger/event_logger.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/memory_registers/generated/event_logger_reg_map.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/common/inf_ram_wrapper.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/interrupts/int_module.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/common/majority_decoder_3.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/memory_registers/generated/memory_reg.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/tx_arbitrator/priority_decoder.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/frame_filters/range_filter.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/rx_buffer/rx_buffer_fsm.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/rx_buffer/rx_buffer_pointers.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/common/shift_reg.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/common/shift_reg_preload.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/common/sig_sync.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/tx_arbitrator/tx_arbitrator_fsm.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/txt_buffer/txt_buffer.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/txt_buffer/txt_buffer_fsm.vhd
  /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/src/can_top_apb.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/synthesis/Constraints/CTU_CAN_FD_Xilinx.sdc
set_property used_in_implementation false [get_files /DOKUMENTY/Skola/CVUT-FEL/ctu_can_fd_2/synthesis/Constraints/CTU_CAN_FD_Xilinx.sdc]


synth_design -top CTU_CAN_FD_v1_0 -part xc7z007sclg225-2 -flatten_hierarchy none -retiming


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef CTU_CAN_FD_v1_0.dcp
create_report "Benchmark:Minimal_configuration_synth_report_utilization_0" "report_utilization -file CTU_CAN_FD_v1_0_utilization_synth.rpt -pb CAN_top_level_utilization_synth.pb"
