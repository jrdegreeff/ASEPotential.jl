"""
    write_ase_trajectory(result::MolecularDynamicsResult, filename::String)

Write the trajectory of a `MolecularDynamicsResult` to a .traj file.

The file can be visualized by running `ase gui <filename>` on the command line.
"""
function write_trajectory(result::MolecularDynamicsResult, filename::String)
    if ispynull(pyimport_e("ase"))
        @warn "ASE is not installed, skipping write_trajectory"
    else
        filename = abspath(expanduser(filename))
        if isfile(filename)
            @info "overwriting trajectory at" filename
            rm(filename)
        else
            @info "writing trajectory to" filename
        end
        traj = pyimport("ase.io.trajectory").Trajectory(filename, "a")
        for t ∈ 1:length(result)
            lattice, atoms = parse_system(get_system(result, t))
            traj.write(ase_atoms(lattice, atoms))
        end
        traj.close()
    end
end
