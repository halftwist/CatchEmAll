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
            // List using range
            List(0..<creatures.creaturesArray.count, id: \.self) { index in  // for displaying, not modifying data. Use For Each to display data that may be modified
                LazyVStack {  // loads one "row" at a time which is needed to determine when the last row is loaded
                    NavigationLink {
                        DetailView(creature: creatures.creaturesArray[index])
                    } label: {
                        Text("\(index+1) \(creatures.creaturesArray[index].name.capitalized)")
                            .font(.title2)
                    }
                }
                .task {  // check if last row has been loaded, if so use getData to download the next page of JSON
                    guard let lastCreature = creatures.creaturesArray.last else { return
                    }
                    if creatures.creaturesArray[index].name == lastCreature.name && creatures.urlString.hasPrefix("http") {
                        await creatures.getData()
                    }
                }
                // List
//            List(creatures.creaturesArray, id: \.self) { creature in  // for displaying, not modifying data. Use For Each to display data that may be modified
//                NavigationLink {
//                    DetailView(creature: creature)
//                } label: {
//                    Text(creature.name.capitalized)
//                        .font(.title2)
//                }

                
            }
            .listStyle(.plain)
            .navigationTitle("Pokemon")
            .toolbar {   // placed within the NavigationStack, not after it!
                ToolbarItem(placement: .status) {
                    Text("\(creatures.creaturesArray.count) of \(creatures.count)")
                }
                
            }
        }
        .task {
            await creatures.getData()
        }
    }

}

#Preview {
    CreaturesListView()
}
