#!/bin/bash

 while true
 do
     kubectl get services 2>&1 | tee -a services-log
     sleep 1
 done
