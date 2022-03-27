read_atoms(path::String) = IO.read(path)
write_atoms(path::String, atoms::PyObject) = IO.write(path, atoms)

"""
    write_trajectory(result::MolecularDynamicsResult, filename::String)

Write the trajectory of a `MolecularDynamicsResult` to a .traj file.

The file can be visualized by running `ase gui <filename>` on the command line.
"""
function write_trajectory(result::MolecularDynamicsResult, filename::String)
    filename = abspath(expanduser(filename))
    if isfile(filename)
        @info "overwriting trajectory at" filename
        rm(filename)
    else
        @info "writing trajectory to" filename
    end

    traj = IO.trajectory.Trajectory(filename, "a")
    for t ∈ 1:length(result)
        traj.write(ASEAtoms(get_system(result, t)))
    end
    traj.close()
end
