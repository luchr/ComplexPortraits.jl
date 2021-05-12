using ComplexPortraits
using Colors
using Test

@ComplexPortraits.import_huge

function test_stepfct()
  @testset "stepfct" begin
    @testset "s1" begin
      s1 = generate_stepfct(1)
      @inferred s1(0)
      @inferred s1(0.0)
      @testset for value in (0, 0.0, 0.25, 1.0, 1.25)
        @test s1(value) === 1
      end
    end

    @testset "s2" begin
      s2 = generate_stepfct(2)
      @testset for pair in (
          0 => 1, 0.25 => 1, 0.499 => 1, 0.5 => 2, 0.51 => 2, 0.9 => 2,
          1 => 1, 1.0 => 1)
        @test s2(pair[1]) === pair[2]
      end
    end

    @testset "s3" begin
      s3 = generate_stepfct(4)
      @testset for pair in (
          0 => 1, 0.24 => 1, 0.25 => 2, 0.33 => 2, 0.49 => 2, 0.5 => 3,
          0.51 => 3, 0.74 => 3, 0.75 => 4, 0.76 => 4, 0.99 => 4,
          1 => 1, 1.0 => 1)
        @test s3(pair[1]) === pair[2]
      end
    end
  end
end

function test_sawfct()
  @testset "sawfct" begin
    @testset "s1" begin
      s1 = generate_sawfct(1, 1, 2)
      @inferred s1(0)
      @inferred s1(0.0)
      @testset for pair in (
          0 => 1.0, 0.0 => 1.0,  0.3 => 1.3, 0.5 => 1.5, 0.999 => 1.999,
          1 => 1.0, 1 => 1.0)
        @test s1(pair[1]) === pair[2]
      end
    end

    @testset "s2" begin
      s2 = generate_sawfct(1.5, 10.5, 20.5)
      @inferred s2(0)
      @inferred s2(0.0)
      @testset for pair in (
          0 => 10.5, 1 => 10.5+2/3*10, 1.0 => 10.5+2/3*10, 1.5 => 10.5)
        @test s2(pair[1]) === pair[2]
      end
    end
  end
end

function test_sawfctx()
  @testset "sawfctx" begin
    @testset for sfctx in (
        generate_sawfctx([0.4, 0.5]; a=10, b=20),
        generate_sawfctx([0.4, 0.5]; a=10.0, b=20.0))
      @inferred sfctx(0)
      @inferred sfctx(0.0)
      @testset for pair in (
          0 => 10.0 + 5/9*10, 0.4 => 10.0, 0.45 => 15.0,
          1.0 => 10.0 + 5/9*10)
        @test sfctx(pair[1]) === pair[2]
      end
    end
  end
end

function test_rectfct()
  @testset "rectfct" begin
    @testset for rectfct in (
        generate_rectfct(2),
        generate_rectfct(2.0))
      @inferred rectfct(0)
      @inferred rectfct(0.0)

      @testset for pair in (
          0 => 0.0, 0.5 => 0.0, 1 => 0.0, 1.0 => 0.0,
          2 => 1.0, 2.0 => 1.0, 3 => 1.0, 4.0 => 0.0)
        @test rectfct(pair[1]) === pair[2]
      end
    end
  end
end

function test_angle_zero_one()
  @testset "angle_zo" begin
    @testset for pair in (
        0 => 0.0, 0.0 => 0.0, 1 => 0.0, 1.0 => 0.0, 1.0 +0im => 0.0,
        1im => 0.25, 1.0im => 0.25, -1 => 0.5, -1.0 => 0.5, -1+0im => 0.5,
        -1.0+0im => 0.5, -im => 0.75, 1 -0.0im => 1.0, 1.0 -0im => 1.0,
        Inf => 0.0, 1.0 +Inf*1im => 0.0, -Inf+1im => 0.0)
      @test angle_zero_one(pair[1]) === pair[2]
    end
  end
end

function test_colors()
  @testset "colors" begin
    @testset "hsv" begin
      cols = hsv_colors(4)
      @test cols[1] === HSV{Float32}(0.0f0,1.0f0,1.0f0)
      @test cols[2] === HSV{Float32}(90.0f0,1.0f0,1.0f0)
      @test cols[3] === HSV{Float32}(180.0f0,1.0f0,1.0f0)
      @test cols[4] === HSV{Float32}(270.0f0,1.0f0,1.0f0)

      cols = hsv_colors(4, saturation=.4, value=.5)
      @test cols[1] === HSV{Float32}(0.0f0,0.4f0,0.5f0)
      @test cols[2] === HSV{Float32}(90.0f0,0.4f0,0.5f0)
      @test cols[3] === HSV{Float32}(180.0f0,0.4f0,0.5f0)
      @test cols[4] === HSV{Float32}(270.0f0,0.4f0,0.5f0)
    end

    @testset "nist" begin
      cols = nist_colors(4)
      @test cols[1] === HSV{Float32}(0.0f0,1.0f0,1.0f0)
      @test cols[2] === HSV{Float32}(60.0f0,1.0f0,1.0f0)
      @test cols[3] === HSV{Float32}(180.0f0,1.0f0,1.0f0)
      @test cols[4] === HSV{Float32}(240.0f0,1.0f0,1.0f0)

      cols = nist_colors(4, saturation=.4, value=.5)
      @test cols[1] === HSV{Float32}(0.0f0,0.4f0,0.5f0)
      @test cols[2] === HSV{Float32}(60.0f0,0.4f0,0.5f0)
      @test cols[3] === HSV{Float32}(180.0f0,0.4f0,0.5f0)
      @test cols[4] === HSV{Float32}(240.0f0,0.4f0,0.5f0)
    end

    @testset "brighten" begin
      @test brightenRGB(RGB(0.5, 0.5, 0.5), 0.1)  === RGB(0.55, 0.55, 0.55)
      @test brightenRGB(RGB(0.5, 0.5, 0.5), -0.2)  === RGB(0.4, 0.4, 0.4)
    end
  end
end

function test_cs_xylf()
  b = Gray(0.0)
  w = Gray(1.0)
  @testset "cs_xylf" begin
    @testset "cs_x1" begin
      fct = cs_x()
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in (
          0.0 => b, 0.24 => b, 0.24+5im => b, 0.26-5im => w, Inf+0im => w)
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end

    @testset "cs_x2" begin
      fct = cs_x(realres=10)
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in (
          0.0 => b, 0.49 => b, 0.49+5im => b, 0.51-5im => w, Inf+0im => w)
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end

    @testset "cs_y1" begin
      fct = cs_y()
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in (
          0.0 => b, 0.24im => b, 0.24im+5 => b, 0.26im-5 => w, Inf*im => w)
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end

    @testset "cs_y2" begin
      fct = cs_y(imagres=10)
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in (
          0.0 => b, 0.49im => b, 0.49im+5 => b, 0.51im-5 => w, Inf*im => w)
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end

    @testset "cs_l1" begin
      fct = cs_l()
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in (
        (pi/10-0.1)*1im => w, (pi/10+0.1)*1im => b, Inf*im => w)
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end

    @testset "cs_l2" begin
      fct = cs_l(phaseres=2*pi)
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in (
          0.0 => b, 0.4im => b, 0.6im => w, 1.4im => b, 1.6im => w)
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end

    rgb_w = RGB(1.0, 1.0, 1.0)
    rgb_b = RGB(0.0, 0.0, 1.0)

    @testset "cs_f1" begin
      fct = cs_f()
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in 
          (0.11im => rgb_w, 0.09im => rgb_b, Inf*1im => rgb_b)
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end

    @testset "cs_f2" begin
      fct = cs_f(imagres=2)
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in (
          0.0 => rgb_b, 2.9im => rgb_w, 3.1im => rgb_b)
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end
  end
end

function test_stripes()
  c = (RGB(0.0, 0.0, 0.0), RGB(1.0, 1.0, 1.0),
       RGB(1.0, 0.0, 0.0), RGB(0.0, 1.0, 0.0), 
       RGB(0.0, 0.0, 1.0), RGB(1.0, 1.0, 0.0),
       RGB(1.0, 0.0, 1.0), RGB(0.0, 1.0, 1.0))
  @testset "stripes" begin
    @testset "stripes1" begin
      fct = cs_stripes([1.0 + 0.0im], c[1:2])
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in (0.1 => c[1], 1.1 => c[2])
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end

    @testset "stripes2" begin
      fct = cs_stripes([1.0 + 0.0im, 0.0 + 1.0im], c[1:4])
      @testset for pair in (
          0.1 + 0.1im => c[3], 1.1 + 0.1im => c[4],
          0.1 + 1.1im => c[1], 1.1 + 1.1im => c[2])
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end
  end
end

function test_cs_c()
  @testset "cs_c" begin
    fct = cs_c(phaseres=2)
    @inferred fct(0.0+0im, 0.0+0im)
    @testset for pair in
        (exp(pi)-1e-14 => RGB(0.775, 0.1, 0.1),
         -exp(pi)+1e-14 => RGB(0.1, 0.775, 0.775),
         (1-1e-14)*exp(120/180*pi*1im) => RGB(0.1, 0.925, 0.1),
         (1-1e-14)*exp(-60/180*pi*1im) => RGB(0.925, 0.1, 0.925))
      @test fct(0.0+0im, pair[1]) ≈ pair[2]
    end
  end
end

function test_cs_me()
  @testset "cs_me" begin
    @testset "cs_m" begin
      fct = cs_m(logabsres=2*pi)
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in
          (1-1e-14 => RGB(1.0, 0.0, 0.0),
           1+1e-14 => RGB(0.7, 0.0, 0.0),
           1/exp(1)-1e-14 => RGB(1.0, 0.0, 0.0),
           1/exp(1)+1e-14 => RGB(0.7, 0.0, 0.0))
        @test fct(0.0+0im, pair[1]) ≈ pair[2]
      end
    end

    @testset "cs_e" begin
      fct = cs_e(logabsres=2*pi)
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in
           (1/exp(1)-1e-14 => RGB(0.75, 0.0, 0.0),
           1/exp(1)+1e-14 => RGB(0.525, 0.0, 0.0))
        @test fct(0.0+0im, pair[1]) ≈ pair[2]
      end
    end
  end
end

function test_cs_j()
  @testset "cs_j" begin
    fct = cs_j(jumps=[120/180*pi])
    @inferred fct(0.0+0im, 0.0+0im)
    @testset for pair in
         (exp(1im*(120/180+1e-14)*pi) => RGB(0.0, 0.8, 0.0),
          exp(1im*(120/180-1e-14)*pi) => RGB(0.009999990463256826, 1.0, 0.0))
      @test fct(0.0+0im, pair[1]) ≈ pair[2]
    end
  end
end

function test_cs_pqd()
  @testset "cs_pqd" begin
    @testset "cs_p" begin
      fct = cs_p(colormap=nist_colors())
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in
          (1 => HSV(0f0, 1f0, 1f0), 1im => HSV(6f1, 1f0, 1f0),
           -1.0 => HSV(18f1, 1f0, 1f0), -1.0im => HSV(24f1, 1f0, 1f0),
           exp(45/180*pi*1im) => HSV(3f1, 1f0, 1f0),
           exp(135/180*pi*1im) => HSV(12f1, 1f0, 1f0),
           exp(225/180*pi*1im) => HSV(21f1, 1f0, 1f0),
           exp(315/180*pi*1im) => HSV(30f1, 1f0, 1f0))
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end

    @testset "cs_q" begin
      fct = cs_q()
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in
          (0 => 0f0, 90.5 => 9f1, 180.5 => 18f1, 270.5 => 27f1)
        @test fct(0.0+0im, exp(pair[1]/180*pi*1im)) === HSV(pair[2], 1f0, 1f0)
      end
    end

    @testset "cs_d" begin
      fct = cs_d()
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in
          (1 => RGB(1.0, 0.0, 0.0), exp(1) => RGB(1.0, 0.25, 0.25),
           exp(4) => RGB(1.0, 0.64, 0.64), 1im => RGB(0.5, 1.0, 0.0),
           exp(1)*1im => RGB(0.625, 1.0, 0.25),
           -exp(1)*1im => RGB(0.625, 0.25, 1.0))
        @test fct(0.0+0im, pair[1]) ≈ pair[2]
      end
    end
  end
end

function test_cs_grid()
  @testset "cs_grid" begin
    @testset "cs_gridReIm" begin
      fct = cs_gridReIm()
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in
          (+1.0+0.0im => HSV(0.0, 1.0, 0.0),
           +1.0+1.0im => HSV(30.0, 1.0, 0.0),
           +0.0+1.0im => HSV(60.0, 1.0, 0.0),
           -1.0+1.0im => HSV(120.0, 1.0, 0.0),
           -1.0+0.0im => HSV(180.0, 1.0, 0.0),
           -1.0-1.0im => HSV(210.0, 1.0, 0.0),
           +0.0-1.0im => HSV(240.0, 1.0, 0.0),
           +1.0-1.0im => HSV(300.0, 1.0, 0.0))
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end

    @testset "cs_gridRe_abs" begin
      fct = cs_gridReIm_abs()
      @inferred fct(0.0+0im, 0.0+0im)
      @testset for pair in
          (+1.0+0.0im => HSV(0.0, 0.0, 1.0),
           +0.0+1.0im => HSV(60.0, 0.0, 1.0),
           -1.0+0.0im => HSV(180.0, 0.0, 1.0),
           +0.0-1.0im => HSV(240.0, 0.0, 1.0))
        @test fct(0.0+0im, pair[1]) === pair[2]
      end
    end
  end
end

function test_portrait()
  @testset "portrait" begin
    @inferred portrait(-1.0+1.0im, 1.0-1.0im,
      z -> z, no_pixels=3, point_color=cs_p())
    img = portrait(-1.0+1.0im, 1.0-1.0im,
      z -> z, no_pixels=3, point_color=cs_p())
    @test isa(img, Array)
    @test size(img) === (3,3)
    col(phase) = HSV{Float32}(phase, 1.0f0, 1.0f0)
    @test img == [ col(135) col(90)  col(45) ;
                   col(180) col(0)   col(0)  ;
                   col(225) col(270) col(315) ]
  end
end

test_stepfct()
test_sawfct()
test_sawfctx()
test_rectfct()
test_angle_zero_one()
test_colors()

test_stripes()

test_cs_c()
test_cs_me()
test_cs_j()
test_cs_pqd()
test_cs_grid()

test_portrait()

# vim:syn=julia:cc=79:fdm=indent:sw=2:ts=2:
