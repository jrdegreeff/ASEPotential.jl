struct ASECalculator
    package::String
    class::Symbol
    kwargs::Dict{Symbol,Any}
    ASECalculator(package::String, class::Symbol; kwargs...) = new(package, class, Dict{Symbol,Any}(kwargs...))
end

function configure_calculator!(atoms::PyObject, calculator::ASECalculator)
    atoms.calc = getproperty(pyimport(calculator.package), calculator.class)()
    atoms.calc.set(; calculator.kwargs...)
end

function get_potential_energy(atoms::PyObject, parameters::ASECalculator)
    @assert pyisinstance(atoms, pyimport("ase").Atoms)
    configure_calculator!(atoms, parameters)
    return atoms.get_potential_energy()
end

function get_forces(atoms::PyObject, parameters::ASECalculator)
    @assert pyisinstance(atoms, pyimport("ase").Atoms)
    configure_calculator!(atoms, parameters)
    return atoms.get_forces()
end
