
#define your target name. ex. if you define "system", process generates "system.bit"
TARGET	= system

#define your source files here. it supports verilog files only.
HDL_SRC	= main.v

#define your constraints file. ex. system.ucf
CON_SRC = system.ucf

#define your picoblaze sources here, if exists
PSM_SRC = 

#define your target semiconductor device. ex. xc4vlx25-ff668-10 for Virtex4-lx25 chip 
DEVICE = xc4vlx25-ff668-10

include rules.mk
