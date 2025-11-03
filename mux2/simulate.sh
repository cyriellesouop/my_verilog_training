#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog mux.v 

xvlog mux4input.v

xvlog testbench.v

xelab testbench -debug all

xsim testbench -R

