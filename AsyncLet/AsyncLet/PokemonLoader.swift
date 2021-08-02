//
//  PokemonLoader.swift
//  PokemonLoader
//
//  Created by Pedro Rojas on 29/07/21.
//

import Foundation

enum PokemonError: Error {
    case serverError
    case noData
}

class PokemonLoader: ObservableObject {
    @Published var error = false
    @Published var pokemonData: [Data] = []

    func getImage(pokemonId: Int) async throws -> Data {
        let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonId).png")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200
        else { throw PokemonError.serverError }

        return data
    }

    func load() async {
        /// Comparte the time between these two methods!
        //await loadWithAwait()
        await loadWithAsyncLet()
    }

    @MainActor
    func loadWithAwait() async {
        do {
            let start = Date.now
            let bulbasaur = try await getImage(pokemonId: 1)
            let charizard = try await getImage(pokemonId: 6)
            let squirtle  = try await getImage(pokemonId: 7)
            let pidgeotto = try await getImage(pokemonId: 17)
            let kingler   = try await getImage(pokemonId: 99)
            let pikachu   = try await getImage(pokemonId: 25)
            calculateTime(from: start)



            pokemonData = [bulbasaur, charizard, squirtle, pidgeotto, kingler,pikachu]
        } catch {
            print(error)
            self.error = true
        }
    }

    @MainActor
    func loadWithAsyncLet() async {
        do {
            let start = Date.now
            async let bulbasaur = getImage(pokemonId: 1)
            async let charizard = getImage(pokemonId: 6)
            async let squirtle  = getImage(pokemonId: 7)
            async let pidgeotto = getImage(pokemonId: 17)
            async let kingler   = getImage(pokemonId: 99)
            async let pikachu   = getImage(pokemonId: 25)
            calculateTime(from: start)


            pokemonData = try await [bulbasaur, charizard, squirtle, pidgeotto, kingler,pikachu]

        } catch {
            print(error)
            self.error = true
        }
    }

    func calculateTime(from start: Date) {
        let end = Date.now
        let diffs = Calendar.current.dateComponents([.nanosecond], from: start, to: end)
        let nanoseconds = diffs.nanosecond!
        let seconds = Double(nanoseconds)/1_000_000_000.0
        print("Total time: \(seconds) seconds")
        print("(\(nanoseconds) nanoseconds)")
    }
}
