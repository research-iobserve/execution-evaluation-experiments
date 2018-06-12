#!/bin/bash

 while true
 do
     kubectl get deployments 2>&1 | tee -a deployments-log
     sleep 1
 done
