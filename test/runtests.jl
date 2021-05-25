using ASEPotential
using DFTK
using Random
using Test
using Unitful
using UnitfulAtomic

@testset "ASEPotential.jl" begin
    # lattice = austrip(5.431u"Å") / 2 * [[0 1 1.]; [1 0 1.]; [1 1 0.]]
    # Si = ElementCoulomb(:Si)
    # dftk_atoms = [Si => [ones(3)/8, -ones(3)/8]]
    # atoms = ase_atoms(lattice, dftk_atoms)
    # parameters = DFTKCalculatorParameters(
    #     ecut=7u"hartree",
    #     kpts=[4,4,4],
    #     scftol=1e-8
    # )
    # Random.seed!(0)
    # @test get_potential_energy(atoms, parameters) ≈ -215.0580878686717
    # Random.seed!(0)
    # @test get_forces(atoms, parameters) ≈ [1.173847659689125e-8 8.569836404025708e-7 5.721619345126702e-7; 1.1871613637211492e-6 -1.5182045878897422e-7 -3.3896961821263334e-7]

    a = atoms([atom("Na", [0,0,0]), atom("Cl", [0,0,2.3608])], [6.5, 6.5, 7.7])
    parameters = LAMMPSCalculatorParameters(

    )
    println(get_potential_energy(a, parameters))
end
