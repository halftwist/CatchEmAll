//
//  CreaturesListView.swift
//  CatchEmAll
//
//  Created by John Kearon on 5/4/25.
//

import SwiftUI

struct CreaturesListView: View {
    @State var creatures = Creatures()
    var body: some View {
       // itializes object
//        var creatures = ["Pikachu", "Jigglypuff", "Squirtle","Charmander"]
        NavigationStack {
//            Text("Come back & fix this!") //TODO: uncomment below code
            List(creatures.creaturesArray, id: \.self) { creature in  // for displaying, not modifying data. Use For Each to display data that may be modified
                Text(creature.name)
            }
            .listStyle(.plain)
            .navigationTitle("Pokemon")
        }
        .task {
            await creatures.getData()
        }
    }
}

#Preview {
    CreaturesListView()
}
