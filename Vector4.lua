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

local ffi = assert(require "ffi", "Vector4 requires ffi enabled to work.")

ffi.cdef[=[
typedef struct {
  double x, y, z, w;
} Vector4;
]=]
local new = ffi.typeof("Vector4")

local Vector4 = {}
Vector4.__index = Vector4
function Vector4.__tostring(a)
  return ("(%.2f, %.2f, %.2f, %.2f)"):format(a.x, a.y, a.z, a.w)
end

function Vector4.serialize(a)
  return ("Vector4(%.2f, %.2f, %.2f, %.2f)"):format(a.x, a.y, a.z, a.w)
end

setmetatable(Vector4, {
  __call = function (_, x, y, z, w)
    x = x or 0
    y = y or x
    z = z or y
    w = w or z
    return new(x, y, z, w)
  end;
})

function Vector4.is(a)
  return ffi.istype("Vector4", a)
end

function Vector4.copy(a)
  return new (a)
end

function Vector4:setn(x, y, z, w)
  self.x = x
  self.y = y
  self.z = z
  self.w = w
  return self
end

function Vector4.setv(a, b)
  a.x = b.x
  a.y = b.y
  a.z = b.z
  a.w = b.w
  return a
end

function Vector4.__eq(a, b)
  local a_is_vec4 = Vector4.is(a)
  local b_is_vec4 = Vector4.is(b)

  local a_is_num  = type(a) == "number"
  local b_is_num  = type(b) == "number"

  if a_is_vec4 and b_is_num then
    return a.x == b
       and a.y == b
       and a.z == b
       and a.w == b
  elseif a_is_num and b_is_vec4 then
    return a   == b.x
       and a   == b.y
       and a   == b.z
       and a   == b.w
  elseif a_is_vec4 and b_is_vec4 then
    return a.x == b.x
       and a.y == b.y
       and a.z == b.z
       and a.w == b.w
  else
    return false
  end
end
function Vector4.__le(a, b)
  local a_is_vec4 = Vector4.is(a)
  local b_is_vec4 = Vector4.is(b)

  local a_is_num  = type(a) == "number"
  local b_is_num  = type(b) == "number"

  if a_is_vec4 and b_is_num then
    return a.x <= b
       and a.y <= b
       and a.z <= b
       and a.w <= b
  elseif a_is_num and b_is_vec4 then
    return a   <= b.x
       and a   <= b.y
       and a   <= b.z
       and a   <= b.w
  elseif a_is_vec4 and b_is_vec4 then
    return a.x <= b.x
       and a.y <= b.y
       and a.z <= b.z
       and a.w <= b.w
  else
    return false
  end
end
function Vector4.__lt(a, b)
  local a_is_vec4 = Vector4.is(a)
  local b_is_vec4 = Vector4.is(b)

  local a_is_num  = type(a) == "number"
  local b_is_num  = type(b) == "number"

  if a_is_vec4 and b_is_num then
    return a.x < b
       and a.y < b
       and a.z < b
       and a.w < b
  elseif a_is_num and b_is_vec4 then
    return a   < b.x
       and a   < b.y
       and a   < b.z
       and a   < b.w
  elseif a_is_vec4 and b_is_vec4 then
    return a.x < b.x
       and a.y < b.y
       and a.z < b.z
       and a.w < b.w
  else
    return false
  end
end
-- scalar/vector addition
function Vector4.__add(a, b)
  if type(a) == "number" then
    return new(a + b.x, a + b.y, a + b.z, a + b.w)
  elseif type(b) == "number" then
    return new(a.x + b, a.y + b, a.z + b, a.w + b)
  else
    return new(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
  end
end

function Vector4:addn(x, y, z, w)
  y = y or x
  z = z or y
  w = w or z
  self.x = self.x + x
  self.y = self.y + y
  self.z = self.z + z
  self.w = self.w + w
  return self
end

function Vector4:addv(b)
  self.x = self.x + b.x
  self.y = self.y + b.y
  self.z = self.z + b.z
  self.w = self.w + b.w
  return self
end

-- negation
function Vector4.__unm(a)
  return new(-a.x, -a.y, -a.z, -a.w)
end

function Vector4.negate(a)
  a.x = -a.x
  a.y = -a.y
  a.z = -a.z
  a.w = -a.w
  return a
end

-- scalar/vector subtraction
function Vector4.__sub(a, b)
  if type(a) == "number" then
    return new(a - b.x, a - b.y, a - b.z, a - b.w)
  elseif type(b) == "number" then
    return new(a.x - b, a.y - b, a.z - b, a.w - b)
  else
    return new(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
  end
end

function Vector4:subn(x, y, z, w)
  y = y or x
  z = z or y
  w = w or z
  self.x = self.x - x
  self.y = self.y - y
  self.z = self.z - z
  self.w = self.w - w
  return self
end

function Vector4:subv(b)
  self.x = self.x - b.x
  self.y = self.y - b.y
  self.z = self.z - b.z
  self.w = self.w - b.w
  return self
end

-- scalar or element-wise division
function Vector4.__div(a, b)
  if type(a) == "number" then
    return new(a / b.x, a / b.y, a / b.z, a / b.w)
  elseif type(b) == "number" then
    return new(a.x / b, a.y / b, a.z / b, a.w / b)
  else
    return new(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w)
  end
end

function Vector4:divn(x, y, z, w)
  y = y or x
  z = z or y
  w = w or z
  self.x = self.x / x
  self.y = self.y / y
  self.z = self.z / z
  self.w = self.w / w
  return self
end

function Vector4:divv(b)
  self.x = self.x / b.x
  self.y = self.y / b.y
  self.z = self.z / b.z
  self.w = self.w / b.w
  return self
end

-- scalar or element-wise multiplication
function Vector4.__mul(a, b)
  if type(a) == "number" then
    return new(a * b.x, a * b.y, a * b.z, a * b.w)
  elseif type(b) == "number" then
    return new(a.x * b, a.y * b, a.z * b, a.w * b)
  else
    return new(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w)
  end
end

function Vector4:muln(x, y, z, w)
  y = y or x
  z = z or y
  w = w or z
  self.x = self.x * x
  self.y = self.y * y
  self.z = self.z * z
  self.w = self.w * w
  return self
end

function Vector4:mulv(b)
  self.x = self.x * b.x
  self.y = self.y * b.y
  self.z = self.z * b.z
  self.w = self.w * b.w
  return self
end

-- sum of the vectors components
function Vector4.sum(a)
  return a.x + a.y + a.z + a.w
end

-- dot product of two vectors
function Vector4.dot(a, b)
  return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
end


-- length (magnitude) of the vector
function Vector4:length()
  local x, y, z, w = self.x, self.y, self.z, self.w
  return (x*x + y*y + z*z + w*w)^.5
end

-- square length (square magnitude) of the vector
function Vector4:square_length()
  local x, y, z, w = self.x, self.y, self.z, self.w
  return x*x + y*y + z*z + w*w
end

-- distance between two vectors
function Vector4:distance_to(other)
  local dx = other.x - self.x
  local dy = other.y - self.y
  local dz = other.z - self.z
  local dw = other.w - self.w
  return (dx*dx + dy*dy + dz*dz + dw*dw)^.5
end

-- square distance between two vectors
function Vector4:square_distance_to(other)
  local dx = other.x - self.x
  local dy = other.y - self.y
  local dz = other.z - self.z
  local dw = other.w - self.w
  return dx*dx + dy*dy + dz*dz + dw*dw
end

-- normalized version of the vector
function Vector4.normalized(a)
  local length = a:length()
  if length == 0 then return a end
  return new(a.x/length, a.y/length, a.z/length, a.w/length)
end

-- normalizes the vector
function Vector4:to_normalized()
  local length = self:length()
  if length == 0 then return self end
  return self:div(length)
end

-- angle between two vectors (in radians)
function Vector4.angle_between(a, b)
  return math.acos(a:dot(b)/(a:length()*b:length()))
end

function Vector4:to_abs()
  self.x = math.abs(self.x)
  self.y = math.abs(self.y)
  self.z = math.abs(self.z)
  self.w = math.abs(self.w)
  return self
end

local tmp = {}
function Vector4.send_to(a, shader, id, scale_factor)
  scale_factor = scale_factor or 1
  tmp[1], tmp[2], tmp[3], tmp[4] = a.x/scale_factor, a.y/scale_factor, a.z/scale_factor, a.w/scale_factor
  shader:send(id, tmp)
end

ffi.metatype("Vector4", Vector4)

-- common vectors

Vector4.ZERO = new(0, 0, 0, 0)
Vector4.ONE  = new(1, 1, 1, 1)

Vector4.X = new(1, 0, 0, 0)
Vector4.Y = new(0, 1, 0, 0)
Vector4.Z = new(0, 0, 1, 0)
Vector4.W = new(0, 0, 0, 1)

return Vector4
