//
//  Model.swift
//  CatApp
//
//  Created by XO on 10.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation

struct Cat: Codable {
    var id: String?
    var url: String?
    var width: Int?
    var height: Int?
    
}

struct Breed: Codable {
    let weight: Weight?
    let id, name: String?
    let cfaURL: String?
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let temperament, origin, countryCodes, countryCode: String?
    let breedDescription, lifeSpan: String?
    let indoor, lap, adaptability, affectionLevel: Int?
    let childFriendly, catFriendly, dogFriendly, energyLevel: Int?
    let grooming, healthIssues, intelligence, sheddingLevel: Int?
    let socialNeeds, strangerFriendly, vocalisation, bidability: Int?
    let experimental, hairless, natural, rare: Int?
    let rex, suppressedTail, shortLegs: Int?
    let wikipediaURL: String?
    let hypoallergenic: Int?
    let referenceImageID: String?
}

struct Weight: Codable {
    let imperial, metric: String?
}
