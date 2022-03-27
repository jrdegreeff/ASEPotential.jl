ASEAtom(symbol::String, position::AbstractVector{<:Real}) = ASE.Atom(symbol, position)
ASEAtom(; kwargs...) = ASE.Atom(; kwargs...)

ASEAtoms(symbols, positions) = ASE.Atoms(symbols, positions; pbc = true)
ASEAtoms(symbols, positions, cell) = ASE.Atoms(symbols, positions; cell = cell, pbc = true)
ASEAtoms(atoms::AbstractVector{PyObject}) = ASE.Atoms(atoms; pbc = true)
ASEAtoms(atoms::AbstractVector{PyObject}, cell) = ASE.Atoms(atoms; cell = cell, pbc = true)
ASEAtoms(; kwargs...) = ASE.Atoms(; kwargs...)

function ASEAtoms(system::AbstractSystem{3})
    symbols = string.(atomic_symbol(system))
    positions = ustrip.((u"Å",), reduce(hcat, position(system))')
    cell = ASE.cell.Cell(ustrip.((u"Å",), reduce(hcat, bounding_box(system))'))
    ASEAtoms(symbols, positions, cell)
end
