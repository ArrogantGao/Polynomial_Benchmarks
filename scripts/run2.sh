#!/bin/bash

output_file=$1

touch "$output_file"
echo 'n,T,et,ht,pt' >> $output_file

julia --threads 1 --project=. run_polys.jl --output-file "$output_file"