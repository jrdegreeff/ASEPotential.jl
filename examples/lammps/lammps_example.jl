# https://gitlab.com/ase/ase/blob/master/doc/ase/calculators/lammpsrun.rst
# https://wiki.fysik.dtu.dk/ase/ase/calculators/lammpsrun.html

using ASEPotential

a = atoms([atom("Na", [0, 0, 0]), atom("Cl", [0, 0, 2.3608])], [6.5, 6.5, 7.7])
calculator = ASECalculator("ase.calculators.lammpsrun", :LAMMPS)

@time println(get_potential_energy(a, calculator))
@time println(get_forces(a, calculator))
