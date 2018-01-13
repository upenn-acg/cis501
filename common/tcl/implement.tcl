set outputDir ./output
file mkdir $outputDir

# read the contents of a file and return it as a string
proc get_file_contents { filename } {
    if {[catch {
        set FH [open $filename r]
        set content [read $FH]
        close $FH
    } errorstring]} {
        error " File $filename could not be opened : $errorstring "
    }
    return $content
}

read_verilog [get_file_contents .synthesis-source-files]

# only add constraint files if there are any
if { [string length [get_file_contents .constraint-files]] > 0 } {
    read_xdc [get_file_contents .constraint-files]
}

# synthesize for zedboard chip 
synth_design -top [get_file_contents .top-level-module] -part xc7z020clg484-1

# reports about the synthesized design
report_timing_summary -file $outputDir/post_synth_timing_summary_report.txt
report_utilization -file $outputDir/post_synth_utilization.txt
report_drc -file $outputDir/post_synth_drc_report.txt

# run place & route
opt_design
place_design
route_design

# reports about the implemented design
report_power -file $outputDir/post_route_power_report.txt
report_clocks -file $outputDir/post_route_clocks_report.txt
report_design_analysis -file $outputDir/post_route_design_analysis_report.txt
report_utilization -file $outputDir/post_route_utilization_report.txt
report_route_status -file $outputDir/post_route_status_report.txt
report_timing -file $outputDir/post_route_timing_report.txt
report_timing_summary -file $outputDir/post_route_timing_summary_report.txt
report_drc -file $outputDir/post_route_drc_report.txt

# write out the bitstream
write_bitstream -force $outputDir/[get_file_contents .bitstream-filename]
