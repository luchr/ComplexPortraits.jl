"""
  # ComplexPortraits
"""
module ComplexPortraits

using Colors, RecipesBase

"""macro for importing the *huge* set of symbols."""
macro import_huge()
  :(
    using ComplexPortraits: generate_stepfct, generate_sawfct,
                            generate_sawfctx, generate_rectfct,
                            generate_spike,
                            angle_zero_one, brightenRGB,
                            hsv_colors, nist_colors,
                            cs_c,
                            cs_m, cs_e,
                            cs_j,
                            cs_p, cs_q, cs_d,
                            cs_gridReIm_lowsat,
                            cs_gridReIm, cs_gridReIm_logabs, cs_gridReIm_abs,
                            cs_stripes, cs_angle_abs_stripes,
                            cs_useImage,
                            portrait,
                            phaseplot, phaseplot!, PhasePlot
  )
end

"""macro for importing the normal set of symbols."""
macro import_normal()
  :(
    using ComplexPortraits: hsv_colors, nist_colors,
                            cs_c,
                            cs_m, cs_e,
                            cs_j,
                            cs_p, cs_q, cs_d,
                            cs_gridReIm, cs_gridReIm_logabs, cs_gridReIm_abs,
                            cs_stripes, cs_angle_abs_stripes,
                            cs_useImage,
                            portrait,
                            phaseplot, phaseplot!, PhasePlot
  )
end

include("./utils.jl")
include("./schemes.jl")

"""
Generate a 'portrait' of a complex function.

Depending on the point_color argument different color schemes are possible.

z_upperleft and z_lowerright define the rectangle for the portrait
in the complex plane for the function f.

Additional arguments are the number of pixels and the point_color function.

Returns an Matrix with the (pixel-)colors as entries.
"""
function portrait(z_upperleft, z_lowerright, f;
                  no_pixels=(600,600), point_color=cs_j())
  if length(no_pixels) == 1
    no_pixels = (no_pixels[1], no_pixels[1])
  end
  return [
    let z = x + y*1im
      point_color(z, f(z))
    end
    for y in LinRange(imag(z_upperleft), imag(z_lowerright), no_pixels[1]),
        x in LinRange(real(z_upperleft), real(z_lowerright), no_pixels[2])]
end

include("./plotrecipes.jl")

end

# vim:syn=julia:cc=79:fdm=indent:sw=2:ts=2:
