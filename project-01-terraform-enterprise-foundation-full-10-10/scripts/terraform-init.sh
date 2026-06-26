#!/bin/bash
set -e
cd environments/dev
terraform init && terraform validate
