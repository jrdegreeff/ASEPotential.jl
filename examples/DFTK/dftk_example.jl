# https://juliamolsim.github.io/DFTK.jl/stable/guide/tutorial/

using ASEPotential
using DFTK
using Unitful
using UnitfulAtomic

lattice = austrip(5.431u"Å") / 2 * [[0 1 1.]; [1 0 1.]; [1 1 0.]]
Si = ElementCoulomb(:Si)
dftk_atoms = [Si => [ones(3)/8, -ones(3)/8]]
atoms = ase_atoms(lattice, dftk_atoms)
parameters = DFTKCalculatorParameters(
    ecut=7u"hartree",
    kpts=[4,4,4],
    scftol=1e-8
)

@time println(get_potential_energy(atoms, parameters))
@time println(get_forces(atoms, parameters))
