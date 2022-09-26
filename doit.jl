const LIB="./matrix.so"

mutable struct Matrix
    ptr::Ptr{Cvoid}
    function Matrix(ptr::Ptr{Cvoid})
        ret = new(ptr)
        # finalizer(f, obj)
        finalizer(ret) do obj
            println("Matrix deleted")
            deleteMatrix(obj)
        end
        ret
    end
end

function Matrix(length::Integer)
    ptr = @ccall LIB.newMatrix(length::Cint)::Ptr{Cvoid}
    Matrix(ptr)
end

function printMatrix(m::Matrix)
    @ccall LIB.printMatrix(m.ptr::Ptr{Cvoid})::Cvoid
end

function deleteMatrix(m::Matrix)
    @ccall LIB.deleteMatrix(m.ptr::Ptr{Cvoid})::Cvoid
end

function copyIntoMatrix!(m::Matrix, data::Vector{Cfloat})
    GC.@preserve data begin
        @ccall LIB.copyIntoMatrix(m.ptr::Ptr{Cvoid}, data::Ptr{Cfloat})::Cvoid
    end
end

function copyFromMatrix!(out::Vector{Float32}, m::Matrix)
    GC.@preserve out begin
        @ccall LIB.copyFromMatrix(out::Ptr{Cfloat}, m.ptr::Ptr{Cvoid})::Cvoid
    end
    out
end

m = Matrix(2)
printMatrix(m)
copyIntoMatrix!(m, [1f0, 2f0])
printMatrix(m)
x = Float32[42,43]
@show x
copyFromMatrix!(x, m)
@show x

# deleteMatrix(m)
