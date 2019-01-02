//
//  Info.swift
//  Lab 4 Again
//
//  Created by Justin Stares on 10/17/18.
//  Copyright © 2018 Justin Stares. All rights reserved.
//

import Foundation

//struct Info: Codable {
//    var name: String
//    var description: String
//    var image_url: String
//}

struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
struct Movie: Decodable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let vote_count:Int!
}

//struct Info: Decodable{
//    let poster_path: String?
//    let release_date: String
//    let title: String
//
//}
