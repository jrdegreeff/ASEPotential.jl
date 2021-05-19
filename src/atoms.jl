function atoms(symbol::String, positions::Vector{Vector{Real}})
    pyAtoms = pyimport("ase").Atoms
    return pyAtoms(symbol, positions=positions, pbc=true)
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