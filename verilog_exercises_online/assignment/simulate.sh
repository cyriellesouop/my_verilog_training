#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog testbench2.v

xelab testbench2 

xsim testbench2 -R
