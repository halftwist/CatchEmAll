//
//  CreaturesListView.swift
//  CatchEmAll
//
//  Created by John Kearon on 5/4/25.
//

import SwiftUI

struct CreaturesListView: View {
    @State var creatures = Creatures()
    @State private var searchText = ""
    
    var body: some View {
       // itializes object
//        var creatures = ["Pikachu", "Jigglypuff", "Squirtle","Charmander"]
        NavigationStack {

            // List using range
            ZStack {
                List(searchResults) { creature in
// Use List for displaying, not modifying data. Use For Each to display data that may be modified
// loads one "row" at a time which is needed to determine when the last row is loaded
                    LazyVStack {
                        NavigationLink {
                            DetailView(creature: creature)
                        } label: {
                            Text("\(returnIndex(of: creature)) \(creature.name.capitalized)")
                                .font(.title2)
                        }
                    }
                    .task {
                        await creatures.loadNextIfNeeded(creature: creature)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Pokemon")
                .toolbar {   // placed within the NavigationStack, not after it!
                    ToolbarItem(placement: .bottomBar) {
                        Button("Load All") {
                            Task {
                                await creatures.loadAll()
                            }
                        }
                    }

                    ToolbarItem(placement: .status) {
                        Text("\(creatures.creaturesArray.count) of \(creatures.count)")
                    }
                }
                .searchable(text:$searchText)
                
                if creatures.isLoading {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4.0)
                }
               
            }
        }
        .task {
            await creatures.getData()
        }
    }
    
    var searchResults: [Creature] {
        if searchText.isEmpty {
            return creatures.creaturesArray
        } else {
            return creatures.creaturesArray.filter {
                $0.name.capitalized.contains(searchText)
            }
        }
    }
    
    // "of" is the argument label
    // "creature" is the parameter used inside the function
    func returnIndex(of creature: Creature) -> Int {
    // If you are searching on somethimg that is Identifiable(Creature struct is Identifiable), then it's better to compare .id properties than .name. It's not an issue here since names are unique.
        guard let index =
            creatures.creaturesArray.firstIndex(where: {$0.name == creature.name}) else { return 0 }
        return index + 1
    }

}

#Preview {
    CreaturesListView()
}
