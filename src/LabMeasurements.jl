import Base
e = ℯ

"
```Measure(val, unc)```

Objeto que representa as medidas feitas no laboratório e as incertezas associadas.
Por boas práticas, deve-se usar a função ```setMes``` ou o operador ```±``` para
definir um objeto ```Measure```

# Exemplos
```julia-repl
julia> Measure(5, 3)
5 ± 3

julia> 0.7 ± 0.005
0.7 ± 0.005
```
"
mutable struct Measure
    val::Real
    unc::Real
end

## Métodos/operadores construtores, representadoras e comparadores
#funções construtoras
"
    setMes(valor, incerteza)
Constrói um objeto ```Measure```
"
function setMes(val::Real,unc::Real)
    if(unc >= abs(val))
        @warn "O valor da incerteza não pode ser maior que a incerteza!"
        return
    elseif(unc < 0)
        @warn "O valor da incerteza não pode ser negativo!"
        return
    end
    return Measure(val,unc)
end

"
    ±(valor, incerteza)
Operador de construção de ```Measure```. pode ser chamado como ```valor ± incerteza```
"
function ±(val::Real, unc::Real)
    return setMes(val, unc)
end

# Métodos e operadores de comparação e arredondamento

function Base.:(==)(x::Measure, y::Measure)
   return abs(x.val - y.val) < 2(x.unc + y.unc)
end

function Base.:(!=)(x::Measure, y::Measure)
   return abs(x.val - y.val) > 3(x.unc + y.unc)
end


function Base.:round(x::Measure)
    int(n) = trunc(Int64, n)
    orderOfMag(n) = floor(log(10, n))
    x_rounded = setMes(x.val, x.unc)

    if x.unc > 0
        # Deixa apenas o valor significativo da incerteza
        x_rounded.unc = round(x.unc, digits=-int(orderOfMag(x.unc)))
        x_rounded.val = round(x.val, digits=-int(orderOfMag(x_rounded.unc)))
        return x_rounded
    end

    @warn "O valor da incerteza é inválido (negativo ou zero)"
end

# Métodos de representação
function Base.:print(x::Measure)
    x = round(x)
    print(x.val, " ± ", x.unc)
end

function Base.:show(io::IO, x::Measure)
    print(x.val, " ± ", x.unc)
end


## Operadores propagadores de erro

function Base.:+(x::Measure, y::Measure)
     unc = x.unc+y.unc
     val = x.val+y.val
     return setMes(val,unc)
end


function Base.:-(x::Measure, y::Measure)
     unc = x.unc+y.unc
     val = x.val-y.val
     return setMes(val,unc)
end

function Base.:*(x::Measure, y::Measure)
     unc = (x.unc*y.val)+(y.unc*x.val)
     val = x.val*y.val
     return setMes(val,unc)
end

function Base.:*(x::Measure, c::Real)
    return setMes(x.val*c ,x.unc*c)
end

function Base.:*(c::Real, x::Measure)
    return setMes(x.val*c ,x.unc*c)
end

function Base.:/(x::Measure, y::Measure)
     unc = (x.val*y.unc + y.val*x.unc)/(y.val)^2
     val = x.val/y.val
     return setMes(val,unc)
end

function Base.:/(c::Real, y::Measure)
     x = setMes(c,0)
     return x/y
end

function Base.:/(x::Measure, c::Real)
     return x*(1/c)
end

function Base.:^(x::Measure, n::Int64)
     unc = n*(x.val)^(n-1)*x.unc
     val = (x.val)^n
     return setMes(val,unc)
end

function Base.:^(c::Int64,x::Measure)
    val = c^x.val
    unc = (c^(x.val))*log(c)*x.unc
    return setMes(val,unc)
end

function Base.:cos(x::Measure)
    unc=x.unc*sin(x.val)
    val=cos(x.val)
    return setMes(val,unc)
end

function Base.:sin(x::Measure)
    unc=x.unc*cos(x.val)
    val=sin(x.val)
    return setMes(val,unc)
end

sen = sin # Aqui é Brasil caralho

function Base.:tan(x::Measure, y::Measure)
    return (sin(y)/cos(y))
end

function Base.:log(x::Measure, base::Int64=ℯ)
    unc=(log(base,ℯ)/x.val)*x.val
    val=log(base,x.val)
    return setMes(val,unc)
end

function Base.:exp(c::Int64,x::Measure)
    val = (x.val)^c
    unc = (c^(x.val))*log(c)*x.unc
    return setMes(val,unc)
end
