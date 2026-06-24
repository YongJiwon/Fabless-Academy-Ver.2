# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct D:\Work\OnDeviceAI2\0623_Prectice_Custom_IP\vitis_workspace\Stopwatch_design_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source D:\Work\OnDeviceAI2\0623_Prectice_Custom_IP\vitis_workspace\Stopwatch_design_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {Stopwatch_design_wrapper}\
-hw {D:\Work\OnDeviceAI2\0623_Prectice_Custom_IP\XSA\Stopwatch_design_wrapper.xsa}\
-fsbl-target {psu_cortexa53_0} -out {D:/Work/OnDeviceAI2/0623_Prectice_Custom_IP/vitis_workspace}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {Stopwatch_design_wrapper}
platform generate -quick
platform generate
