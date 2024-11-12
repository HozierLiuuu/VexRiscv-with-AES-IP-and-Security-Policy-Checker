
WORK_DIR = /home/yuhao/ProgramFiles/Research/FPGA_Competition/work_1105
TRACE_EN = no

# ---------------------------------------------------------------------------- #
#                                 Generate RTL                                 #
# ---------------------------------------------------------------------------- #
gen_verilog:
	@cd VexRiscv && sbt "runMain vexriscv.demo.Briey"
	
# ---------------------------------------------------------------------------- #
#                           Simulation via verilator                           #
# ---------------------------------------------------------------------------- #
sim_verilator:
	@cd VexRiscv/src/test/cpp/briey/ && make clean run TRACE=$(TRACE_EN)

# ---------------------------------------------------------------------------- #
#                             Software  related                                #
# ---------------------------------------------------------------------------- #
CASE = test
connect:
	@cd /usr/local/openocd_riscv && src/openocd -f tcl/interface/jtag_tcp.cfg \
	-c "set BRIEY_CPU0_YAML $(WORK_DIR)/VexRiscv/cpu0.yaml" \
	-f /usr/local/openocd_riscv/tcl/target/briey.cfg
buildcase:
	@cd VexRiscvSocSoftware/projects/briey/$(CASE) && rm -rf ./build/* \
	&& make

runcase:
	@/opt/riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-linux-ubuntu14/bin/riscv64-unknown-elf-gdb \
	VexRiscvSocSoftware/projects/briey/$(CASE)/build/$(CASE).elf \
	-x ./gdbinit