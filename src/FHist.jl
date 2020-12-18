module FHist

export Hist1D

using StatsBase, RecipesBase
import LinearAlgebra: normalize, normalize!

@inline function pearson_err(n::Real)
    s = sqrt(n+0.25)
    s+0.5, s-0.5
end
@inline function sqrt_err(n::Real)
    s = sqrt(n)
    s,s
end

@inline function _is_uniform_bins(A::AbstractVector{T}) where T<:Real
    diffs = diff(A)
    diff1 = first(diffs)
    all(isapprox.(diff1, diffs; atol = 1e-6)) #hack
end

function _make_error(f, A::Array)
    e_up = similar(A, Float64)
    e_down = similar(e_up)
    @inbounds for i in eachindex(A)
        e_up[i], e_down[i] = f(A[i])
    end
    e_up, e_down
end

function _make_error(A, error_mode::Symbol)
    e_up, e_down = if error_mode == :sqrt
        _make_error(sqrt_err, A)
    elseif error_mode == :pearson
        _make_error(pearson_err, A)
    else
        error("Error mode not recognized")
    end
    e_up, e_down
end


include("./hist1d.jl")
include("./arithmatics.jl")
include("./plot.jl")
end
