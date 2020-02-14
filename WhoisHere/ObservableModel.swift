//
//  ObservableModel.swift
//  WhoisHere
//
//  Created by carolyne on 12/02/2020.
//  Copyright © 2020 carolyne. All rights reserved.
//

import Foundation

import SwiftUI
import Combine
import Firebase



class ObservableModel: ObservableObject {
    static let shared = ObservableModel()

    @Published var students = [Student]()
    @Published var connected = (Auth.auth().currentUser != nil)
    @Published var emailStudent = Auth.auth().currentUser?.email
    @Published var inside:Bool = false

}


