# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: D:\Work\OnDeviceAI2\0623_Prectice_Custom_IP\vitis_workspace\pheripheral_system\_ide\scripts\debugger_pheripheral-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source D:\Work\OnDeviceAI2\0623_Prectice_Custom_IP\vitis_workspace\pheripheral_system\_ide\scripts\debugger_pheripheral-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -filter {jtag_cable_name =~ "Digilent Basys3 210183BE9F20A" && level==0 && jtag_device_ctx=="jsn-Basys3-210183BE9F20A-0362d093-0"}
fpga -file D:/Work/OnDeviceAI2/0623_Prectice_Custom_IP/vitis_workspace/pheripheral/_ide/bitstream/Stopwatch_design_wrapper.bit
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
loadhw -hw D:/Work/OnDeviceAI2/0623_Prectice_Custom_IP/vitis_workspace/Stopwatch_design_wrapper/export/Stopwatch_design_wrapper/hw/Stopwatch_design_wrapper.xsa -regs
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow D:/Work/OnDeviceAI2/0623_Prectice_Custom_IP/vitis_workspace/pheripheral/Debug/pheripheral.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
con
