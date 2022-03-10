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
    ecut::Union{Real, Nothing} = nothing
    functionals::Union{AbstractVector{String}, Nothing} = nothing
    kpts::Union{Tuple, AbstractArray, AbstractFloat, Nothing} = v
    mixing::Union{String, Nothing} = nothing
    nbands::Union{Integer, Nothing} = nothing
    pps::Union{String, Nothing} = nothing
    scftol::Union{AbstractFloat, Nothing} = nothing
    smearing::Union{Tuple{String, Real}, Tuple{String, Real, Integer}, Nothing} = nothing
    xc::Union{String, Nothing} = nothing
    n_mpi::Union{Integer, Nothing} = nothing
    n_threads::Union{Integer, Nothing} = nothing
end
DFTKCalculatorParameters(ecut::Quantity, functionals, kpts, mixing, nbands, pps, scftol, smearing, xc, n_mpi, n_threads) = DFTKCalculatorParameters(ustrip(u"eV", ecut), functionals, kpts, mixing, nbands, pps, scftol, smearing, xc, n_mpi, n_threads)

function configure_calculator!(atoms::PyObject, parameters::DFTKCalculatorParameters)
    DFTKCalc = pyimport("asedftk").DFTK
    atoms.calc = DFTKCalc(; (v=>getfield(parameters, v) for v in fieldnames(DFTKCalculatorParameters) if getfield(parameters, v) !== nothing)...)
end

# Base.@kwdef struct LAMMPSCalculatorParameters <: ASECalculatorParameters
#     files::Union{Vector{String}, Missing} = missing
#     parameters::Dict{String, Union{String, Vector{String}}} = Dict{String, Union{String, Vector{String}}}()
#     specorder::Union{Vector{Integer}, Missing} = missing
#     keep_tmp_file::Union{Bool, Missing} = missing
#     tmp_dir::Union{String, Missing} = missing
#     no_data_file::Union{Bool, Missing} = missing
#     keep_alive::Union{Bool, Missing} = missing
#     always_triclinic::Union{Bool, Missing} = missing
# end

# function configure_calculator!(atoms::PyObject, parameters::LAMMPSCalculatorParameters)
#     LAMPPSCalc = pyimport("ase.calculators.lammpsrun").LAMMPS
#     atoms.calc = LAMPPSCalc(; (v=>getfield(parameters, v) for v in fieldnames(LAMMPSCalculatorParameters) if getfield(parameters, v) !== missing)...)
# end

Base.@kwdef struct LAMMPSCalculatorParameters <: ASECalculatorParameters
    lmpcmds::Vector{String}
    atom_types::Union{Dict{String, Integer}, Nothing} = nothing
    atom_type_masses::Union{Dict{String, Real}, Nothing} = nothing
    log_file::Union{String, Nothing} = nothing
    lammps_header::Union{Vector{String}, Nothing} = nothing
    amendments::Union{Vector{String}, Nothing} = nothing
    keep_alive::Union{Bool, Nothing} = nothing
end

function configure_calculator!(atoms::PyObject, parameters::LAMMPSCalculatorParameters)
    LAMPPSCalc = pyimport("ase.calculators.lammpslib").LAMMPSlib
    atoms.calc = LAMPPSCalc(; (v=>getfield(parameters, v) for v in fieldnames(LAMMPSCalculatorParameters) if getfield(parameters, v) !== nothing)...)
end

Base.@kwdef struct SNAPCalculatorParameters <: ASECalculatorParameters
    lammps_parameters::LAMMPSCalculatorParameters
    rcutfac::Real
    rfac0::Real
    twojmax::Real
    radelem1::Real
    radelem2::Real
    wj1::Real
    wj2::Real
    rmin0::Real
    quadratic::Integer
    bzero::Integer
    switch::Integer
end

function configure_calculator!(atoms::PyObject, parameters::SNAPCalculatorParameters)
    lammps_parameters = parameters.lammps_parameters
    push!(lammps_parameters.lmpcmds, "compute SNA all sna/atom $(parameters.rcutfac) $(parameters.rfac0) $(parameters.twojmax) $(parameters.radelem1) $(parameters.radelem2) $(parameters.wj1) $(parameters.wj2) rmin0 $(parameters.rmin0) bzeroflag $(parameters.bzero) quadraticflag $(parameters.quadratic) switchflag $(parameters.switch)")
    push!(lammps_parameters.lmpcmds, "compute SNAD all snad/atom $(parameters.rcutfac) $(parameters.rfac0) $(parameters.twojmax) $(parameters.radelem1) $(parameters.radelem2) $(parameters.wj1) $(parameters.wj2) rmin0 $(parameters.rmin0) bzeroflag $(parameters.bzero) quadraticflag $(parameters.quadratic) switchflag $(parameters.switch)")
    push!(lammps_parameters.lmpcmds, "compute SNAV all snav/atom $(parameters.rcutfac) $(parameters.rfac0) $(parameters.twojmax) $(parameters.radelem1) $(parameters.radelem2) $(parameters.wj1) $(parameters.wj2) rmin0 $(parameters.rmin0) bzeroflag $(parameters.bzero) quadraticflag $(parameters.quadratic) switchflag $(parameters.switch)")
    configure_calculator!(atoms, lammps_parameters)
end
