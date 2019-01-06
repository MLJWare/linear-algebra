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

local ffi = assert(require "ffi", "Vector2 requires ffi enabled to work.")

ffi.cdef[=[
typedef struct {
  double x, y;
} Vector2;
]=]
local new = ffi.typeof("Vector2")

local Vector2 = {}
Vector2.__index = Vector2
function Vector2.__tostring(a)
  return ("(%.2f, %.2f)"):format(a.x, a.y)
end

function Vector2.serialize(a)
  return ("Vector2(%.2f, %.2f)"):format(a.x, a.y)
end

setmetatable(Vector2, {
  __call = function (_, x, y)
    x = x or 0
    y = y or x
    return new(x, y)
  end;
})

function Vector2.is(a)
  return ffi.istype("Vector2", a)
end

function Vector2.copy(a)
  return new (a)
end

function Vector2:setn(x, y)
  self.x = x
  self.y = y
  return self
end

function Vector2.setv(a, b)
  a.x = b.x
  a.y = b.y
  return a
end

function Vector2.__eq(a, b)
  local a_is_vec2 = Vector2.is(a)
  local b_is_vec2 = Vector2.is(b)

  local a_is_num  = type(a) == "number"
  local b_is_num  = type(b) == "number"

  if a_is_vec2 and b_is_num then
    return a.x == b
       and a.y == b
  elseif a_is_num and b_is_vec2 then
    return a   == b.x
       and a   == b.y
  elseif a_is_vec2 and b_is_vec2 then
    return a.x == b.x
       and a.y == b.y
  else
    return false
  end
end
function Vector2.__le(a, b)
  local a_is_vec2 = Vector2.is(a)
  local b_is_vec2 = Vector2.is(b)

  local a_is_num  = type(a) == "number"
  local b_is_num  = type(b) == "number"

  if a_is_vec2 and b_is_num then
    return a.x <= b
       and a.y <= b
  elseif a_is_num and b_is_vec2 then
    return a   <= b.x
       and a   <= b.y
  elseif a_is_vec2 and b_is_vec2 then
    return a.x <= b.x
       and a.y <= b.y
  else
    return false
  end
end
function Vector2.__lt(a, b)
  local a_is_vec2 = Vector2.is(a)
  local b_is_vec2 = Vector2.is(b)

  local a_is_num  = type(a) == "number"
  local b_is_num  = type(b) == "number"

  if a_is_vec2 and b_is_num then
    return a.x < b
       and a.y < b
  elseif a_is_num and b_is_vec2 then
    return a   < b.x
       and a   < b.y
  elseif a_is_vec2 and b_is_vec2 then
    return a.x < b.x
       and a.y < b.y
  else
    return false
  end
end
-- scalar/vector addition
function Vector2.__add(a, b)
  if type(a) == "number" then
    return new(a + b.x, a + b.y)
  elseif type(b) == "number" then
    return new(a.x + b, a.y + b)
  else
    return new(a.x + b.x, a.y + b.y)
  end
end

function Vector2:addn(x, y)
  y = y or x
  self.x = self.x + x
  self.y = self.y + y
  return self
end

function Vector2:addv(b)
  self.x = self.x + b.x
  self.y = self.y + b.y
  return self
end

-- negation
function Vector2.__unm(a)
  return new(-a.x, -a.y)
end

function Vector2.negate(a)
  a.x = -a.x
  a.y = -a.y
  return a
end

-- scalar/vector subtraction
function Vector2.__sub(a, b)
  if type(a) == "number" then
    return new(a - b.x, a - b.y)
  elseif type(b) == "number" then
    return new(a.x - b, a.y - b)
  else
    return new(a.x - b.x, a.y - b.y)
  end
end

function Vector2:subn(x, y)
  y = y or x
  self.x = self.x - x
  self.y = self.y - y
  return self
end

function Vector2:subv(b)
  self.x = self.x - b.x
  self.y = self.y - b.y
  return self
end

-- scalar or element-wise division
function Vector2.__div(a, b)
  if type(a) == "number" then
    return new(a / b.x, a / b.y)
  elseif type(b) == "number" then
    return new(a.x / b, a.y / b)
  else
    return new(a.x / b.x, a.y / b.y)
  end
end

function Vector2:divn(x, y)
  y = y or x
  self.x = self.x / x
  self.y = self.y / y
  return self
end

function Vector2:divv(b)
  self.x = self.x / b.x
  self.y = self.y / b.y
  return self
end

-- scalar or element-wise multiplication
function Vector2.__mul(a, b)
  if type(a) == "number" then
    return new(a * b.x, a * b.y)
  elseif type(b) == "number" then
    return new(a.x * b, a.y * b)
  else
    return new(a.x * b.x, a.y * b.y)
  end
end

function Vector2:muln(x, y)
  y = y or x
  self.x = self.x * x
  self.y = self.y * y
  return self
end

function Vector2:mulv(b)
  self.x = self.x * b.x
  self.y = self.y * b.y
  return self
end

-- sum of the vectors components
function Vector2.sum(a)
  return a.x + a.y
end

-- dot product of two vectors
function Vector2.dot(a, b)
  return a.x * b.x + a.y * b.y
end


-- length (magnitude) of the vector
function Vector2:length()
  local x, y = self.x, self.y
  return (x*x + y*y)^.5
end

-- square length (square magnitude) of the vector
function Vector2:square_length()
  local x, y = self.x, self.y
  return x*x + y*y
end

-- distance between two vectors
function Vector2:distance_to(other)
  local dx = other.x - self.x
  local dy = other.y - self.y
  return (dx*dx + dy*dy)^.5
end

-- square distance between two vectors
function Vector2:square_distance_to(other)
  local dx = other.x - self.x
  local dy = other.y - self.y
  return dx*dx + dy*dy
end

-- normalized version of the vector
function Vector2.normalized(a)
  local length = a:length()
  if length == 0 then return a end
  return new(a.x/length, a.y/length)
end

-- normalizes the vector
function Vector2:to_normalized()
  local length = self:length()
  if length == 0 then return self end
  return self:div(length)
end

-- angle between two vectors (in radians)
function Vector2.angle_between(a, b)
  return math.acos(a:dot(b)/(a:length()*b:length()))
end

function Vector2:to_abs()
  self.x = math.abs(self.x)
  self.y = math.abs(self.y)
  return self
end

local tmp = {}
function Vector2.send_to(a, shader, id, scale_factor)
  scale_factor = scale_factor or 1
  tmp[1], tmp[2] = a.x/scale_factor, a.y/scale_factor
  shader:send(id, tmp)
end

ffi.metatype("Vector2", Vector2)

-- common vectors

Vector2.ZERO = new(0, 0)
Vector2.ONE  = new(1, 1)

Vector2.X = new(1, 0)
Vector2.Y = new(0, 1)

return Vector2
