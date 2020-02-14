//
//  Student.swift
//  WhoisHere
//
//  Created by carolyne on 07/02/2020.
//  Copyright © 2020 carolyne. All rights reserved.
//

import Foundation
import Combine
import Firebase


enum StudentError: Error {
    case cannotCreatePNG
    case noUploadURL
}


struct Student: Hashable, Identifiable {
    var id: String { login }
    
    let name: String
    let login: String
    let image: UIImage

    
    init(name: String, login: String, image: UIImage) {
        self.name = name
        self.login = login.lowercased()
        self.image = image
    }
    
    
    static func extract(from snapshot: QueryDocumentSnapshot) -> AnyPublisher<Student?, Error> {
        snapshot.extractStudent()
    }
}


extension QueryDocumentSnapshot {
    func extractStudent() -> AnyPublisher<Student?, Error> {
        let data = self.data()
        guard
            let name = data["name"] as? String,
            let login = data["login"] as? String,
            let imageUrl = data["image"] as? String
        else {
            return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        func createStudent(image: UIImage) -> Student? {
            Student(
                name: name,
                login: login,
                image: image
            )
        }

        return CloudStorage.Images.get(url: imageUrl)
            .map(createStudent)
            .eraseToAnyPublisher()
    }
}
