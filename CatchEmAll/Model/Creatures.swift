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
        var next: String? //TODO: We want to change this to an optional due to possible NULL values
        var results: [Creature]
    }
    
    
    var urlString = "https://pokeapi.co/api/v2/pokemon/"
    var count = 0
    var creaturesArray: [Creature] = []
    var isLoading = false
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        isLoading = true
        
        // Ceate a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode JSON data into our own data structues
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data")
                isLoading = false
                return
            }
            print("😎 JSON returned! count: \(returned.count), next: \(returned.next ?? "")")
            
            // Pro Tip:
            // If you've got an async function that might take some time, but it's updating values that impact the user interface, push them to the main thread using @MianActor. There are many ways to do this, but TASK { @MainActor in works well
            Task { @MainActor in  // forces this code to run on the main thread
                self.count = returned.count
                self.urlString = returned.next ?? ""  // if returned.next is not a string, a nil value will be loaded instead""
                // When loading multiple pages of data, make sure you add new pages to any existing array, don't simply overwrite your first page with the second page, or you won't see all of your data.
                self.creaturesArray = self.creaturesArray + returned.results
                isLoading = false
            }
            
        } catch {
            print("😡 ERROR: Could not get data from \(urlString)")
            isLoading = false
        }
    }
    
}

