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

local ffi = assert(require "ffi", "Vector3 requires ffi enabled to work.")

ffi.cdef[=[
typedef struct {
  double x, y, z;
} Vector3;
]=]
local new = ffi.typeof("Vector3")

local Vector3 = {}
Vector3.__index = Vector3
function Vector3.__tostring(a)
  return ("(%.2f, %.2f, %.2f)"):format(a.x, a.y, a.z)
end

function Vector3.serialize(a)
  return ("Vector3(%.2f, %.2f, %.2f)"):format(a.x, a.y, a.z)
end

setmetatable(Vector3, {
  __call = function (_, x, y, z)
    x = x or 0
    y = y or x
    z = z or y
    return new(x, y, z)
  end;
})

function Vector3.is(a)
  return ffi.istype("Vector3", a)
end

function Vector3.copy(a)
  return new (a)
end

function Vector3:setn(x, y, z)
  self.x = x
  self.y = y
  self.z = z
  return self
end

function Vector3.setv(a, b)
  a.x = b.x
  a.y = b.y
  a.z = b.z
  return a
end

function Vector3.__eq(a, b)
  local a_is_vec3 = Vector3.is(a)
  local b_is_vec3 = Vector3.is(b)

  local a_is_num  = type(a) == "number"
  local b_is_num  = type(b) == "number"

  if a_is_vec3 and b_is_num then
    return a.x == b
       and a.y == b
       and a.z == b
  elseif a_is_num and b_is_vec3 then
    return a   == b.x
       and a   == b.y
       and a   == b.z
  elseif a_is_vec3 and b_is_vec3 then
    return a.x == b.x
       and a.y == b.y
       and a.z == b.z
  else
    return false
  end
end
function Vector3.__le(a, b)
  local a_is_vec3 = Vector3.is(a)
  local b_is_vec3 = Vector3.is(b)

  local a_is_num  = type(a) == "number"
  local b_is_num  = type(b) == "number"

  if a_is_vec3 and b_is_num then
    return a.x <= b
       and a.y <= b
       and a.z <= b
  elseif a_is_num and b_is_vec3 then
    return a   <= b.x
       and a   <= b.y
       and a   <= b.z
  elseif a_is_vec3 and b_is_vec3 then
    return a.x <= b.x
       and a.y <= b.y
       and a.z <= b.z
  else
    return false
  end
end
function Vector3.__lt(a, b)
  local a_is_vec3 = Vector3.is(a)
  local b_is_vec3 = Vector3.is(b)

  local a_is_num  = type(a) == "number"
  local b_is_num  = type(b) == "number"

  if a_is_vec3 and b_is_num then
    return a.x < b
       and a.y < b
       and a.z < b
  elseif a_is_num and b_is_vec3 then
    return a   < b.x
       and a   < b.y
       and a   < b.z
  elseif a_is_vec3 and b_is_vec3 then
    return a.x < b.x
       and a.y < b.y
       and a.z < b.z
  else
    return false
  end
end
-- scalar/vector addition
function Vector3.__add(a, b)
  if type(a) == "number" then
    return new(a + b.x, a + b.y, a + b.z)
  elseif type(b) == "number" then
    return new(a.x + b, a.y + b, a.z + b)
  else
    return new(a.x + b.x, a.y + b.y, a.z + b.z)
  end
end

function Vector3:addn(x, y, z)
  y = y or x
  z = z or y
  self.x = self.x + x
  self.y = self.y + y
  self.z = self.z + z
  return self
end

function Vector3:addv(b)
  self.x = self.x + b.x
  self.y = self.y + b.y
  self.z = self.z + b.z
  return self
end

-- negation
function Vector3.__unm(a)
  return new(-a.x, -a.y, -a.z)
end

function Vector3.negate(a)
  a.x = -a.x
  a.y = -a.y
  a.z = -a.z
  return a
end

-- scalar/vector subtraction
function Vector3.__sub(a, b)
  if type(a) == "number" then
    return new(a - b.x, a - b.y, a - b.z)
  elseif type(b) == "number" then
    return new(a.x - b, a.y - b, a.z - b)
  else
    return new(a.x - b.x, a.y - b.y, a.z - b.z)
  end
end

function Vector3:subn(x, y, z)
  y = y or x
  z = z or y
  self.x = self.x - x
  self.y = self.y - y
  self.z = self.z - z
  return self
end

function Vector3:subv(b)
  self.x = self.x - b.x
  self.y = self.y - b.y
  self.z = self.z - b.z
  return self
end

-- scalar or element-wise division
function Vector3.__div(a, b)
  if type(a) == "number" then
    return new(a / b.x, a / b.y, a / b.z)
  elseif type(b) == "number" then
    return new(a.x / b, a.y / b, a.z / b)
  else
    return new(a.x / b.x, a.y / b.y, a.z / b.z)
  end
end

function Vector3:divn(x, y, z)
  y = y or x
  z = z or y
  self.x = self.x / x
  self.y = self.y / y
  self.z = self.z / z
  return self
end

function Vector3:divv(b)
  self.x = self.x / b.x
  self.y = self.y / b.y
  self.z = self.z / b.z
  return self
end

-- scalar or element-wise multiplication
function Vector3.__mul(a, b)
  if type(a) == "number" then
    return new(a * b.x, a * b.y, a * b.z)
  elseif type(b) == "number" then
    return new(a.x * b, a.y * b, a.z * b)
  else
    return new(a.x * b.x, a.y * b.y, a.z * b.z)
  end
end

function Vector3:muln(x, y, z)
  y = y or x
  z = z or y
  self.x = self.x * x
  self.y = self.y * y
  self.z = self.z * z
  return self
end

function Vector3:mulv(b)
  self.x = self.x * b.x
  self.y = self.y * b.y
  self.z = self.z * b.z
  return self
end

-- sum of the vectors components
function Vector3.sum(a)
  return a.x + a.y + a.z
end

-- dot product of two vectors
function Vector3.dot(a, b)
  return a.x * b.x + a.y * b.y + a.z * b.z
end

-- cross product of two vectors
function Vector3.cross(a, b)
  local a_x, a_y, a_z = a.x, a.y, a.z
  local b_x, b_y, b_z = b.x, b.y, b.z
  return new( a_y*b_z - a_z*b_y
            , a_z*b_x - a_x*b_z
            , a_x*b_y - a_y*b_x)
end
-- length (magnitude) of the vector
function Vector3:length()
  local x, y, z = self.x, self.y, self.z
  return (x*x + y*y + z*z)^.5
end

-- square length (square magnitude) of the vector
function Vector3:square_length()
  local x, y, z = self.x, self.y, self.z
  return x*x + y*y + z*z
end

-- distance between two vectors
function Vector3:distance_to(other)
  local dx = other.x - self.x
  local dy = other.y - self.y
  local dz = other.z - self.z
  return (dx*dx + dy*dy + dz*dz)^.5
end

-- square distance between two vectors
function Vector3:square_distance_to(other)
  local dx = other.x - self.x
  local dy = other.y - self.y
  local dz = other.z - self.z
  return dx*dx + dy*dy + dz*dz
end

-- normalized version of the vector
function Vector3.normalized(a)
  local length = a:length()
  if length == 0 then return a end
  return new(a.x/length, a.y/length, a.z/length)
end

-- normalizes the vector
function Vector3:to_normalized()
  local length = self:length()
  if length == 0 then return self end
  return self:div(length)
end

-- angle between two vectors (in radians)
function Vector3.angle_between(a, b)
  return math.acos(a:dot(b)/(a:length()*b:length()))
end

function Vector3:to_abs()
  self.x = math.abs(self.x)
  self.y = math.abs(self.y)
  self.z = math.abs(self.z)
  return self
end

local tmp = {}
function Vector3.send_to(a, shader, id, scale_factor)
  scale_factor = scale_factor or 1
  tmp[1], tmp[2], tmp[3] = a.x/scale_factor, a.y/scale_factor, a.z/scale_factor
  shader:send(id, tmp)
end

ffi.metatype("Vector3", Vector3)

-- common vectors

Vector3.ZERO = new(0, 0, 0)
Vector3.ONE  = new(1, 1, 1)

Vector3.X = new(1, 0, 0)
Vector3.Y = new(0, 1, 0)
Vector3.Z = new(0, 0, 1)

return Vector3
