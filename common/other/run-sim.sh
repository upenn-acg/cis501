#!/bin/bash

if [ -z "$2" ]
then
    echo "usage: $0 test_module_name verilog_files..."
    exit 1
fi

rm -rf xsim.dir/ webtalk* xsim* xelab.* sim.wdb
echo -n verilog mylib $2 $3 $4 $5 $6 $7 > .prj
xelab -cc gcc --debug off --prj .prj --snapshot snapshot.sim --lib mylib mylib.$1
xsim snapshot.sim --runall --stats -wdb sim.wdb
