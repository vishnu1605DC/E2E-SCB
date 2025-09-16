n {1..3}
do
	  echo "Running simulation with n=$n"
	    vsim -c -do "vlib work; vmap work work; vlog -sv E2E_scb.sv; vsim -c work.test +n=$n -do {run -all; quit;}"
    done

    
