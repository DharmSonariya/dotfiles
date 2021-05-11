#!/bin/bash -e

aws sso login --profile $1
yawsso -p $1
