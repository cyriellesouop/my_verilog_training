#!/bin/sh

rm -rf *.log *.wdb *.jou xsim.dir *.str *.pb

xvlog -sv cpu.sv
