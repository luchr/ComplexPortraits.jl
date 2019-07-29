# Creating the images that are used in the
# Readme/documentation.

# ImageMagick, together with FileIO is used to save the Images
using ComplexPortraits
using ImageMagick
using FileIO

using Colors

@ComplexPortraits.import_normal

function save_image(name, img)
  name = joinpath("images", name * ".png")
  save(File(format"PNG", name), img)
end

docfct(z) = (z-1)/(z*z + z +1)
docid(z) = z

function doc_portrait(name; kwargs...)
  img = portrait(
    -2.0 + 2.0im, 2.0 - 2.0im, docfct; kwargs..., no_pixels=(800,800))
  save_image(name, img)
  img = portrait(
    -2.0 + 2.0im, 2.0 - 2.0im, docid; kwargs..., no_pixels=(800,800))
  save_image(name * "_id", img)
  return nothing
end

function cs_fade_out(base_color_func)
  return function(z, fz)
    color = HSV(base_color_func(z,fz))
    absz = abs(z)
    return HSV(color.h,
      absz ≤ 1.5 ? color.s : color.s*max(1-2*(absz-1.5), 0.0),
      absz ≤ 1.75 ? color.v : min(1.0, color.v + 2*(absz-1.75)))
  end
end

if true

cs_intro = cs_fade_out(cs_j(colormap=nist_colors()))
save_image("intro01",
  portrait(-2.0 + 2.0im, 2.0 - 2.0im, z -> z; 
  no_pixels=300, point_color=cs_intro))
save_image("intro02",
  portrait(-2.0 + 2.0im, 2.0 - 2.0im, z -> z^2;
  no_pixels=300, point_color=cs_intro))

save_image("wheel01",
  portrait(-2.0 + 2.0im, 2.0 - 2.0im, z -> z; 
  no_pixels=300, point_color=cs_fade_out(cs_p())))

save_image("wheel02",
  portrait(-2.0 + 2.0im, 2.0 - 2.0im, z -> z; 
  no_pixels=300, point_color=cs_fade_out(cs_p(colormap=nist_colors()))))

doc_portrait("cs_c01", point_color=cs_c())
doc_portrait("cs_c02", point_color=cs_c(phaseres=10))

doc_portrait("cs_d01", point_color=cs_d())

doc_portrait("cs_e01", point_color=cs_e())
doc_portrait("cs_e02", point_color=cs_e(logabsres=10))

doc_portrait("cs_j01", point_color=cs_j())
doc_portrait("cs_j02", point_color=cs_j(jumps=[60/180*pi, 240/180*pi]))

doc_portrait("cs_m01", point_color=cs_m())
doc_portrait("cs_m02", point_color=cs_m(logabsres=10))

doc_portrait("cs_p01", point_color=cs_p())

doc_portrait("cs_q01", point_color=cs_q())

doc_portrait("cs_gridReIm01", point_color=cs_gridReIm())
doc_portrait("cs_gridReIm02", point_color=cs_gridReIm(reim_b=0.8))

doc_portrait("cs_gridReIm_logabs01", 
  point_color=cs_gridReIm_logabs())
doc_portrait("cs_gridReIm_logabs02", 
  point_color=cs_gridReIm_logabs(abs_b=0.9, reim_b=0.8))

doc_portrait("cs_gridReIm_abs01", point_color=cs_gridReIm_abs())

test_img = load("./images/Portraits.png")

doc_portrait("cs_useImage01",
  point_color=cs_useImage(
    test_img; 
    img_upperleft=0.0 + 0.20im,
    img_lowerright=0.80 + 0.0im,
    is_hv_periodic=(false, true)
    ))

doc_portrait("cs_useImage02",
  point_color=cs_useImage(
    test_img; 
    img_upperleft=0.0 + 0.20im,
    img_lowerright=0.80 + 0.0im,
    is_hv_periodic=(true, true)
    ))

end

doc_portrait("cs_stripes01",
  point_color=cs_stripes( 
   [5.0 + 0.0im],
   [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0)]))

doc_portrait("cs_stripes02",
  point_color=cs_stripes( 
   [5.0 + 0.0im, 0.0 + 5.0im],
   [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0),
    HSV(0.0, 1.0, 1.0), HSV(240.0, 1.0, 1.0)]))

doc_portrait("cs_stripes03",
  point_color=cs_stripes(
    exp(-1.0im*pi/4).*[2.0 + 0.0im, 0.0 + 2.0im, 2.0 + 2.0im], 
    [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0),
     HSV(0.0, 1.0, 1.0), HSV(60.0, 1.0, 1.0),
     HSV(120.0, 1.0, 1.0), HSV(180.0, 1.0, 1.0),
     HSV(240.0, 1.0, 1.0), HSV(300.0, 1.0, 1.0)]))


doc_portrait("cs_stripes04",
  point_color=cs_angle_abs_stripes( 
   [5.0 + 0.0im],
   [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0)]))

doc_portrait("cs_stripes05",
  point_color=cs_angle_abs_stripes( 
   [5.0 + 0.0im, 0.0 + 5.0im],
   [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0),
    HSV(0.0, 1.0, 1.0), HSV(240.0, 1.0, 1.0)]))

doc_portrait("cs_stripes06",
  point_color=cs_angle_abs_stripes(
    exp(-1.0im*pi/4).*[2.0 + 0.0im, 0.0 + 2.0im, 2.0 + 2.0im], 
    [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0),
     HSV(0.0, 1.0, 1.0), HSV(60.0, 1.0, 1.0),
     HSV(120.0, 1.0, 1.0), HSV(180.0, 1.0, 1.0),
     HSV(240.0, 1.0, 1.0), HSV(300.0, 1.0, 1.0)]))

# vim:syn=julia:cc=79:fdm=indent:sw=2:ts=2:
