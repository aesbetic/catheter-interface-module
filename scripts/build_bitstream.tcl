source [file join [file dirname [info script]] board_config.tcl]
open_project $project_file

# figure out dependencies
update_compile_order -fileset sources_1

reset_run synth_1
launch_runs -jobs 4 synth_1
wait_on_run synth_1

if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
    error "Synthesis failed: [get_property STATUS [get_runs synth_1]]"
}

launch_runs -jobs 4 impl_1 -to_step write_bitstream
wait_on_run impl_1

if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
    error "Implementation failed: [get_property STATUS [get_runs impl_1]]"
}

set generated_bitstream [file join [get_property DIRECTORY [get_runs impl_1]] ${top}.bit]
if {![file isfile $generated_bitstream]} {
    error "Bitstream was not generated: $generated_bitstream"
}
file mkdir [file dirname $bitstream_file]
file copy -force $generated_bitstream $bitstream_file
puts "Bitstream: $bitstream_file"
