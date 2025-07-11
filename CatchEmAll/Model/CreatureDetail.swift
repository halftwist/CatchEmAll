//
//  CreatureDetail.swift
//  CatchEmAll
//
//  Created by John Kearon on 5/5/25.
//

import Foundation


@Observable // macro that will watch objects for changes so that SwiftUI will redraw the interfaces when needed
class CreatureDetail {
    
//    JSON HIERARCHY FOR https://pokeapi.co/api/v2/pokemon/1/
//    height & weight / sprites / other / official-artwork / front-default
    
    private struct Returned: Codable {
        var height: Double
        var weight: Double
        var sprites: Sprite
    }
    
    struct Sprite: Codable {
        var other: Other
    }
    
    struct Other: Codable {
        var officialArtwork: OfficialArtwork
// Use CodingKeys to map JSON keys to Swift variables
// embeded "-" is invalid for variable names so use CodingKeys
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    struct OfficialArtwork: Codable {
        var front_default: String? // This might return null, which is nil in Swift
    }
    
    var urlString = "" // Updated with string passed in from creature clicked on
    var height = 0.0
    var weight = 0.0
    var imageURL = ""
    
        func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        // Ceate a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode JSON data into our own data structues
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data")
                return
            }
//            print("😎 JSON returned! count: \(returned.count), next: \(returned.next)")
            // dats returned in the JSON file
            self.height = returned.height
            self.weight = returned.weight
//  Pro-Tip: Do NOT use an empty String "" for any value you want to be considered an invalid URL. iOS considers "" to be a valie URL(due to it's possible use as a directory path).
            self.imageURL = returned.sprites.other.officialArtwork.front_default ?? "n/a"  // if NULL set to "n/a"
            
        } catch {
            print("😡 ERROR: Could not get data from \(urlString)")
        }
    }
    
}

