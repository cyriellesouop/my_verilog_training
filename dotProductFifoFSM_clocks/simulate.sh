#! /bin/sh

rm -rf xsim.dir
rm -f *.log *.jou *.wdb


#xvlog memory.v 

#xvlog memory_reader.v

#xvlog memory_writer.v

#xvlog multiplier.v

#xvlog dot_product.v

#xvlog top.v

#xvlog testbench1.v

#xelab  testbench -debug all

#xsim  testbench -R



#xvlog tb_dotProduct.v

#xelab  tb_dotProduct -debug all
 
#xsim  tb_dotProduct -R


xvlog multiplier.v

xvlog tb_multiplier.v

xelab  tb_multiplier -debug all
 
xsim  tb_multiplier -R


#xvlog tb_writer.v

#xelab tb_writer -debug all

#xsim tb_writer -R

#xvlog tb_reader.v

#xelab tb_reader -debug all

#xsim tb_reader -R



#xvlog tb_memory.v

#xelab tb_memory -debug all

#xsim tb_memory -R

