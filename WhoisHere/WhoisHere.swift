//
//  WhoisHere.swift
//  WhoisHere
//
//  Created by carolyne on 07/02/2020.
//  Copyright © 2020 carolyne. All rights reserved.
//

import Foundation
import Combine
import Firebase

struct WhoisHere {
    
    //static let a =Database.
    //static let studentsRef = Database.database().reference(withPath: "students")
    
    
    /*
    static func createdMe(){
        
        guard
            let user = Auth.auth().currentUser,
            let login = user.email
        else {
            return
        }
        let name = "Carolyne"
        let me = Student(name: name, login: login)
        let meRef = studentsRef.child(name.lowercased())
        meRef.setValue(me.toAnyObject())
        
        
    }*/
    
    static var subscription = Set<AnyCancellable>()
    
    static func createdStudent(name:String, login: String,image:UIImage){
        let student = Student(name: name, login: login,image: image)
        
        CloudStorage.Students.set(student: student)
            .sink(receiveCompletion: { (completion) in
                switch completion{
                case .failure(let error):print("\(error.localizedDescription)")
                case .finished:print("Student added")
                }
            }){ _ in }
        .store(in: &subscription)
        
        //let ref = studentsRef.child(name.lowercased())
        //ref.setValue(student.toAnyObject())
    }
//    static func synchonize(){
//
//        studentsRef
//            .queryOrdered(byChild: "name")
//            .observe(.value, with: { snapshot in
//                let students = snapshot.children
//                    .compactMap({ $0 as? DataSnapshot})
//                    .compactMap(Student.init)
//                print("Students : \(students)")
//            })
//    }
}
