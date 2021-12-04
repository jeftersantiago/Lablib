# ===============================
# Author: Jefter Santiago
# User: jefter66
# URL: https://github.com/jefter66
#
# Método dos mínimos quadrados
#
# =============================

using Statistics
using Printf

function angularCoef(x::AbstractArray,y::AbstractArray)::AbstractFloat
    n = d = 0;
    i = 1;
    while i in 1:length(x)
       n+=y[i]*(x[i]-Statistics.mean(x))
       d+=(x[i]-Statistics.mean(x))^2
       i+=1
     end
    return n/d
  end

# Δa - uncertanty for the angular coeficient
# Δa = Δy/√Σ(x_i - Statistics.mean(x))²
function angularUncert(x::AbstractArray,yDispersion::AbstractFloat)::AbstractFloat
    d = 0;
    i = 1;
    while i in 1:length(x)
        d+=(x[i] - Statistics.mean(x))^2
        i+=1
     end
    return yDispersion/sqrt(d)
  end
# Δb -> coef. linear
function linearUncert(x::AbstractArray,yUncert::AbstractFloat)::AbstractFloat
    i=1;
    n=0;
    d=0;
    while i in 1:length(x)
       n+=(x[i])^2
       d+=(x[i] - Statistics.mean(x))^2
       i+=1
       end
    d=d*length(x)
    return sqrt(n/d)*yUncert
end

# Δy
# for the lists x and y, the size is equal
function averageDispersion(x::AbstractArray,y::AbstractArray,a::AbstractFloat,b::AbstractFloat)::AbstractFloat
    i=1;
    n=0;
    while i in 1:length(x)
      n+=(a*x[i]+b-y[i])^2
      i+=1
    end
     n = n/(length(x)-2)
     return sqrt(n)
 end

# b = ̅y - a ⋅ ̅x
function linearCoef(y::AbstractArray, x::AbstractArray,a::AbstractFloat)::AbstractFloat
    return Statistics.mean(y) - a*Statistics.mean(x)
end

function leastSquares(x::AbstractArray,y::AbstractArray)

    angCoef=angularCoef(x,y)
    linCoef=linearCoef(y,x,angCoef)
    linCoefUncert=averageDispersion(x,y,angCoef,linCoef)
    angCoefUncert=angularUncert(x,linCoefUncert)

    print("\n-----------------------")
    print("\nMétodo dos Minimos Quadrados\n")

    @printf(" Média de x=%.5f \n", Statistics.mean(x))
    @printf(" Média de y=%.5f \n", Statistics.mean(y))

    @printf("(α ± Δα):  %.5f ± %.5f \n", angCoef,angCoefUncert)
    @printf("(b ± Δb):  %.5f ± %.5f \n", linCoef,linCoefUncert)
    print("-----------------------\n")
end
