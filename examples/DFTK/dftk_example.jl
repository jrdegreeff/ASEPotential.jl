# https://github.com/mfherbst/asedftk/blob/master/docs/asedftk.md
# https://juliamolsim.github.io/DFTK.jl/stable/guide/tutorial/

using ASEPotential
using DFTK
using Unitful
using UnitfulAtomic

lattice = austrip(5.431u"Å") / 2 * [[0 1 1.0]; [1 0 1.0]; [1 1 0.0]]
Si = ElementCoulomb(:Si)
dftk_atoms = [Si, Si]
positions = [ones(3) / 8, -ones(3) / 8]
atoms = ase_atoms(lattice, dftk_atoms, positions)
calculator = ASECalculator("asedftk", :DFTK; ecut = ustrip(u"eV", 7u"hartree"), kpts = [4, 4, 4], scftol = 1e-8)

@time println(energy_and_force(atoms, calculator))
