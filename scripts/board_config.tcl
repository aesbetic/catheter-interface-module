# Shared by project creation and bitstream generation.
set project_dir [file dirname [file dirname [file normalize [info script]]]]
set proj_name [file tail $project_dir]

if {[llength $argv] > 1} {
    error "Expected one board argument: basys3 or arty-a7-100"
}
set board basys3
if {[llength $argv] == 1} {
    set board [lindex $argv 0]
}

switch -- $board {
    basys3 {
        set part xc7a35tcpg236-1
        set top basys_top
        set xdc_file basys3-master.xdc
    }
    arty-a7-100 {
        set part xc7a100tcsg324-1
        set top arty_top
        set xdc_file Arty-A7-100-Master.xdc
    }
    default {
        error "Unsupported board '$board'; choose basys3 or arty-a7-100"
    }
}

set build_dir [file join $project_dir build $board]
set project_file [file join $build_dir ${proj_name}.xpr]
set bitstream_file [file join $project_dir out $board ${proj_name}.bit]
set constraints_file [file join $project_dir constraints $xdc_file]
set src_files [glob [file join $project_dir src *.vhd]]
