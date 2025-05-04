//
//  Creatures.swift
//  CatchEmAll
//
//  Created by John Kearon on 5/4/25.
//
import Foundation

@Observable // macro that will watch objects for changes so that SwiftUI will redraw the interfaces when needed
class Creatures {
    private struct Returned: Codable {
        var count: Int
        var next: String //TODO: We want to change this to an optional due to possible NULL values
        var results: [Result]
    }
    
    struct Result: Codable, Hashable {
        var name: String
        var url: String // url for detail on Pokemon
    }
    
    var urlString = "https://pokeapi.co/api/v2/pokemon/"
    var count = 0
    var creaturesArray: [Result] = []
    
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
            self.count = returned.count
            self.urlString = returned.next
            self.creaturesArray = returned.results
            
        } catch {
            print("😡 ERROR: Could not get data from \(urlString)")
        }
    }
    
}

