@recipe function plot(points::Array{P}) where P <: Union{Vortex.Blob, Vortex.Point}
    z = Elements.position(points)
    Γ = Elements.circulation.(points)
    marker_z --> Γ
    seriestype --> :scatter
    x := real.(z)
    y := imag.(z)
    ()
end

@recipe function plot(points::Array{P}) where P <: Union{Source.Blob, Source.Point}
    z = Elements.position(points)
    Γ = Elements.circulation.(points)
    marker_z --> Γ
    seriestype --> :scatter
    x := real.(z)
    y := imag.(z)
    ()
end

@recipe function plot(s::Vortex.Sheet)
    z = s.zs
    Γ = Elements.circulation.(s.blobs)
    line_z --> 0.5(Γ[1:end-1] + Γ[2:end])./abs.(diff(z))
    x := real.(z)
    y := imag.(z)
    ()
end

@recipe function plot(p::Plate)
    z = [p.zs[1], p.zs[end]]
    linecolor --> :black
    x := real.(z)
    y := imag.(z)
    ()
end

const VortexSystem = NTuple{N, Union{Element, Tuple, Array{V} where {V <: Element}}} where N
function RecipesBase.RecipesBase.apply_recipe(plotattributes::Dict{Symbol, Any}, sys::VortexSystem)
    series_list = RecipesBase.RecipeData[]
    for s in sys
        append!(series_list, RecipesBase.RecipesBase.apply_recipe(copy(plotattributes), s) )
    end
    series_list
end
