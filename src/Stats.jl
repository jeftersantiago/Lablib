using Statistics
using Printf

# Δ = Σ|x_i - ̅x|/N
function averageDeviation(x::AbstractArray)::AbstractFloat
	i=1;
	sum=0;
	while i in 1:length(x)
		sum+=abs(x[i] - Statistics.mean(x))
		i+=1
 	end
	return sum/length(x)
end

# σ = √(Σ(x_i-̅x)^2)/(N-1)
function standartDeviation(x::AbstractArray)::AbstractFloat
       sum=0;
       i=1;
       while i in 1:length(x)
         sum+=(x[i] - Statistics.mean(x))^2
         i+=1
       end
    if sum==0
        return 0
    end
    return sqrt(sum/(length(x)-1))
end


function studentDistribution(x,t)
  e = t*(standartDeviation(x)/sqrt(length(x)))
  print(" e = ± ", e)
end


# Calculates both deviations and print the
# mean value for the mesuare ± uncertainty
# ex:    x_m ± σ
function deviation(x::AbstractArray)
    xMean = Statistics.mean(x)
    standDev = standartDeviation(x)
    avgDev = averageDeviation(x)

    print("\n==============================\n")
    print("\n Calculo de desvio padrão e médio \n")
    @printf("(x ± σ): %.5f ± %.5f \n", xMean, standDev)
    @printf("(x ± Δ): %.5f ± %.5f \n", xMean, avgDev)
    print("\n==============================\n")
end
