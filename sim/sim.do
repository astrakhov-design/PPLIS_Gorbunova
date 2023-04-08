transcript on

# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

vlog -f sim.files

vsim -voptargs="+acc -debugDB" work.tb_top

run -all