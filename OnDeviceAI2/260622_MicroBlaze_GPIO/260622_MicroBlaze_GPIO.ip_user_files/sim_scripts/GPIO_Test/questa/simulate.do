onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib GPIO_Test_opt

do {wave.do}

view wave
view structure
view signals

do {GPIO_Test.udo}

run -all

quit -force
