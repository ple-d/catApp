//
//  ErrorMessage.swift
//  CatApp
//
//  Created by XO on 11.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidData = "Sorry. Somthing went wrong, try again"
    case invalidResponse = "Server error. Please, try again later"
}
