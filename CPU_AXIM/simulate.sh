#!/bin/sh

rm -rf *.log *.wdb *.jou xsim.dir *.str *.pb

xvlog -sv cpu.sv

xvlog -sv  tb_cpu.v

xelab tb_cpu --debug all

xsim tb_cpu -R

