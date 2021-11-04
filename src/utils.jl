function sliding_mean(v::Vector)
    s = similar(v)
    s[1] = v[1]
    for n in 1:length(v)-1
        s[n+1] = (n*s[n] + v[n])/(n+1)
    end
    return s
end

function sliding_var(v::Vector)
    s = similar(v)
    s[1] = v[1]^2
    for n in 1:length(v)-1
        s[n+1] = (n*s[n] + v[n]^2)/(n+1)
    end
    return s
end


function Phat(v::Vector)
    s = similar(v)
    s[1] = all(>=(0), v[1])
    for n in 1:length(v)-1
        s[n+1] = (n*s[n] + all(>=(0), v[n]))/(n+1)
    end
    return s
end

function positive_quadrant(v)
    return mean(map(x -> all(>=(0), x), v))
end