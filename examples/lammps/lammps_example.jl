# https://gitlab.com/ase/ase/blob/master/doc/ase/calculators/lammpsrun.rst
# https://wiki.fysik.dtu.dk/ase/ase/calculators/lammpsrun.html

using ASEPotential
using InteratomicPotentials

atoms = ASEAtoms([ASEAtom("Na", [0.0, 0.0, 0.0]), ASEAtom("Cl", [0.0, 0.0, 2.3608])], [6.5, 6.5, 7.7])
calculator = ASECalculator("ase.calculators.lammpsrun", :LAMMPS)

@time println(energy_and_force(atoms, calculator))
