__precompile__()
module ASEPotential

using Atomistic
using AtomsBase
using InteratomicPotentials

using PyCall
using StaticArrays
using Unitful

export ASEAtom, ASEAtoms
include("atoms.jl")

export ASECalculator
include("calculators.jl")

export read_atoms, write_atoms, write_trajectory
include("io.jl")

const ASE = PyNULL()
const IO = PyNULL()

function __init__()
    copy!(ASE, pyimport_e("ase"))
    copy!(IO, pyimport_e("ase.io"))
    if ispynull(ASE)
        @error "ASEPotential failed to load ase!"
    end
end

end
