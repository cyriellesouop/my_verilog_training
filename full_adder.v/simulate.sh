#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog half_adder.v 

xvlog full_adder.v 

xvlog adder.v 

xvlog testbench.v

xelab testbench -debug all

xsim testbench -R

