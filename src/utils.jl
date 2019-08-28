"""
generate a stepfunction with the following properties:

     nmax      ┌──┐        ┌──┐
               │  │        │  │
               │  │        │  │
               │  │        │  │
     3      ┌──┘  │     ┌──┘  │
            │     │     │     │
            │     │     │     │
            │     │     │     │
     2   ┌──┘     │  ┌──┘     │
         │        │  │        │
         │        │  │        │
         │        │  │        │
     1 ──┘        └──┘        └
       0          1           2
"""
generate_stepfct(nmax) = x -> max(Int(floor(nmax*mod(x, 1))) + 1, 1)

"""
generate sawtooth function with the following properties:

     b          /│        /│        /│
               / │       / │       / │
              /  │      /  │      /  │
             /   │     /   │     /   │
            /    │    /    │    /    │
           /     │   /     │   /     │
          /      │  /      │  /      │
         /       │ /       │ /       │
     a  /        │/        │/        │
       0         dx        2dx      3dx
"""
generate_sawfct(dx, a, b) = x -> a + (b-a)*mod(x/dx, 1)

"""
generate a sawtooth function on [0,1] to [a,b] which has
jump points at the given points in jumps:

     b   //│    /│
       //  │   / │
           │   / │            //
           │  /  │          //
           │  /  │        //
           │ /   │      //
           │ /   │    //
           │/    │  //
     a     │/    │//
       0  j[1]  j[2]           1

"""
function generate_sawfctx(jumps; a=0.0, b=1.0)
    xk = sort(jumps)
    let xk = [Float64(xk[end]-1), Float64.(xk)..., Float64(xk[1]+1)], 
        xk_diff = diff(xk)
      return function(x)
          y = 0.0
          for j = 1:length(xk)-1
              if xk[j] ≤ x < xk[j+1]
                  y += (x - xk[j])/xk_diff[j]
              end
          end
          return a + y*(b-a)
      end
    end
end

"""
generate rectangular impulses of length dx

     1      ┌─────┐     ┌─────┐
            │     │     │     │
            │     │     │     │
            │     │     │     │
            │     │     │     │
            │     │     │     │
            │     │     │     │
            │     │     │     │
     0 ─────┘     └─────┘     └
       0    dx   2dx   3dx

"""
generate_rectfct(dx) = x -> mod(floor(x/dx), 2)

"""
generate 1-periodic downwards "spike".

     1 ─────     ──────
             \\   /
             \\ /
               │
               │
     0         │

"""
generate_spike(; a=-9.0, b=0.5) = x -> 1 - (a == -Inf ? 0.0 : exp(a*abs(mod(x,1)-0.5)^b))

"""
Angle of -z scaled in the interval [0,1]
"""
angle_zero_one(z) = abs(z) == Inf ? 0.0 : (angle(-ComplexF64(z)) + pi)/(2pi)

"""
Generate color_number many colors with equispaced hue-values in [0,360).
"""
hsv_colors(color_number=600; saturation=1.0, value=1.0) = HSV{Float32}.(
    360*(0:color_number-1) ./ color_number, saturation, value)

"""
NIST's piecewise linear phase mapping:
https://dlmf.nist.gov/help/vrml/aboutcolor

q ∈ [0, 4)
Output: Angle deg [0, 360)
"""
nist_trafo(q) = (
    1 ≤ q < 2 ? 2*q - 1  :
    2 ≤ q < 3 ? q + 1    :
    3 ≤ q < 4 ? 2*(q-1)  :
    q) * 60

"""
Generate NIST phase mapping: https://dlmf.nist.gov/help/vrml/aboutcolor
"""
nist_colors(color_number=600; saturation=1.0, value=1.0) = HSV{Float32}.(
    nist_trafo.(4*(0:color_number-1) ./ color_number), saturation, value)

"""
brighten RGB-component.

bright ≥ 0
"""
br_rgb(e, bright) = (1 - bright)*e + bright

"""
darken RGB-component.

bright < 0
"""
dr_rgb(e, bright) = (1 + bright)*e

"""
brighten or darken RBG depending on birght sign.
"""
brightenRGB(rgb, bright) = (
  bright ≥ 0 ?
    RGB(br_rgb(rgb.r, bright), br_rgb(rgb.g, bright), br_rgb(rgb.b, bright))
    :
    RGB(dr_rgb(rgb.r, bright), dr_rgb(rgb.g, bright), dr_rgb(rgb.b, bright)))

"""
Use base_color_func and modify the brightness depending on abs(fz).
"""
function cs_mod_abs_brightness(base_color_func)
    return function(z, fz)
        # Version 1
        absfz = abs(fz)
        logf = log(absfz)
        bright = absfz == 0.0 ? 1.0 :
                 absfz == Inf ? 1.0 :
                 logf ≥ 0 ? (1 - (1/(1+logf)))^2  : -(1 - (1/(1-logf)))^2
        # Version 2
        # bright = (3.2f0/pi)*atan(Float32(abs(fz))) - 0.8f0
        return brightenRGB(RGB(base_color_func(z, fz)), bright)
    end
end


# vim:syn=julia:cc=79:fdm=indent:sw=2:ts=2:
