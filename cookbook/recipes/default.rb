#
# Cookbook Name:: icewatch
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe "icewatch::database"
include_recipe "icewatch::web"
