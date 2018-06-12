#!/bin/bash

 while true
 do
     kubectl get pods 2>&1 | tee -a pods-log
     sleep 1
 done
