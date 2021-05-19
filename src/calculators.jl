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

function get_forces(symbol::String, positions::Vector{Vector{Real}}, parameters::ASECalculatorParameters)
    get_forces(atoms(symbol, positions), parameters)
end

@with_kw struct DFTKCalculatorParameters <: ASECalculatorParameters
    ecut::Union{Real, Missing} = missing
    functionals::Union{AbstractVector{String}, Missing} = missing
    kpts::Union{Tuple, AbstractArray, AbstractFloat, Missing} = missing
    mixing::Union{String, Missing} = missing
    nbands::Union{Integer, Missing} = missing
    pps::Union{String, Missing} = missing
    scftol::Union{AbstractFloat, Missing} = missing
    smearing::Union{Tuple{String, Real}, Tuple{String, Real, Integer}, Missing} = missing
    xc::Union{String, Missing} = missing
    n_mpi::Union{Integer, Missing} = missing
    n_threads::Union{Integer, Missing} = missing
    DFTKCalculatorParameters(ecut::Quantity, functionals, kpts, mixing, nbands, pps, scftol, smearing, xc, n_mpi, n_threads) = new(ustrip(u"eV", ecut), functionals, kpts, mixing, nbands, pps, scftol, smearing, xc, n_mpi, n_threads)
end

function configure_calculator!(atoms::PyObject, parameters::DFTKCalculatorParameters)
    DFTKcalc = pyimport("asedftk").DFTK
    atoms.calc = DFTKcalc(; (v=>getfield(parameters, v) for v in fieldnames(DFTKCalculatorParameters) if getfield(parameters, v) !== missing)...)
end
