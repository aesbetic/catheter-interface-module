source [file join [file dirname [info script]] board_config.tcl]

create_project -part $part -force $proj_name $build_dir

# add source files
add_files -fileset sources_1 $src_files
set_property file_type {VHDL 2008} [get_files $src_files]
set_property top $top [get_filesets sources_1]

# add constraints
add_files -fileset constrs_1 $constraints_file

if {[file isdirectory [file join $project_dir sim]]} {
    set sim_files [glob -nocomplain [file join $project_dir sim *.vhd]]
    if {[llength $sim_files] > 0} {
        add_files -fileset sim_1 $sim_files
        set_property file_type {VHDL 2008} [get_files $sim_files]
    }
}
