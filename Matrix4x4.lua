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

local ffi = assert(require "ffi", "Matrix4x4 requires ffi enabled to work.")

local path = (...)
local subpath = path:sub("^(.-)[^.]$")

local Vector3 = require (subpath.."Vector3")
local Vector4 = require (subpath.."Vector4")

ffi.cdef[[
typedef struct {
  double _11, _12, _13, _14;
  double _21, _22, _23, _24;
  double _31, _32, _33, _34;
  double _41, _42, _43, _44;
} Matrix4x4;
]]
local new = ffi.typeof("Matrix4x4")

local Matrix4x4 = {}
Matrix4x4.__index = Matrix4x4

function Matrix4x4.__tostring(m)
  return ("[%.2f, %.2f, %.2f, %.2f; %.2f, %.2f, %.2f, %.2f; %.2f, %.2f, %.2f, %.2f; %.2f, %.2f, %.2f, %.2f;]")
  : format(m._11, m._12, m._13, m._14, m._21, m._22, m._23, m._24, m._31, m._32, m._33, m._34, m._41, m._42, m._43, m._44)
end

function Matrix4x4.serialize(m, spacing)
  spacing = spacing or ""
  return ([[Matrix4x4(
%s  %s, %s, %s, %s,
%s  %s, %s, %s, %s,
%s  %s, %s, %s, %s,
%s  %s, %s, %s, %s
%s)]])
  : format(
      spacing, m._11, m._12, m._13, m._14,
      spacing, m._21, m._22, m._23, m._24,
      spacing, m._31, m._32, m._33, m._34,
      spacing, m._41, m._42, m._43, m._44,
      spacing)
end

setmetatable(Matrix4x4, {
  __call = function (_,
      m11, m12, m13, m14,
      m21, m22, m23, m24,
      m31, m32, m33, m34,
      m41, m42, m43, m44)
    return new(
      m11, m12, m13, m14,
      m21, m22, m23, m24,
      m31, m32, m33, m34,
      m41, m42, m43, m44)
  end
})

function Matrix4x4.is(m)
  return ffi.istype("Matrix4x4", m)
end

function Matrix4x4.copy(m)
  return new(m)
end

function Matrix4x4.new_identity()
  return new(
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  )
end

function Matrix4x4.is_Matrix4x4(m)
  return ffi.istype("Matrix4x4", m)
end

function Matrix4x4.to_identity(m)
  m._11, m._12, m._13, m._14 = 1, 0, 0, 0
  m._21, m._22, m._23, m._24 = 0, 1, 0, 0
  m._31, m._32, m._33, m._34 = 0, 0, 1, 0
  m._41, m._42, m._43, m._44 = 0, 0, 0, 1
  return m
end

function Matrix4x4.mul_mat4x4(m, n)
  local m11, m12, m13, m14 = m._11, m._12, m._13, m._14
  local m21, m22, m23, m24 = m._21, m._22, m._23, m._24
  local m31, m32, m33, m34 = m._31, m._32, m._33, m._34
  local m41, m42, m43, m44 = m._41, m._42, m._43, m._44

  local n11, n12, n13, n14 = n._11, n._12, n._13, n._14
  local n21, n22, n23, n24 = n._21, n._22, n._23, n._24
  local n31, n32, n33, n34 = n._31, n._32, n._33, n._34
  local n41, n42, n43, n44 = n._41, n._42, n._43, n._44

  m._11 = m11*n11 + m12*n21 + m13*n31 + m14*n41
	m._12 = m11*n12 + m12*n22 + m13*n32 + m14*n42
	m._13 = m11*n13 + m12*n23 + m13*n33 + m14*n43
	m._14 = m11*n14 + m12*n24 + m13*n34 + m14*n44
  m._21 = m21*n11 + m22*n21 + m23*n31 + m24*n41
  m._22 = m21*n12 + m22*n22 + m23*n32 + m24*n42
	m._23 = m21*n13 + m22*n23 + m23*n33 + m24*n43
	m._24 = m21*n14 + m22*n24 + m23*n34 + m24*n44
	m._31 = m31*n11 + m32*n21 + m33*n31 + m34*n41
	m._32 = m31*n12 + m32*n22 + m33*n32 + m34*n42
	m._33 = m31*n13 + m32*n23 + m33*n33 + m34*n43
	m._34 = m31*n14 + m32*n24 + m33*n34 + m34*n44
	m._41 = m41*n11 + m42*n21 + m43*n31 + m44*n41
	m._42 = m41*n12 + m42*n22 + m43*n32 + m44*n42
	m._43 = m41*n13 + m42*n23 + m43*n33 + m44*n43
  m._44 = m41*n14 + m42*n24 + m43*n34 + m44*n44

  return m
end

function Matrix4x4.mul_mat4x4_out(m, n, out)
  local m11, m12, m13, m14 = m._11, m._12, m._13, m._14
  local m21, m22, m23, m24 = m._21, m._22, m._23, m._24
  local m31, m32, m33, m34 = m._31, m._32, m._33, m._34
  local m41, m42, m43, m44 = m._41, m._42, m._43, m._44

  local n11, n12, n13, n14 = n._11, n._12, n._13, n._14
  local n21, n22, n23, n24 = n._21, n._22, n._23, n._24
  local n31, n32, n33, n34 = n._31, n._32, n._33, n._34
  local n41, n42, n43, n44 = n._41, n._42, n._43, n._44

  out._11 = m11*n11 + m12*n21 + m13*n31 + m14*n41
	out._12 = m11*n12 + m12*n22 + m13*n32 + m14*n42
	out._13 = m11*n13 + m12*n23 + m13*n33 + m14*n43
	out._14 = m11*n14 + m12*n24 + m13*n34 + m14*n44
  out._21 = m21*n11 + m22*n21 + m23*n31 + m24*n41
  out._22 = m21*n12 + m22*n22 + m23*n32 + m24*n42
	out._23 = m21*n13 + m22*n23 + m23*n33 + m24*n43
	out._24 = m21*n14 + m22*n24 + m23*n34 + m24*n44
	out._31 = m31*n11 + m32*n21 + m33*n31 + m34*n41
	out._32 = m31*n12 + m32*n22 + m33*n32 + m34*n42
	out._33 = m31*n13 + m32*n23 + m33*n33 + m34*n43
	out._34 = m31*n14 + m32*n24 + m33*n34 + m34*n44
	out._41 = m41*n11 + m42*n21 + m43*n31 + m44*n41
	out._42 = m41*n12 + m42*n22 + m43*n32 + m44*n42
	out._43 = m41*n13 + m42*n23 + m43*n33 + m44*n43
  out._44 = m41*n14 + m42*n24 + m43*n34 + m44*n44

  return out
end

function Matrix4x4.mul_vec3(m, v)
  local v1, v2, v3 = v.x, v.y, v.z

  return Vector3(
    m._11*v1 + m._12*v2 + m._13*v3 + m._14,
	  m._21*v1 + m._22*v2 + m._23*v3 + m._24,
	  m._31*v1 + m._32*v2 + m._33*v3 + m._34)
end

function Matrix4x4.mul_vec4(m, v)
  local v1, v2, v3, v4 = v.x, v.y, v.z, v.w

  return Vector4(
    m._11*v1 + m._12*v2 + m._13*v3 + m._14*v4,
	  m._21*v1 + m._22*v2 + m._23*v3 + m._24*v4,
	  m._31*v1 + m._32*v2 + m._33*v3 + m._34*v4,
	  m._41*v1 + m._42*v2 + m._43*v3 + m._44*v4)
end

function Matrix4x4.mul_vec4_out(m, v, out)
  local v1, v2, v3, v4 = v.x, v.y, v.z, v.w

  out.x = m._11*v1 + m._12*v2 + m._13*v3 + m._14*v4
	out.y = m._21*v1 + m._22*v2 + m._23*v3 + m._24*v4
	out.z = m._31*v1 + m._32*v2 + m._33*v3 + m._34*v4
  out.w = m._41*v1 + m._42*v2 + m._43*v3 + m._44*v4

  return out
end

function Matrix4x4.translate(m, tx, ty, tz)
  m._14 = m._11*tx + m._12*ty + m._13*tz + m._14
  m._24 = m._21*tx + m._22*ty + m._23*tz + m._24
  m._34 = m._31*tx + m._32*ty + m._33*tz + m._34
  m._44 = m._41*tx + m._42*ty + m._43*tz + m._44
  return m
end

function Matrix4x4.translate_vec(m, t)
  return Matrix4x4.translate(m, t.x, t.y, t.z)
end

function Matrix4x4.scale(m, sx, sy, sz)
  sy = sy or sx
  sz = sz or sy
  m._11, m._12, m._13 = m._11*sx, m._12*sy, m._13*sz
  m._21, m._22, m._24 = m._21*sx, m._22*sy, m._24*sz
  m._31, m._32, m._34 = m._31*sx, m._32*sy, m._34*sz
  m._41, m._42, m._43 = m._41*sx, m._42*sy, m._43*sz
  return m
end

function Matrix4x4.scale_vec(m, s)
  return Matrix4x4.scale(m, s.x, s.y, s.z)
end

function Matrix4x4.shear(m, xy, xz, yx, yz, zx, zy)
  local m11, m12, m13 = m._11, m._12, m._13
  local m21, m22, m23 = m._21, m._22, m._23
  local m31, m32, m33 = m._31, m._32, m._33
  local m41, m42, m43 = m._41, m._42, m._43

  m._11, m._12, m._13 = m11 + m12*yx + m13*zx, m11*xy + m12 + m13*zy, m11*xz + m12*yz + m13
  m._21, m._22, m._23 = m21 + m22*yx + m23*zx, m21*xy + m22 + m23*zy, m21*xz + m22*yz + m23
  m._31, m._32, m._33 = m31 + m32*yx + m33*zx, m31*xy + m32 + m33*zy, m31*xz + m32*yz + m33
  m._41, m._42, m._43 = m41 + m42*yx + m43*zx, m41*xy + m42 + m43*zy, m41*xz + m42*yz + m43

  return m
end

function Matrix4x4.rotateX(m, angleX)
  local m12, m13 = m._12, m._13
  local m22, m23 = m._22, m._23
  local m32, m33 = m._32, m._33
  local m42, m43 = m._42, m._43

  local c, s = math.cos(angleX), math.sin(angleX)

  m._12, m._13 = c*m12 + s*m13, c*m13 - s*m12
  m._22, m._23 = c*m22 + s*m23, c*m23 - s*m22
  m._32, m._33 = c*m32 + s*m33, c*m33 - s*m32
  m._42, m._43 = c*m42 + s*m43, c*m43 - s*m42

  return m
end

function Matrix4x4.rotateY(m, angleY)
  local m11, m13 = m._11, m._13
  local m21, m23 = m._21, m._23
  local m31, m33 = m._31, m._33
  local m41, m43 = m._41, m._43

  local c, s = math.cos(angleY), math.sin(angleY)

  m._11, m._13 = c*m11 - s*m13, c*m13 + s*m11
  m._21, m._23 = c*m21 - s*m23, c*m23 + s*m21
  m._31, m._33 = c*m31 - s*m33, c*m33 + s*m31
  m._41, m._43 = c*m41 - s*m43, c*m43 + s*m41

  return m
end

function Matrix4x4.rotateZ(m, angleZ)
  local m11, m12 = m._11, m._12
  local m21, m22 = m._21, m._22
  local m31, m32 = m._31, m._32
  local m41, m42 = m._41, m._42

  local c, s = math.cos(angleZ), math.sin(angleZ)

  m._11, m._12 = c*m11 + s*m12, c*m12 - s*m11
  m._21, m._22 = c*m21 + s*m22, c*m22 - s*m21
  m._31, m._32 = c*m31 + s*m32, c*m32 - s*m31
  m._41, m._42 = c*m41 + s*m42, c*m42 - s*m41

  return m
end

function Matrix4x4:rotate_vec(v)
  return self
  : rotateX(v.x)
  : rotateY(v.y)
  : rotateZ(v.z)
end

function Matrix4x4.transpose(m)
  --[[]] m._12, m._13, m._14 = --[[]] m._21, m._31, m._41
  m._21, --[[]] m._23, m._24 = m._12, --[[]] m._32, m._42
  m._31, m._32, --[[]] m._34 = m._13, m._23, --[[]] m._43
  m._41, m._42, m._43 --[[]] = m._14, m._24, m._34 --[[]]

  return m
end

function Matrix4x4.inverse(m)
  local m11, m12, m13, m14 = m._11, m._12, m._13, m._14
  local m21, m22, m23, m24 = m._21, m._22, m._23, m._24
  local m31, m32, m33, m34 = m._31, m._32, m._33, m._34
  local m41, m42, m43, m44 = m._41, m._42, m._43, m._44

  local s1 = m11 * m22 - m21 * m12
  local s2 = m11 * m23 - m21 * m13
  local s3 = m11 * m24 - m21 * m14
  local s4 = m12 * m23 - m22 * m13
  local s5 = m12 * m24 - m22 * m14
  local s6 = m13 * m24 - m23 * m14

  local c6 = m33 * m44 - m43 * m34
  local c5 = m32 * m44 - m42 * m34
  local c4 = m32 * m43 - m42 * m33
  local c3 = m31 * m44 - m41 * m34
  local c2 = m31 * m43 - m41 * m33
  local c1 = m31 * m42 - m41 * m32

  local det = (s1*c6 - s2*c5 + s3*c4) + (s4*c3 - s5*c2 + s6*c1)
  assert(det ~= 0, "Cannot calculate inverse of matrix: det == 0")

  local invdet = 1/det

  return new(
    ( m22*c6 - m23*c5 + m24*c4)*invdet,
    (-m12*c6 + m13*c5 - m14*c4)*invdet,
    ( m42*s6 - m43*s5 + m44*s4)*invdet,
    (-m32*s6 + m33*s5 - m34*s4)*invdet,

    (-m21*c6 + m23*c3 - m24*c2)*invdet,
    ( m11*c6 - m13*c3 + m14*c2)*invdet,
    (-m41*s6 + m43*s3 - m44*s2)*invdet,
    ( m31*s6 - m33*s3 + m34*s2)*invdet,

    ( m21*c5 - m22*c3 + m24*c1)*invdet,
    (-m11*c5 + m12*c3 - m14*c1)*invdet,
    ( m41*s5 - m42*s3 + m44*s1)*invdet,
    (-m31*s5 + m32*s3 - m34*s1)*invdet,

    (-m21*c4 + m22*c2 - m23*c1)*invdet,
    ( m11*c4 - m12*c2 + m13*c1)*invdet,
    (-m41*s4 + m42*s2 - m43*s1)*invdet,
    ( m31*s4 - m32*s2 + m33*s1)*invdet)
end

function Matrix4x4.inverse_out(m, out)
  local m11, m12, m13, m14 = m._11, m._12, m._13, m._14
  local m21, m22, m23, m24 = m._21, m._22, m._23, m._24
  local m31, m32, m33, m34 = m._31, m._32, m._33, m._34
  local m41, m42, m43, m44 = m._41, m._42, m._43, m._44

  local s1 = m11 * m22 - m21 * m12
  local s2 = m11 * m23 - m21 * m13
  local s3 = m11 * m24 - m21 * m14
  local s4 = m12 * m23 - m22 * m13
  local s5 = m12 * m24 - m22 * m14
  local s6 = m13 * m24 - m23 * m14

  local c6 = m33 * m44 - m43 * m34
  local c5 = m32 * m44 - m42 * m34
  local c4 = m32 * m43 - m42 * m33
  local c3 = m31 * m44 - m41 * m34
  local c2 = m31 * m43 - m41 * m33
  local c1 = m31 * m42 - m41 * m32

  local det = (s1*c6 - s2*c5 + s3*c4) + (s4*c3 - s5*c2 + s6*c1)
  assert(det ~= 0, "Cannot calculate inverse of matrix: det == 0")

  local invdet = 1/det

  out._11 = ( m22*c6 - m23*c5 + m24*c4)*invdet
  out._12 = (-m12*c6 + m13*c5 - m14*c4)*invdet
  out._13 = ( m42*s6 - m43*s5 + m44*s4)*invdet
  out._14 = (-m32*s6 + m33*s5 - m34*s4)*invdet

  out._21 = (-m21*c6 + m23*c3 - m24*c2)*invdet
  out._22 = ( m11*c6 - m13*c3 + m14*c2)*invdet
  out._23 = (-m41*s6 + m43*s3 - m44*s2)*invdet
  out._24 = ( m31*s6 - m33*s3 + m34*s2)*invdet

  out._31 = ( m21*c5 - m22*c3 + m24*c1)*invdet
  out._32 = (-m11*c5 + m12*c3 - m14*c1)*invdet
  out._33 = ( m41*s5 - m42*s3 + m44*s1)*invdet
  out._34 = (-m31*s5 + m32*s3 - m34*s1)*invdet

  out._41 = (-m21*c4 + m22*c2 - m23*c1)*invdet
  out._42 = ( m11*c4 - m12*c2 + m13*c1)*invdet
  out._43 = (-m41*s4 + m42*s2 - m43*s1)*invdet
  out._44 = ( m31*s4 - m32*s2 + m33*s1)*invdet
  return out
end

function Matrix4x4.__mul(a, b)
  assert(ffi.istype("Matrix4x4", a), "Left-hand side of matrix multiplication must be a matrix.")
	if ffi.istype("Vector3", b) then
    return a:copy():mulv(b)
	elseif ffi.istype("Vector4", b) then
    return a:copy():mulv(b)
	elseif ffi.istype("Matrix4x4", b) then
    return a:copy():mulv(b)
	end
  error("Invalid right-hand side of matrix multiplication. Must be one of: Vector3, Vector4, Matrix4x4")
end

local tmp = {}
function Matrix4x4.send_to(m, shader, id)
  tmp[ 1], tmp[ 2], tmp[ 3], tmp[ 4] = m._11, m._12, m._13, m._14
  tmp[ 5], tmp[ 6], tmp[ 7], tmp[ 8] = m._21, m._22, m._23, m._24
  tmp[ 9], tmp[10], tmp[11], tmp[12] = m._31, m._32, m._33, m._34
  tmp[13], tmp[14], tmp[15], tmp[16] = m._41, m._42, m._43, m._44
  shader:send(id, tmp)
end

ffi.metatype("Matrix4x4", Matrix4x4)

-- common matrices

Matrix4x4.IDENTITY = Matrix4x4:new_identity()

return Matrix4x4
