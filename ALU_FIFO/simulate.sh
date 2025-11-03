#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog converter.v

xvlog fifo.v

xvlog alu.v

xvlog alu_fifo.v

xvlog testbench.v

xelab testbench -debug all 

xsim testbench -R
