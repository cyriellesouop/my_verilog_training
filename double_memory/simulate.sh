#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog encoder1.v

xvlog encoder2.v

xvlog mainmemory.v

xvlog testbench.v

xelab testbench -debug all 

xsim testbench -R
