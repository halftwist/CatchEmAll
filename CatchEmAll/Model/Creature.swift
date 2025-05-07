//
//  Creature.swift
//  CatchEmAll
//
//  Created by John Kearon on 5/5/25.
//

import Foundation


//  Hashable A type that can be hashed into a Hasher to produce an integer hash value
//  Identifiable A class of types whose instances hold the value of an entity with stable identity.

struct Creature: Codable, Identifiable {
    let id = UUID().uuidString   // UUID A universally unique value to identify types, interfaces, and other items.
    
    var name: String
    var url: String // url for detail on Pokemon
    
//    CodingKey A type that can be used as a key for encoding and decoding.
    
    enum CodingKeys: String, CodingKey {
// CodingKeys will let you specify which properties should be used for coding and decoding. In this case we ignore the ID property when decoding
        case name
        case url
    }
}
