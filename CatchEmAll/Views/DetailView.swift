//
//  DetailView.swift
//  CatchEmAll
//
//  Created by John Kearon on 5/5/25.
//

import SwiftUI

struct DetailView: View {
    
    let creature: Creature  // read only data passed from parent view
    @State private var creatureDetail = CreatureDetail()
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text(creature.name.capitalized)
                .font(Font.custom("Avenir Next Condensed", size: 60))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.gray)
                .padding(.bottom)
            
            HStack {
                creatureImage  // defined in the extension below

                VStack (alignment:.leading) {
                    HStack (alignment: .top){
                        Text("Height:")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)
                        
                        Text(String(format: "%.1f", creatureDetail.height))
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    HStack (alignment: .top){
                        Text("Weight:")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)
                        
                        Text(String(format: "%.1f", creatureDetail.weight))
                            .font(.largeTitle)
                            .bold()
                    }

                }
                
                
//                Text("PokeType")
//                    .font(Font.custom("Avenir Next Condensed", size: 20))
//                    .bold()
//                    .minimumScaleFactor(0.5)
                
            }
            
            Spacer()
        }
        .padding()
        .task {
            creatureDetail.urlString = creature.url // use URL passed over in getDetail for CreatureDetail
            await creatureDetail.getData()
        }
    }
}

extension DetailView {
    var creatureImage: some View {
        AsyncImage(url: URL(string: creatureDetail.imageURL)) { phase in
            if let image = phase.image { // We have a valid image
                image
                    .resizable()
                    .scaledToFit()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }

            } else if phase.error != nil {  // We've had an error
                Image(systemName: "questionmark.square.dashed")
                    .resizable()
                    .scaledToFit()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }

            } else { // Use a placeholder - while image loading
                ProgressView()
                    .tint(.red)
                    .scaleEffect(4)
//                        RoundedRectangle(cornerRadius: 10)  // demonstrates you don't need an image here
//                            .foregroundStyle(.clear)
            }

        }
        .frame(width: 96, height: 96)
        .padding(.trailing)
    }
}

#Preview {
    DetailView(creature: Creature(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
