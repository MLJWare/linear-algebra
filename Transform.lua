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

local path = (...)
local subpath = path:sub("^(.-)[^.]$")

local Vector3   = require (subpath.."Vector3")
local Matrix4x4 = require (subpath.."Matrix4x4")

local Transform = {}
Transform.__index = Transform

local function new(position, rotation, scale)
  local self = setmetatable({
    position = position or Vector3(0,0,0);
    rotation = rotation or Vector3(0,0,0);
    scale    = scale    or Vector3(1,1,1);
    _matrix_ = Matrix4x4.new_identity();
  }, Transform)
  return self
end

setmetatable(Transform, {
  __call = function (_, position, rotation, scale)
    return new(position, rotation, scale)
  end
})

function Transform.is(a)
  return getmetatable(a) == Transform
end

function Transform:matrix()
  return self._matrix_
    : to_identity()
    : rotate_vec   (self.rotation)
    : scale_vec    (self.scale)
    : translate_vec(self.position)
end

function Transform:copy()
  return new(self.position:copy(), self.rotation:copy(), self.scale:copy())
end

function Transform:translate(tx, ty, tz)
  self.position:addn(tx, ty, tz)
  return self
end

function Transform:sendTo(shader, id)
  self:matrix():sendTo(shader, id)
end

return Transform
