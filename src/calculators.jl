struct ASECalculator <: ArbitraryPotential
    package::String
    class::Symbol
    kwargs::Dict{Symbol,Any}
    ASECalculator(package::String, class::Symbol; kwargs...) = new(package, class, Dict{Symbol,Any}(kwargs...))
end

InteratomicPotentials.energy_and_force(system::AbstractSystem{3}, calculator::ASECalculator) = energy_and_force(ASEAtoms(system), calculator)
function InteratomicPotentials.energy_and_force(atoms::PyObject, calculator::ASECalculator)
    @assert pyisinstance(atoms, ASE.Atoms)
    atoms.calc = getproperty(pyimport(calculator.package), calculator.class)()
    atoms.calc.set(; calculator.kwargs...)
    # TODO: units are incorrect
    (; e = atoms.get_potential_energy(), f = SVector{3}.(eachrow(atoms.get_forces())))
end
