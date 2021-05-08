#!/bin/bash

aws sso login --profile $1
python3 ~/aws_sso.py $1
