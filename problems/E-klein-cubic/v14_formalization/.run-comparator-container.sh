#!/bin/bash
cd /Users/worker/comparator-harness
./run-comparator.sh /Users/worker/unirational/problems/E-klein-cubic/v14_formalization --sandbox real --cpus 6 --memory 48G
echo EXIT:$?
