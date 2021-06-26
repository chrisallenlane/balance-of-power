local file = require 'pl.file'
local lfs = require 'lfs'
local lyaml = require 'lyaml'
local serialize = require('../src/serialize')
local tablex = require 'pl.tablex'

-- store stage data parsed from YAML
local stages = {}

-- iterate over files in the stage directory
-- NB: there has to be a less stupid way to do this
for f in lfs.dir('stage') do
  if f ~= '.' and f ~= '..' then
    local stage = lyaml.load(file.read('stage/' .. f))
    table.insert(stages, serialize(stage))
  end
end

-- write all stage data to a single string
-- NB: this (somehow) seems to be the least stupid way to do this in Lua
local lines = ''
for _, line in tablex.sortv(stages) do lines = lines .. '&' .. line end
lines = '"' .. string.sub(lines, 2, -1) .. '"'

-- output templated Lua code
print(
  [[-- This is machine-generated code. Do not edit! --
Stages, StageData = {}, ]] .. lines
);
