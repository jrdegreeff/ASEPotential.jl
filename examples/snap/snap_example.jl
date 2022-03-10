using ASEPotential

a = atoms([]) # TODO: load atoms from data file
parameters = SNAPCalculatorParameters(
    lammps_parameters=LAMMPSCalculatorParameters(
        lmpcmds = [
            "pair_style snap",
            "pair_coeff * * GaN.snapcoeff GaN.snapparam Ga N",
            # "compute PE all pe",
            # "compute S all pressure thermo_temp",
            "read_data " * joinpath("data", string(1), "DATA")
        ],
        lammps_header = [
            "units metal",
            "boundary p p p",
            "atom_style atomic",
            "atom_modify map array"
        ]
    ),
    rcutfac=3.5,
    rfac0=0.99363,
    twojmax=6,
    radelem1=0.5,
    radelem2=0.5,
    wj1=1.0,
    wj2=0.5,
    rmin0=0.0,
    quadratic=0,
    bzero=0,
    switch=1
)

@time println(get_potential_energy(a, parameters))
@time println(get_forces(a, parameters))
