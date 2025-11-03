#! /bin/sh

rm -rf xsim.dir

rm -f *.log *.jou *.wdb

xvlog converter.v

xvlog tb_converter.v

xelab tb_converter -debug all 

xsim tb_converter -R
