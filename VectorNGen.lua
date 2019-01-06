local function create (code)
  return load(code, nil, "t", nil)()
end

local function build_arg_list(prefix, count, postfix, extra_args)
  local builder = {}
  for i = 1, count do
    table.insert(builder, ("%s%d%s"):format(prefix or "", i, postfix or ""))
  end
  if extra_args then
    table.insert(builder, extra_args)
  end
  return table.concat(builder, ", ")
end

local function build_repeat_list(str, n)
  return (str..", "):rep(n):sub(1, -3)
end

local function build_code(...)
  local builder = {}
  for i = 1, select("#", ...) do
    local value = select(i, ...)
    if type(value) == "function" then
      for str in coroutine.wrap(value) do
        table.insert(builder, tostring(str))
      end
    else
      table.insert(builder, tostring(value))
    end
  end
  return table.concat(builder, "")
end

local function first(n, ...)
  return table.concat({...}, "", 1, n)
end

local yield = coroutine.yield

local function build_compare_oper(n, id, op)
  return [[
function Vector]]..n..[[.]]..id..[[(a, b)
  local a_is_vec]]..n..[[ = Vector]]..n..[[.is(a)
  local b_is_vec]]..n..[[ = Vector]]..n..[[.is(b)

  local a_is_num  = type(a) == "number"
  local b_is_num  = type(b) == "number"

  if a_is_vec]]..n..[[ and b_is_num then
    return ]]..first(n
    , "a.x "..op.." b\n"
, "       and a.y "..op.." b\n"
, "       and a.z "..op.." b\n"
, "       and a.w "..op.." b\n")..[[
  elseif a_is_num and b_is_vec]]..n..[[ then
    return ]]..first(n
    , "a   "..op.." b.x\n"
, "       and a   "..op.." b.y\n"
, "       and a   "..op.." b.z\n"
, "       and a   "..op.." b.w\n")..[[
  elseif a_is_vec]]..n..[[ and b_is_vec]]..n..[[ then
    return ]]..first(n
    , "a.x "..op.." b.x\n"
, "       and a.y "..op.." b.y\n"
, "       and a.z "..op.." b.z\n"
, "       and a.w "..op.." b.w\n")..[[
  else
    return false
  end
end]]
end

local function build_basic_oper(n, id, op)
return [[
function Vector]]..n..[[.__]]..id..[[(a, b)
  if type(a) == "number" then
    return new(]]..first(n
    , "a "..op.." b.x"
    , ", a "..op.." b.y"
    , ", a "..op.." b.z"
    , ", a "..op.." b.w")..[[)
  elseif type(b) == "number" then
    return new(]]..first(n
    , "a.x "..op.." b"
    , ", a.y "..op.." b"
    , ", a.z "..op.." b"
    , ", a.w "..op.." b")..[[)
  else
    return new(]]..first(n
    , "a.x "..op.." b.x"
    , ", a.y "..op.." b.y"
    , ", a.z "..op.." b.z"
    , ", a.w "..op.." b.w")..[[)
  end
end

function Vector]]..n..[[:]]..id..[[n(]]..first(n, "x", ", y", ", z", ", w")..[[)
]]..first(n - 1
  , "  y = y or x\n"
  , "  z = z or y\n"
  , "  w = w or z\n")..[[
]]..first(n
  , "  self.x = self.x "..op.." x\n"
  , "  self.y = self.y "..op.." y\n"
  , "  self.z = self.z "..op.." z\n"
  , "  self.w = self.w "..op.." w\n")..[[
  return self
end

function Vector]]..n..[[:]]..id..[[v(b)
]]..first(n
  , "  self.x = self.x "..op.." b.x\n"
  , "  self.y = self.y "..op.." b.y\n"
  , "  self.z = self.z "..op.." b.z\n"
  , "  self.w = self.w "..op.." b.w\n")..[[
  return self
end]]
end

return function (n)
  return [[
-- MIT License
--
-- Copyright (c) 2018 Mikkel Lykke Jørgensen (MLJWare)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local ffi = assert(require "ffi", "Vector]]..n..[[ requires ffi enabled to work.")

ffi.cdef[=[
typedef struct {
  double ]]..first(n, "x", ", y", ", z", ", w")..[[;
} Vector]]..n..[[;
]=]
local new = ffi.typeof("Vector]]..n..[[")

local Vector]]..n..[[ = {}
Vector]]..n..[[.__index = Vector]]..n..[[

function Vector]]..n..[[.__tostring(a)
  return ("(]]..build_repeat_list("%.2f", n)..[[)"):format(]]..first(n, "a.x", ", a.y", ", a.z", ", a.w")..[[)
end

function Vector]]..n..[[.serialize(a)
  return ("Vector]]..n..[[(]]..build_repeat_list("%.2f", n)..[[)"):format(]]..first(n, "a.x", ", a.y", ", a.z", ", a.w")..[[)
end

setmetatable(Vector]]..n..[[, {
  __call = function (_, ]]..first(n, "x", ", y", ", z", ", w")..[[)
]]..first(n
, "    x = x or 0\n"
, "    y = y or x\n"
, "    z = z or y\n"
, "    w = w or z\n")..[[
    return new(]]..first(n, "x", ", y", ", z", ", w")..[[)
  end;
})

function Vector]]..n..[[.is(a)
  return ffi.istype("Vector]]..n..[[", a)
end

function Vector]]..n..[[.copy(a)
  return new (a)
end

function Vector]]..n..[[:setn(]]..first(n, "x", ", y", ", z", ", w")..[[)
]]..first(n
, "  self.x = x\n"
, "  self.y = y\n"
, "  self.z = z\n"
, "  self.w = w\n")..[[
  return self
end

function Vector]]..n..[[.setv(a, b)
]]..first(n
, "  a.x = b.x\n"
, "  a.y = b.y\n"
, "  a.z = b.z\n"
, "  a.w = b.w\n")..[[
  return a
end

]]..build_compare_oper(n, "__eq", "==")..[[

]]..build_compare_oper(n, "__le", "<=")..[[

]]..build_compare_oper(n, "__lt", "<")..[[

-- scalar/vector addition
]]..build_basic_oper(n, "add", "+")..[[


-- negation
function Vector]]..n..[[.__unm(a)
  return new(]]..first(n, "-a.x", ", -a.y", ", -a.z", ", -a.w")..[[)
end

function Vector]]..n..[[.negate(a)
]]..first(n
, "  a.x = -a.x\n"
, "  a.y = -a.y\n"
, "  a.z = -a.z\n"
, "  a.w = -a.w\n")..[[
  return a
end

-- scalar/vector subtraction
]]..build_basic_oper(n, "sub", "-")..[[


-- scalar or element-wise division
]]..build_basic_oper(n, "div", "/")..[[


-- scalar or element-wise multiplication
]]..build_basic_oper(n, "mul", "*")..[[


-- sum of the vectors components
function Vector]]..n..[[.sum(a)
  return ]]..first(n, "a.x", " + a.y", " + a.z", " + a.w")..[[

end

-- dot product of two vectors
function Vector]]..n..[[.dot(a, b)
  return ]]..first(n, "a.x * b.x", " + a.y * b.y", " + a.z * b.z", " + a.w * b.w")..[[

end

]]..build_code(function ()
  if n == 3 then
    yield[[
-- cross product of two vectors
function Vector3.cross(a, b)
  local a_x, a_y, a_z = a.x, a.y, a.z
  local b_x, b_y, b_z = b.x, b.y, b.z
  return new( a_y*b_z - a_z*b_y
            , a_z*b_x - a_x*b_z
            , a_x*b_y - a_y*b_x)
end]]
  end
end)..[[

-- length (magnitude) of the vector
function Vector]]..n..[[:length()
  local ]]..first(n, "x", ", y", ", z", ", w")..[[ = ]]..first(n, "self.x", ", self.y", ", self.z", ", self.w")..[[

  return (]]..first(n, "x*x", " + y*y", " + z*z", " + w*w")..[[)^.5
end

-- square length (square magnitude) of the vector
function Vector]]..n..[[:square_length()
  local ]]..first(n, "x", ", y", ", z", ", w")..[[ = ]]..first(n, "self.x", ", self.y", ", self.z", ", self.w")..[[

  return ]]..first(n, "x*x", " + y*y", " + z*z", " + w*w")..[[

end

-- distance between two vectors
function Vector]]..n..[[:distance_to(other)
]]..first(n
, "  local dx = other.x - self.x\n"
, "  local dy = other.y - self.y\n"
, "  local dz = other.z - self.z\n"
, "  local dw = other.w - self.w\n")..[[
  return (]]..first(n, "dx*dx", " + dy*dy", " + dz*dz", " + dw*dw")..[[)^.5
end

-- square distance between two vectors
function Vector]]..n..[[:square_distance_to(other)
]]..first(n
, "  local dx = other.x - self.x\n"
, "  local dy = other.y - self.y\n"
, "  local dz = other.z - self.z\n"
, "  local dw = other.w - self.w\n")..[[
  return ]]..first(n, "dx*dx", " + dy*dy", " + dz*dz", " + dw*dw")..[[

end

-- normalized version of the vector
function Vector]]..n..[[.normalized(a)
  local length = a:length()
  if length == 0 then return a end
  return new(]]..first(n, "a.x/length", ", a.y/length", ", a.z/length", ", a.w/length")..[[)
end

-- normalizes the vector
function Vector]]..n..[[:to_normalized()
  local length = self:length()
  if length == 0 then return self end
  return self:div(length)
end

-- angle between two vectors (in radians)
function Vector]]..n..[[.angle_between(a, b)
  return math.acos(a:dot(b)/(a:length()*b:length()))
end

function Vector]]..n..[[:to_abs()
]]..first(n
, "  self.x = math.abs(self.x)\n"
, "  self.y = math.abs(self.y)\n"
, "  self.z = math.abs(self.z)\n"
, "  self.w = math.abs(self.w)\n")..[[
  return self
end

local tmp = {}
function Vector]]..n..[[.send_to(a, shader, id, scale_factor)
  scale_factor = scale_factor or 1
  ]]..first(n, "tmp[1]", ", tmp[2]", ", tmp[3]", ", tmp[4]")..[[ = ]]..first(n, "a.x/scale_factor", ", a.y/scale_factor", ", a.z/scale_factor", ", a.w/scale_factor")..[[

  shader:send(id, tmp)
end

ffi.metatype("Vector]]..n..[[", Vector]]..n..[[)

-- common vectors

Vector]]..n..[[.ZERO = new(]]..(("0, "):rep(n):sub(1, -3))..[[)
Vector]]..n..[[.ONE  = new(]]..(("1, "):rep(n):sub(1, -3))..[[)

]]..first(n
, "Vector"..n..".X = new("..first(n, "1", ", 0", ", 0", ", 0")..")\n"
, "Vector"..n..".Y = new("..first(n, "0", ", 1", ", 0", ", 0")..")\n"
, "Vector"..n..".Z = new("..first(n, "0", ", 0", ", 1", ", 0")..")\n"
, "Vector"..n..".W = new("..first(n, "0", ", 0", ", 0", ", 1")..")\n")..[[

return Vector]]..n..[[

]]
end
