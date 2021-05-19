using ASEPotential
using DFTK
using Test
using Unitful
using UnitfulAtomic

@testset "ASEPotential.jl" begin
    lattice = austrip(5.431u"Å") / 2 * [[0 1 1.]; [1 0 1.]; [1 1 0.]]
    Si = ElementPsp(:Si, psp=load_psp("hgh/lda/Si-q4"))
    dftk_atoms = [Si => [ones(3)/8, -ones(3)/8]]
    atoms = ase_atoms(lattice, dftk_atoms)
    parameters = DFTKCalculatorParameters(
        ecut=7u"hartree",
        kpts=[4,4,4],
        scftol=1e-8
    )
    println(get_potential_energy(atoms, parameters))
    println(get_forces(atoms, parameters))
end
