//
//  User.swift
//  cai
//
//  Created by Daniel Guarnizo on 12/04/24.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
