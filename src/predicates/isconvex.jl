# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    isconvex(geometry)

Tells whether or not the `geometry` is convex.
"""
function isconvex end

isconvex(::Point) = true

isconvex(::Segment) = true

isconvex(::Ray) = true

isconvex(::Line) = true

function isconvex(b::BezierCurve)
  if ncontrols(b) ≤ 2
    return true
  else
    ps = controls(b)
    p₁, p₂ = ps[begin], ps[begin + 1]
    for i in (firstindex(ps) + 2):lastindex(ps)
      !iscollinear(p₁, p₂, ps[i]) && return false
    end
  end
  return true
end

isconvex(::Plane) = true

isconvex(::Box) = true

isconvex(::Ball) = true

isconvex(::Sphere) = false

isconvex(::Disk) = true

isconvex(::Circle) = false

isconvex(::Cone) = true

isconvex(::ConeSurface) = false

isconvex(::Cylinder) = true

isconvex(::CylinderSurface) = false

isconvex(::Frustum) = true

isconvex(::Torus) = false

isconvex(::Triangle) = true

isconvex(::Tetrahedron) = true

isconvex(p::Polygon{2}) = Set(vertices(convexhull(p))) == Set(vertices(p))

function isconvex(p::Polyhedron{3})
  # check center of each vertices are in the polyhedron
  v = vertices(p)
  for idx1 = 1:length(v), idx2 = idx1+1:length(v)
    v1 = v[idx1]
    v2 = v[idx2]
    center_point = centroid(Segment(v1,v2))
    if center_point ∉ p
      return false
    end
  end
  return true
end

isconvex(m::Multi{Dim,T}) where {Dim,T} = isapprox(measure(convexhull(m)), measure(m), atol=atol(T))

# --------------
# OPTIMIZATIONS
# --------------

function isconvex(q::Quadrangle{2})
  v = vertices(q)
  d1 = Segment(v[1], v[3])
  d2 = Segment(v[2], v[4])
  intersects(d1, d2)
end

# temporary workaround in 3D
isconvex(p::Polygon{3}) = isconvex(proj2D(p))
