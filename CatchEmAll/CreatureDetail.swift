//
//  CreatureDetail.swift
//  CatchEmAll
//
//  Created by John Kearon on 5/5/25.
//

import Foundation


@Observable // macro that will watch objects for changes so that SwiftUI will redraw the interfaces when needed
class CreatureDetail {
    private struct Returned: Codable {
        var height: Double
        var weight: Double
        var sprites: Sprite
    }
    
    struct Sprite: Codable {
        var front_default: String
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
            self.imageURL = returned.sprites.front_default
            
        } catch {
            print("😡 ERROR: Could not get data from \(urlString)")
        }
    }
    
}

