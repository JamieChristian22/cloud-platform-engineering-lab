# VPC Design

## VPC Name

`enterprise-vpc`

## CIDR Block

`10.0.0.0/16`

## Purpose

The VPC provides an isolated AWS network environment for enterprise workloads.

## Design Reasoning

A `/16` CIDR range allows room for multiple subnets, future workloads, and environment expansion.
