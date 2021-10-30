using Lablib
using Test

@testset "Lablib.jl" begin
    leastSquares([3,2,1,2,3],[2,2,3,1,3])
    deviation([3,2,1,3,32,3,5,1])
end
