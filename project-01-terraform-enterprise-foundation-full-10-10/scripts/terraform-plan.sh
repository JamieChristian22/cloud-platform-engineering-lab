#!/bin/bash
set -e
cd environments/dev
terraform fmt -recursive && terraform validate && terraform plan
