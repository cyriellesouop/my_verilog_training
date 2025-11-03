#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog half_adder.v

xvlog full_adder.v

xvlog adder.v

xvlog segctrl.v

xvlog segconv.v

xvlog top.v

xvlog testbench.v

xelab testbench -debug all 

xsim testbench -R
