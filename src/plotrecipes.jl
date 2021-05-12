@userplot PhasePlot
# args:  z_upperleft::Complex, z_lowerright::Complex, f::Function
@recipe function plot_portrait(P::PhasePlot; 
                               no_pixels=(600,600), point_color=cs_j(),
                               no_ticks=7, ticks_sigdigits=2)
  length(no_ticks) == 1 && (no_ticks = (no_ticks, no_ticks))
  z_upperleft, z_lowerright, f = P.args[1:3]            
  img = portrait(z_upperleft, z_lowerright, f;
                 no_pixels=no_pixels, point_color=point_color);

  seriestype := :heatmap
  xticks := (LinRange(0, no_pixels[1], no_ticks[1]), 
             round.(LinRange(imag(z_lowerright), imag(z_upperleft), no_ticks[1]), sigdigits=ticks_sigdigits))
  yticks := (LinRange(0, no_pixels[2], no_ticks[2]), 
             round.(LinRange(real(z_upperleft), real(z_lowerright), no_ticks[2]), sigdigits=ticks_sigdigits))

  img
end

"""
```
phaseplot(z_upperleft, z_lowerright, f)
```
Convinience function, automatically adds ticks and creates a `Plot` object.

Can be used in layouts. Examples:

```
using Plots, ComplexPortraits
@ComplexPortraits.import_huge

phaseplot(-2.0 + 2.0im, 2.0 - 2.0im, z -> z^2)

phaseplot(-2.0 + 2.0im, 2.0 - 2.0im, z -> z^2;
          no_pixels=(600, 600),
          point_color=cs_j(),
          no_ticks=(7, 7),
          ticks_sigdigits=2)
```

Todo: hack colorbar plotattribute to show colorwheel.
"""
phaseplot;

"""
tests:
function crop_to_circle!(A:Array; radius=0, background_color=RGB{Float64}(1.0,1.0,1.0))
    m, n = size(A)
    max_radius = min(m, n) / 2
    center = [m/2, n/2]
    (radius < 0 || radius > max_radius) && cv_error("plot image size too small. ", 
                                                    "Maximum radius = ", max_radius)
    radius == 0 && (radius = max_radius)

    for i in Base.OneTo(m), j in Base.OneTo(n)
        sum(([i, j] .- center).^2) * π > radius && (A[i, j] = background_color)
    end

    return A
end
"""