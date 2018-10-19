#!/bin/bash

ping -c 2 -I eth0 8.8.8.8 >> /dev/null 2>&1
echo $?
