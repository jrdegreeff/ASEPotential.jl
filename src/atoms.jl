function atom(symbol::String, position::Vector{<: Real})
    pyAtom = pyimport("ase").Atom
    return pyAtom(symbol, position)
end

function atoms(symbol::String, positions::Vector{Vector{<: Real}})
    pyAtoms = pyimport("ase").Atoms
    return pyAtoms(symbol, positions, pbc=true)
end

function atoms(symbol::String, positions::Vector{Vector{<: Real}}, cell::Vector{<: Real})
    pyAtoms = pyimport("ase").Atoms
    return pyAtoms(symbol, positions, cell=cell, pbc=true)
end

function atoms(atoms::Vector)
    pyAtoms = pyimport("ase").Atoms
    return pyAtoms(atoms, pbc=true)
end

function atoms(atoms::Vector, cell::Vector{<: Real})
    pyAtoms = pyimport("ase").Atoms
    return pyAtoms(atoms, cell=cell, pbc=true)
end

function read_atoms(path::String)
    read = pyimport("ase.io").read
    return read(path)
end

function write_atoms(path::String, atoms::PyObject)
    @assert pyisinstance(atoms, pyimport("ase").Atoms)
    write = pyimport("ase.io").write
    return write(path, atoms)
end
