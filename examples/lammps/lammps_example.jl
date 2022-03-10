# https://gitlab.com/ase/ase/blob/master/doc/ase/calculators/lammpsrun.rst

using ASEPotential

a = atoms([atom("Na", [0, 0, 0]), atom("Cl", [0, 0, 2.3608])], [6.5, 6.5, 7.7])
parameters = LAMMPSCalculatorParameters()

@time println(get_potential_energy(a, parameters))
@time println(get_forces(a, parameters))
