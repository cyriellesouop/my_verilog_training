#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog counter.v

xvlog testbench.v

xelab testbench -debug all 

xsim testbench -R
