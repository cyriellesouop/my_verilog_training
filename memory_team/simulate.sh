#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog memory.v 

xvlog top.v 

xvlog testbench.v

xelab testbench -debug all

xsim testbench -R

