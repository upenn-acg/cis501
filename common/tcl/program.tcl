if {[catch open_hw errorString]} {
    puts "Could not open hardware: $errorString"
    exit 1
}
if {[catch connect_hw_server errorString]} {
    puts "Could not connect to hardware server: $errorString"
    exit 1
}
if {[catch open_hw_target errorString]} {
    puts "Could not open hardware target: $errorString"
    puts "Is USB cable connected?"
    exit 1
}
if {[catch current_hw_device xc7z020_1 errorString]} {
    # as a practical matter, this is just setting a variable so I don't think it can fail
    puts "Couldn't set current hardware device: $errorString"
    exit 1
}
if {[catch {create_hw_bitstream -hw_device [ current_hw_device ] TODO.bit} errorString]} {
    puts "Couldn't associate bitstream with the FPGA: $errorString"
    exit 1
}
if {[catch program_hw_devices errorString]} {
    puts "Error programming the FPGA: $errorString"
    exit 1
}
