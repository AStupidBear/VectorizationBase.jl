
@inline align(x) = (x + REGISTER_SIZE-1) & -REGISTER_SIZE
align(x::Ptr{T}) where {T} = reinterpret(Ptr{T}, align(reinterpret(UInt, x)))
align(x, n) = (nm1 = n - 1; (x + nm1) & -n)
align(x, ::Type{T}) where {T} = align(x, REGISTER_SIZE ÷ sizeof(T))
# @generated align(::Val{L}, ::Type{T}) where {L,T} = align(L, T)
aligntrunc(x, n) = x & -n
aligntrunc(x) = aligntrunc(x, REGISTER_SIZE)
aligntrunc(x, ::Type{T}) where {T} = aligntrunc(x, REGISTER_SIZE ÷ sizeof(T))
alignment(x, N = 64) = reinterpret(Int, x) % N

function valloc(N::Int, ::Type{T} = Float64) where {T}
    # We want alignment to both vector and cacheline-sized boundaries
    a = max(REGISTER_SIZE, CACHELINE_SIZE) 
    reinterpret(Ptr{T}, align(reinterpret(UInt,Libc.malloc(sizeof(T)*N + a - 1)), a))
end

