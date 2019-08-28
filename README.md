# ComplexPortraits

[![Travis](https://travis-ci.org/luchr/ComplexPortraits.jl.svg?branch=devel)](https://travis-ci.org/luchr/ComplexPortraits.jl)
[![Coverage Status](https://coveralls.io/repos/github/luchr/ComplexPortraits.jl/badge.svg?branch=devel)](https://coveralls.io/github/luchr/ComplexPortraits.jl?branch=devel)


Domain coloring for complex functions.

## Table of Contents

1. [What are portraits?](#what-are-portraits)
2. [Phase colors and colormaps](#phase-colors-and-colormaps)
3. [Installing the ComplexPortraits package](#installing-the-complexportraits-package)
4. [Using the package](#using-the-package)
5. [Creating, viewing and saving portraits](#creating-viewing-and-saving-portraits)
6. [Examples of color schemes](#examples-of-color-schemes)
   * [cs_grid...](#cs_grid): [cs_gridReIm](#cs_gridreim), [cs_gridReIm_logabs](#cs_gridreim_logabs), [cs_gridReIm_abs](#cs_gridreim_abs)
   * [cs_p, cs_j, cs_d, cs_q](#cs_p-cs_j-cs_d-cs_q): [cs_p](#cs_p), [cs_j](#cs_j), [cs_d](#cs_d), [cs_q](#cs_q)
   * [cs_m, cs_e](#cs_m-cs_e): [cs_m](#cs_m), [cs_e](#cs_e)
   * [cs_c](#cs_c)
   * [cs_useImage](#cs_useimage)
   * [Colorschemes with only a few colors](#colorschemes-with-only-a-few-colors): [cs_stripes](#cs_stripes), [cs_angle_abs_stripes](#cs_angle_abs_stripes)

## What are portraits?

To visualize a function f: ℂ → ℂ these steps are done:

1. Coloring of the codomain/target set: every w ∊ ℂ gets a color, lets call it C(w).
2. To get the color at z ∊ ℂ (where f is defined) one calculates w = f(z) and
3. the color at z is computed using the map C∘f, i.e. the color at the point z is given by the C(f(z)).

Here is an example for f(z) = z².

<p align="center">
<img alt="z^2 example" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/docintro.png" /> 
</p>

For more flexibility in this package the color at z may also depend on z itself: color at z = CS(z, f(z)). Such a function is called *color scheme*.

This process is called [domain coloring](https://en.wikipedia.org/wiki/Domain_coloring).
There are many different ways to color the w-plane. Often the color is primarily determined by the angle/phase of w. In such a situation this is also called a (complex) phase portrait. A lot of properties of f can be directly seen in or deduced from such a phase portrait.

For a lot more details, see the book ["Visual Complex Functions" by Elias Wegert, Birkhäuser, 2012](http://www.mathe.tu-freiberg.de/ana/mitarbeiter/elias-wegert/forschung/publikationen/visual-complex-functions).

## Phase colors and colormaps

Some of the ideas of Elias Wegert's [PhasePlot package/Complex Function Explorer for Matlab](https://www.mathworks.com/matlabcentral/fileexchange/45464-complex-function-explorer) are implemented here for Julia. Especially the following one-lettter-colorschemes are also available in ComplexPortraits: c, d, e, j, m, p, q. Hence a copy of the BSD-licensed Complex Funktion Explorer source code can be found in the [based_on](./based_on/) directory.

Additionally some other color schemes are implemented. Please see the list of examples below.

The basis for many color schemes are the colormaps for the angles/phases. There exist two typical choices (color wheels):

HSV wheel: <img alt="color wheel" align="center" width="200px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/wheel01.png" /> and 
[NIST wheel](https://dlmf.nist.gov/help/vrml/aboutcolor): <img alt="NIST color wheel" align="center" width="200px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/wheel02.png" />


Of course you can define and use your own colormap.

## Installing the ComplexPortraits package

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/luchr/ComplexPortraits.jl", rev="master"))
```

To save diskspace all images are not included in this Julia-Package, but
are saved in [ComplexPortraitsImages](https://github.com/luchr/ComplexPortraitsImages/).

## Using the package

By default this package does not import any names in the global namespace (no namespace pollution). There are two macros if you want to import some names (`import_normal` and `import_huge`):

```julia
using ComplexPortraits
@ComplexPortraits.import_normal
#  or @ComplexPortraits.import_huge
```

## Creating, viewing and saving portraits

The main function is `portrait`:

```julia
function portrait(z_upperleft, z_lowerright, f;
                  no_pixels=(600,600), point_color=cs_j())
```

Two complex numbers are needed: the upper left and lower right corner of the rectangular domain which should be colored. `f` is the complex function. 

The other arguments are optional: With `no_pixels` the size of the output image (number of pixels) can be given. `point_color` is a color scheme function. A color scheme function has the form

```julia
mycolorscheme(z, fz) =  ... # computation of color depending on z and f(z)
```

It takes two scalar complex numbers (typically of type `Complex{Float64}`) and returns a color, see [ColorTypes](https://github.com/JuliaGraphics/ColorTypes.jl).

Please see below for a list of predefined parameterized color schemes. All `cs_foobar(baz)`
functions in the package are function generators, i.e. they use the given parameters
to generate and return a color scheme function. For example:
`cs_e(phaseres=10)` uses the `phaseres` argument to create and return a color scheme
function with the given phase-resolution.

The output of `portrait` is a matrix of color entries (a.k.a. image).

There are many ways to save such an image, e.g. using [FileIO](https://github.com/JuliaIO/FileIO.jl) and [ImageMagick](https://github.com/JuliaIO/ImageMagick.jl):

```julia
using ComplexPortraits
using ImageMagick
using FileIO

img = portrait(-2.0 + 2.0im, 2.0 - 2.0im, z -> z^2)
save(File(format"PNG", "z_squared.png"), img)
```

To directly view such an image in Jupyter, Atom, etc. (or in an extra window)
and/or process the image in other ways, please
see and use the [JuliaImages ecosystem](https://github.com/JuliaImages).

## Examples of color schemes

For all the examples the function `z -> (z-1)/(z*z + z + 1)` is used. It
has two simple poles, one root and one saddle point.

### cs_grid...

For the color schemes in this section the 1-periodic "spike function"
`x -> 1 - exp(a*abs(mod(x,1)-0.5)^b)` with two parameters a and b is
often used as a factor to turn something off (at 0.5 + ℤ):

<img alt="spike function for different a and b" align="center" width="800px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/spike.png" />

#### cs_gridReIm

`cs_gridReIm(; reim_a=-9.0, reim_b=0.5)`

Use Nist-Colors for the phase and use the spike function to
decrease the brightness periodically on a real-imag grid.

`reim_a=-9.0, reim_b=0.5`:

<img alt="cs_gridReIm" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_gridReIm01.png" /> <img alt="cs_gridReIm" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_gridReIm01_id.png" /> 

`reim_a=-9.0, reim_b=0.8`:

<img alt="cs_gridReIm" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_gridReIm02.png" /> <img alt="cs_gridReIm" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_gridReIm02_id.png" /> 

#### cs_gridReIm_logabs

`cs_gridReIm_logabs(; reim_a=-9.0, reim_b=0.5, abs_a=-9.0, abs_b=0.8,
                   vcorr=(s,v) -> max(1.0 - s, v))`

Additional to `cs_gridReIm` use another spike function to
decrease the saturation depending on the log(abs(w)).

An additional function `vcorr` can be used to adjust the
brightness depending on the saturation to control whether the black lines
are "in front of the white lines" or the white lines are in front.

`reim_a=-9.0, reim_b=0.5, abs_a=-9.0, abs_b=0.8`:

<img alt="cs_gridReIm_logabs" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_gridReIm_logabs01.png" /> <img alt="cs_gridReIm_logabs" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_gridReIm_logabs01_id.png" /> 

`reim_a=-9.0, reim_b=0.8, abs_a=-9.0, abs_b=0.9`:

<img alt="cs_gridReIm_logabs" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_gridReIm_logabs02.png" /> <img alt="cs_gridReIm_logabs" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_gridReIm_logabs02_id.png" /> 

#### cs_gridReIm_abs

`cs_gridReIm_abs(; reim_a=-9.0, reim_b=0.5, abs_a=-9.0, abs_b=0.8,
                   vcorr=(s,v) -> max(1.0 - s, v))`

Like `cs_gridReIm_logabs`, but the low saturation lines (white lines)
depend on abs(w).

`reim_a=-9.0, reim_b=0.5, abs_a=-9.0, abs_b=0.8`:

<img alt="cs_gridReIm_abs" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_gridReIm_abs01.png" /> <img alt="cs_gridReIm_abs" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_gridReIm_abs01_id.png" /> 

### cs_p, cs_j, cs_d, cs_q

The following color schemes all use a colormap for the phase, i.e. the phase
is discretized with the colors of the `colormap`-argument.
Use `hsv_colors(color_number=600; saturation=1.0, value=1.0)` for the HSV-colormap and `nist_colors(color_number=600; saturation=1.0, value=1.0)`for the NIST-colormap.


#### cs_p

`cs_p(; colormap=hsv_colors())`

A vanilla phase portrait ("proper").

`cs_p():`

<img alt="cs_p" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_p01.png" /> <img alt="cs_p_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_p01_id.png" /> 

#### cs_j

`cs_j(; colormap=hsv_colors(), jumps=collect(LinRange(-π, π, 21))[1:20], a=0.8, b=1.0)`

This is a `cs_p` with specific phase jumps.

`cs_j()`:

<img alt="cs_j" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_j01.png" /> <img alt="cs_j_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_j01_id.png" /> 

`cs_j(jumps=[60/180*pi, 240/180*pi])`:

<img alt="cs_j" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_j02.png" /> <img alt="cs_j_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_j02_id.png" /> 

#### cs_d

`cs_d(; colormap=hsv_colors())`

This is a `cs_p` with the brightness adapted to the log(abs(fz)).

`cs_d()`:

<img alt="cs_d" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_d01.png" /> <img alt="cs_d_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_d01_id.png" /> 

#### cs_q

`cs_q(; colormap=hsv_colors(20)) = cs_p(; colormap=colormap)`

Same as `cs_p` but with a colormap with only 20 entries.

`cs_q()`:

<img alt="cs_q" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_q01.png" /> <img alt="cs_q_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_q01_id.png" /> 

### cs_m, cs_e

#### cs_m

`cs_m(; colormap=hsv_colors(), logabsres=20)´

Similar to `cs_p` with additional brightness jumps depending on log(abs(fz)).

`cs_m()`:

<img alt="cs_m" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_m01.png" /> <img alt="cs_m_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_m01_id.png" /> 

`cs_m(phaseres=10)`:

<img alt="cs_m" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_m02.png" /> <img alt="cs_m_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_m02_id.png" /> 

#### cs_e

`cs_e(; colormap=hsv_colors(), logabsres=20)`

This is a `cs_m` with brightness changed w.r.t. abs(fz) [near zero and infinity].

`cs_e()`:

<img alt="cs_e" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_e01.png" /> <img alt="cs_e_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_e01_id.png" /> 

`cs_e(logabsres=10)`:

<img alt="cs_e" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_e02.png" /> <img alt="cs_e_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_e02_id.png" /> 

### cs_c

`cs_c(; colormap=hsv_colors(), phaseres=20)`

Phase plot with conformal polar grid.

`cs_c()`:

<img alt="cs_c" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_c01.png" /> <img alt="cs_c_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_c01_id.png" /> 

`cs_e(logabsres=10)`:

<img alt="cs_c" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_c02.png" /> <img alt="cs_c_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_c02_id.png" /> 


### cs_useImage

`cs_useImage(image; img_upperleft=0.0 + 1.0im, img_lowerright=1.0 + 0.0im, is_hv_periodic=(true, true)) `

Here an given `image` is placed in the target complex plane in the rectangle given by `img_upperleft` and `img_lowerright`. Optionally this image can be repeated horinzontal and/or vertical. The colors of the (pixels of the) image are used to colorize portrait.

For this example the following image (`test_img`) is used: <img alt="Portraits exmaple image" align="center" width="200px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/Portraits.png" />

`cs_useImage(test_img; img_upperleft=0.0+0.2im, img_lowerright=0.8+0.0im, is_hv_periodic=(false, true))`

<img alt="cs_useImage" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_useImage01.png" /> <img alt="cs_useImage_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_useImage01_id.png" /> 

`cs_useImage(test_img; img_upperleft=0.0+0.2im, img_lowerright=0.8+0.0im, is_hv_periodic=(true, true))`

<img alt="cs_useImage" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_useImage02.png" /> <img alt="cs_useImage_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_useImage02_id.png" /> 

### Colorschemes with only a few colors

#### cs_stripes

```julia
cs_stripes(directions, colors)
```

Directions is a vector of complex numbers.
For each such number d in directions the stripes are perpendicular
to (real(d), imag(d)). And abs(d) is the number of stripes per unit
length.
This devides the complex plane in two sets Sd and ℂ\\Sd.

Each z ∊ ℂ has n=length(directions) flags (z ∊ S1, z ∊ S1, ..., z ∊ Sn).
This make 2^n possible flag-combinations. For every combination there
need to be a color in colors.


`cs_stripes([5.0 + 0.0im], [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0)]))`

<img alt="cs_stripes" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes01.png" /> <img alt="cs_stripes_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes01_id.png" /> 

```julia
cs_stripes(
  [5.0 + 0.0im, 0.0 + 5.0im], 
  [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0), 
   HSV(0.0, 1.0, 1.0), HSV(240.0, 1.0, 1.0)])
```

<img alt="cs_stripes" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes02.png" /> <img alt="cs_stripes_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes02_id.png" /> 

```julia
cs_stripes(
   exp(-1.0im*pi/4).*[2.0 + 0.0im, 0.0 + 2.0im, 2.0 + 2.0im], 
   [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0),
    HSV(0.0, 1.0, 1.0), HSV(60.0, 1.0, 1.0),
    HSV(120.0, 1.0, 1.0), HSV(180.0, 1.0, 1.0),
    HSV(240.0, 1.0, 1.0), HSV(300.0, 1.0, 1.0)])
```

<img alt="cs_stripes" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes03.png" /> <img alt="cs_stripes_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes03_id.png" /> 

#### cs_angle_abs_stripes

```julia
cs_angle_abs_stripes(directions, colors)
```

Uses `cs_stripes` for (angle(z), abs(z)).

`cs_angle_abs_stripes([5.0 + 0.0im], [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0)])`

<img alt="cs_stripes" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes04.png" /> <img alt="cs_stripes_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes04_id.png" /> 

```julia
cs_angle_abs_stripes( 
  [5.0 + 0.0im, 0.0 + 5.0im],
  [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0),
   HSV(0.0, 1.0, 1.0), HSV(240.0, 1.0, 1.0)])
```

<img alt="cs_stripes" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes05.png" /> <img alt="cs_stripes_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes05_id.png" /> 

```julia
cs_angle_abs_stripes(
  exp(-1.0im*pi/4).*[2.0 + 0.0im, 0.0 + 2.0im, 2.0 + 2.0im], 
  [HSV(0.0, 0.0, 1.0), HSV(0.0, 0.0, 0.0),
   HSV(0.0, 1.0, 1.0), HSV(60.0, 1.0, 1.0),
   HSV(120.0, 1.0, 1.0), HSV(180.0, 1.0, 1.0),
   HSV(240.0, 1.0, 1.0), HSV(300.0, 1.0, 1.0)]))
```

<img alt="cs_stripes" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes06.png" /> <img alt="cs_stripes_id" align="center" width="350px" src="https://github.com/luchr/ComplexPortraitsImages/blob/master/images/cs_stripes06_id.png" /> 
