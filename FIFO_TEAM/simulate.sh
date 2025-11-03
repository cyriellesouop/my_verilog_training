#! /bin/sh

rm -rf xsim.dir
rm -f *.log *.jou *.wdb



xvlog fifo.v

xvlog tb1.v
xelab tb -debug all
xsim tb -R
#xvlog testbench1.v

#xelab  testbench -debug all

#xsim  testbench -R






