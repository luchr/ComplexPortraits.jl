"""
Colorscheme: phase plot with conformal polar grid
"""
function cs_c(; colormap=hsv_colors(), phaseres=20)
    stepfct = generate_stepfct(length(colormap))
    sawfct1 = generate_sawfct(1.0/phaseres, 0.75, 1.0)
    sawfct2 = generate_sawfct(2*π/phaseres, 0.75, 1.0)

    let cm = RGB.(colormap)
      return function(z, fz)
          anglefz = angle_zero_one(fz)
          absfz = abs(fz)
          factor = sawfct1(anglefz) * (
            absfz == 0.0 ? 0.75 : absfz == Inf ? 1.0 : sawfct2(log(absfz)))
          color = cm[stepfct(anglefz)]
          return brightenRGB(
            RGB(factor*color.r, factor*color.g, factor*color.b), 0.1)
      end
    end
end

"""
Colorscheme: colored phase plot with module jumps
"""
function cs_m(; colormap=hsv_colors(), logabsres=20)
    sawfct = generate_sawfct(2*π/logabsres, 0.7, 1.0)
    stepfct = generate_stepfct(length(colormap))
    let cm = RGB.(colormap)
      return function(z, fz)
        absfz = abs(fz)
        factor = absfz == 0.0 ? 0.7 :
                 absfz == Inf ? 1.0 : sawfct(log(absfz))
        color = cm[stepfct(angle_zero_one(fz))]
        return RGB(factor*color.r, factor*color.g, factor*color.b)
      end
    end
end

"""
Colorscheme: enhanced domain coloring
"""
cs_e(; colormap=hsv_colors(), logabsres=20) = cs_mod_abs_brightness(
    cs_m(colormap=colormap, logabsres=logabsres))

"""
Colorscheme: colored phase plot with specific phase jumps
"""
function cs_j(; colormap=hsv_colors(),
                jumps=collect(LinRange(-π, π, 21))[1:20], a=0.8, b=1.0)
    sawfct = generate_sawfctx(
      angle_zero_one.(exp.(1im .* jumps)); a=a, b=b)
    stepfct = generate_stepfct(length(colormap))
    let cm = RGB.(colormap)
      return function(z, fz)
          angle_fz = angle_zero_one(fz)
          factor = sawfct(angle_fz)
          color = cm[stepfct(angle_fz)]
          return RGB(factor*color.r, factor*color.g, factor*color.b)
      end
    end
end

"""
Colorscheme: proper phase plot
"""
function cs_p(; colormap=hsv_colors())
    stepfct = generate_stepfct(length(colormap))
    let cm = copy(colormap)
      return (z, fz) -> cm[stepfct(angle_zero_one(fz))]
    end
end

"""
Colorscheme: phase plot colored in steps
"""
cs_q(; colormap=hsv_colors(20)) = cs_p(; colormap=colormap)

"""
Colorscheme: standard domain coloring
"""
cs_d(; colormap=hsv_colors()) = cs_mod_abs_brightness(
  cs_p(colormap=colormap))

"""
Colorscheme: for exams; cs_j with NIST colors and more pronounced shadow jumps.
"""
cs_exam(; colormap=nist_colors(), jumps=collect(LinRange(-π, π, 21))[1:20],
          a=0.6, b=1.0) = cs_j(colormap=colormap, jumps=jumps, a=a, b=b)

"""
Colorscheme: Stripes in (real(z), imag(z)) plane

Directions is a vector of complex numbers.
For each such number d in directions the stripes are perpendicular
to (real(d), imag(d)). And abs(d) is the number of stripes per unit
length.
This devides the complex plane in two sets Sd and ℂ\\Sd.

Each z ∊ ℂ has n=length(directions) flags (z ∊ S1, z ∊ S1, ..., z ∊ Sn).
This make 2^n possible flag-combinations. For every combination there
need to be a color in colors.
"""
function cs_stripes(directions, colors)
  let no_dirs = length(directions)
    if 2^no_dirs != length(colors)
      error("for $(no_dirs) directions $(2^no_dirs) colors are needed.")
    end
    rectfct = generate_rectfct(1.0)
    return function(z, fz)
      color_index = 0
      color_pos = 1
      for dir in directions
        color_index += color_pos*Int(rectfct(real(fz*dir)))
        color_pos *= 2
      end
      return colors[1 + color_index]
    end
  end
end

"""
Colorscheme: Stripes in (angle(z), abs(z)) plane

Use `cs_stripes` for (angle(z), abs(z)).
"""
function cs_angle_abs_stripes(directions, colors)
  col_fct = cs_stripes(directions, colors)
  return (z, fz) -> col_fct(z,angle(fz) + 1im*abs(fz))
end

"""
Colorscheme: uniform low-brightness grid lines in real- and imag-part and
             low saturation grid lines in lowsat(abs(fz)).
"""
function cs_gridReIm_lowsat(; reim_a=-9.0, reim_b=0.5, abs_a=-9.0, abs_b=0.8,
                              lowsat=absfz -> log(exp(0.5)*absfz),
                              vcorr=(s,v) -> max(1.0 - s, v))
  sp_reim = generate_spike(a=reim_a, b=reim_b)
  sp_abs = generate_spike(a=abs_a, b=abs_b)
  return function(z, fz)
    absfz = abs(fz)
    h = nist_trafo(4*angle_zero_one(fz))
    s = absfz == 0.0 ? 1.0 : absfz == Inf ? 0.0 : sp_abs(lowsat(absfz))
    v = absfz == 0.0 ? 0.0 :
        absfz == Inf ? 1.0 : min(sp_reim(real(fz)-0.5), sp_reim(imag(fz)-0.5))
    return HSV(h, s, vcorr(s,v))
  end
end


"""
Colorscheme: uniform low-brightness grid lines in real- and imag-part and
             low saturation grid lines in log(abs(fz)).
"""
cs_gridReIm_logabs(; reim_a=-9.0, reim_b=0.5, abs_a=-9.0, abs_b=0.8,
                     vcorr=(s,v) -> max(1.0 - s, v)) = cs_gridReIm_lowsat(
  reim_a=reim_a, reim_b=reim_b, abs_a=abs_a, abs_b=abs_b, vcorr=vcorr,
  lowsat=absfz -> log(exp(0.5)*absfz))

"""
Colorscheme: uniform low-brightness grid lines in real- and imag-part and
             low saturation grid lines in abs(fz).
"""
cs_gridReIm_abs(; reim_a=-9.0, reim_b=0.5, abs_a=-9.0, abs_b=0.8,
                  vcorr=(s,v) -> max(1.0 - s, v)) = cs_gridReIm_lowsat(
  reim_a=reim_a, reim_b=reim_b, abs_a=abs_a, abs_b=abs_b, vcorr=vcorr,
  lowsat=absfz -> absfz+0.5)

"""
Colorscheme: uniform low-brightness grid lines in real- and imag-part.
"""
cs_gridReIm(; reim_a=-9.0, reim_b=0.5) = cs_gridReIm_abs(
  reim_a=reim_a, reim_b=reim_b, abs_a=-Inf, vcorr=(s,v) -> v)


"""
Colorscheme: use the pixels of an image as color source.
"""
function cs_useImage(image;
                      img_upperleft=0.0 + 1.0im, img_lowerright=1.0 + 0.0im,
                      is_hv_periodic=(true, true))
  let (img_height, img_width) = size(image),
      x_left = real(img_upperleft),
      x_width = real(img_lowerright) - x_left,
      y_top = imag(img_upperleft),
      y_height = y_top - imag(img_lowerright),
      epsilon = eps()

      width_fct = generate_stepfct(img_width)
      height_fct = generate_stepfct(img_height)

      return function (z,fz)
        x = (real(fz) - x_left)/x_width
        y = (y_top - imag(fz))/y_height
        if !is_hv_periodic[1]
          x = min(max(0.0, x), 1.0-epsilon)
        end
        if !is_hv_periodic[2]
          y = min(max(0.0, y), 1.0-epsilon)
        end
        return image[height_fct(y), width_fct(x)]
      end
  end
end


# vim:syn=julia:cc=79:fdm=indent:sw=2:ts=2:
