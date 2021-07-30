//
//  ContentView.swift
//  AsyncLet
//
//  Created by Pedro Rojas on 29/07/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loader = PokemonLoader()

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(
                    loader.pokemonData,
                    id: \.hashValue
                ) { data in
                    Image(data: data)
                        .resizable()
                        .frame(width: 120,height: 120)
                        .aspectRatio(contentMode: .fit)

                }
            }
        }
        .task {
            await loader.load()
        }
    }
}

extension Image {
    init(data: Data) {
        if let uiImage = UIImage(data: data) {
            self.init(uiImage: uiImage)
        } else {
            self.init(systemName: "questionmark")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
