#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog comparator.v

xvlog generator.v

xvlog testbench.v

xelab testbench -debug all 

xsim testbench -R
