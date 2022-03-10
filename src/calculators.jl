abstract type ASECalculatorParameters end

function get_potential_energy(atoms::PyObject, parameters::ASECalculatorParameters)
    @assert pyisinstance(atoms, pyimport("ase").Atoms)
    configure_calculator!(atoms, parameters)
    return atoms.get_potential_energy()
end

function get_forces(atoms::PyObject, parameters::ASECalculatorParameters)
    @assert pyisinstance(atoms, pyimport("ase").Atoms)
    configure_calculator!(atoms, parameters)
    return atoms.get_forces()
end

function get_potential_energy(symbol::String, positions::Vector{Vector{Real}}, parameters::ASECalculatorParameters)
    get_potential_energy(atoms(symbol, positions), parameters)
end

function get_potential_energy(symbol::String, positions::Vector{Vector{Real}}, cell::Vector{Real}, parameters::ASECalculatorParameters)
    get_potential_energy(atoms(symbol, positions, cell), parameters)
end

function get_forces(symbol::String, positions::Vector{Vector{Real}}, parameters::ASECalculatorParameters)
    get_forces(atoms(symbol, positions), parameters)
end

function get_forces(symbol::String, positions::Vector{Vector{Real}}, cell::Vector{Real}, parameters::ASECalculatorParameters)
    get_forces(atoms(symbol, positions, cell), parameters)
end

Base.@kwdef struct DFTKCalculatorParameters <: ASECalculatorParameters
    ecut::Union{Real,Nothing} = nothing
    functionals::Union{AbstractVector{String},Nothing} = nothing
    kpts::Union{Tuple,AbstractArray,AbstractFloat,Nothing} = nothing
    mixing::Union{String,Nothing} = nothing
    nbands::Union{Integer,Nothing} = nothing
    pps::Union{String,Nothing} = nothing
    scftol::Union{AbstractFloat,Nothing} = nothing
    smearing::Union{Tuple{String,Real},Tuple{String,Real,Integer},Nothing} = nothing
    xc::Union{String,Nothing} = nothing
    n_mpi::Union{Integer,Nothing} = nothing
    n_threads::Union{Integer,Nothing} = nothing
end
DFTKCalculatorParameters(ecut::Quantity, functionals, kpts, mixing, nbands, pps, scftol, smearing, xc, n_mpi, n_threads) = DFTKCalculatorParameters(ustrip(u"eV", ecut), functionals, kpts, mixing, nbands, pps, scftol, smearing, xc, n_mpi, n_threads)

function configure_calculator!(atoms::PyObject, parameters::DFTKCalculatorParameters)
    DFTKCalc = pyimport("asedftk").DFTK
    atoms.calc = DFTKCalc(; (v => getfield(parameters, v) for v in fieldnames(DFTKCalculatorParameters) if getfield(parameters, v) !== nothing)...)
end

Base.@kwdef struct LAMMPSCalculatorParameters <: ASECalculatorParameters
    files::Union{Vector{String},Nothing} = nothing
    parameters::Dict{String,Union{String,Vector{String}}} = Dict{String,Union{String,Vector{String}}}()
    specorder::Union{Vector{Integer},Nothing} = nothing
    keep_tmp_file::Union{Bool,Nothing} = nothing
    tmp_dir::Union{String,Nothing} = nothing
    no_data_file::Union{Bool,Nothing} = nothing
    keep_alive::Union{Bool,Nothing} = nothing
    always_triclinic::Union{Bool,Nothing} = nothing
end

function configure_calculator!(atoms::PyObject, parameters::LAMMPSCalculatorParameters)
    LAMPPSCalc = pyimport("ase.calculators.lammpsrun").LAMMPS
    atoms.calc = LAMPPSCalc(; (v => getfield(parameters, v) for v in fieldnames(LAMMPSCalculatorParameters) if getfield(parameters, v) !== nothing)...)
end

struct SNAPCalculatorParameters <: ASECalculatorParameters
    lammps_parameters::LAMMPSCalculatorParameters
    twojmax::Real
    rcutfac::Real
    rfac0::Real
    rmin0::Real
    radelem1::Real
    radelem2::Real
    wj1::Real
    wj2::Real
    quadratic::Real
    bzero::Real
    switch::Real
end

function configure_calculator!(atoms::PyObject, parameters::SNAPCalculatorParameters)
    lammps_parameters = parameters.lammps_parameters
    # TODO
    configure_calculator!(atoms, lammps_parameters)
end
