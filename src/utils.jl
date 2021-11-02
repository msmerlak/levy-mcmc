function time_avg(v::Vector)
    a = similar(v)
    for i in 1:length(v)
        a[i] = sum(v[1:i])/i
    end
    return a
end