all: lfsr_cntr.sv
	verilator -I../rtl +1800-2017ext+sv --exe --build --binary -o lfsr_cntr lfsr_cntr.sv

clean:
	rm -rf obj_dir
