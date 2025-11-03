#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog memory.v

xvlog cpu.v

xvlog cpu_tb.v


xelab  cpu_tb -debug all 

xsim cpu_tb -R
