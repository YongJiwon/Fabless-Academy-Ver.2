onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib Stopwatch_design_opt

do {wave.do}

view wave
view structure
view signals

do {Stopwatch_design.udo}

run -all

quit -force
