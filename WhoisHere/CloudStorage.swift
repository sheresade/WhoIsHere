//
//  CloudStorage.swift
//  
//
//  Created by carolyne on 11/02/2020.
//

import Foundation
import Combine
import Firebase
import Alamofire
import AlamofireImage
import AlwaysRespectful
import os
struct CloudStorage {
    static let storageRef = Storage.storage().reference()
    static let db = Firestore.firestore()
    static var subscriptions = Set<AnyCancellable>()
    
    
    
    struct Students {
        static let collection = db.collection("students")
        
        
        static func startLocate() {
                   os_log("*** startLocate", log: OSLog.default, type: .default)
                   let manager = LocationDelegate.shared.manager
                   manager.showsBackgroundLocationIndicator = true
                   manager.allowsBackgroundLocationUpdates = true
                   manager.startMonitoringSignificantLocationChanges()
                   manager.startUpdatingLocation()
               }

               static func stopLocate() {
                   os_log("*** stopLocate", log: OSLog.default, type: .default)
                   let manager = LocationDelegate.shared.manager
                   manager.stopUpdatingLocation()
                   manager.stopMonitoringSignificantLocationChanges()
                   manager.allowsBackgroundLocationUpdates = false
                   manager.showsBackgroundLocationIndicator = false
               }

        
        static func synchronize() {
            collection.whereField("inside", isEqualTo: true)
                .addSnapshotListener { (snapshot, error) in
                    switch error {
                    case .some(let error): print(error.localizedDescription); return
                    case .none: break
                    }
                    
                    guard let snapshot = snapshot else { return }
                    
                    let futureStudents = snapshot.documents
                        .map(Student.extract)
                    
                    Publishers.MergeMany(futureStudents)
                        .catch({ (error) -> AnyPublisher<Student?, Never> in
                            print(error.localizedDescription)
                            return Just(nil).eraseToAnyPublisher()
                        })
                        .compactMap({ $0 })
                        .collect()
                        .assign(to: \.students, on: ObservableModel.shared)
                        .store(in: &subscriptions)
            }
            
            if let email = ObservableModel.shared.emailStudent {
                getInside(login: email)
                    .catch({ (error) -> AnyPublisher<Bool, Never> in
                        print(error.localizedDescription)
                        return Just(false).eraseToAnyPublisher()
                    })
                    .assign(to: \.inside, on: ObservableModel.shared)
                    .store(in: &subscriptions)
            }
            
            
                let cupertinoBridge = AnyLocation(
                    latitude: 37.334333,
                    longitude: -122.041456
                )
                let bridgeRegion = Region.circle(cupertinoBridge, 150.0)
                let insideBridge = AnyPositionPredicate(.inside, bridgeRegion)
                let outsideBridge = AnyPositionPredicate(.outside, bridgeRegion)

                os_log("AlwaysRespectful Hello", log: OSLog.default, type: .default)
                
            LocationDelegate.shared.requestAlwaysAuthorization()

            AlwaysRespectful.monitor(elements: [insideBridge, outsideBridge])
                    .sink(receiveCompletion: { (completion) in
                        switch completion {
                        case .finished: break
                        case .failure(let error): os_log("%s", log: OSLog.default, type: .error, error.localizedDescription)
                        }
                    }, receiveValue: { (element) in
                        os_log("*** receiveValue: %s", log: OSLog.default, type: .default, element.description)
                        let model = ObservableModel.shared
                        if element.position == .inside {
                            startLocate()
                            model.inside = true
                            if let login = model.emailStudent {
                             set(inside: true, login: login)
                            }
                        } else {
                            stopLocate()
                            model.inside = false
                            if let login = model.emailStudent {
                             set(inside: false, login: login)
                            }
                        }
                    })
                    .store(in: &subscriptions)
        }
        
        
        static func add(student: Student) -> AnyPublisher<Void, Error> {
            
            func addStudent(url: URL) -> Future<Void, Error> {
                Future { (promise) in
                    let reference = collection.document(student.login)
                    
                    reference.setData([
                        "name": student.name,
                        "login": student.login,
                        "image": url.absoluteString
                        ], completion: { (error) in
                            switch error {
                            case .some(let error): promise(.failure(error))
                            case .none: promise(.success(()))
                            }
                    })
                }
            }
            
            return Images.upload(image: student.image, with: student.login)
                .flatMap(addStudent)
                .eraseToAnyPublisher()
        }
        
        
        static func set(student: Student) -> AnyPublisher<Void, Error> {
            
            let reference = collection.document(student.login)

            func deleteImage() -> Future<Void, Error> {
                Images.delete(login: student.login)
            }
            
            func uploadImage() -> Future<URL, Error> {
                Images.upload(image: student.image, with: student.login)
            }
            
            func getStudent() -> Future<Bool, Error> {
                Future { (promise) in
                    
                    reference.getDocument { (document, error) in
                        switch error {
                        case .some(let error): promise(.failure(error))
                        case .none: break
                        }
                            
                        switch  document {
                        case .some(let document): promise(.success(document.exists))
                        case .none: promise(.success(false))
                        }
                    }
                }
            }
            
            func setStudent(url: URL) -> Future<Void, Error> {
                Future { (promise) in
                    
                    reference.setData([
                        "name": student.name,
                        "login": student.login,
                        "image": url.absoluteString
                        ], completion: { (error) in
                            switch error {
                            case .some(let error): promise(.failure(error))
                            case .none: promise(.success(()))
                            }
                    })
                }
            }
            
            let studentExists = getStudent()
            
            let existingStudent = studentExists
                .filter({ $0 })
                .map({ _ in })
                .flatMap(deleteImage)
            
            let newStudent = studentExists
                .filter({ !$0 })
                .map({ _ in })

            return Publishers.Merge(existingStudent, newStudent)
                .flatMap(uploadImage)
                .flatMap(setStudent)
                .eraseToAnyPublisher()
        }
        
        
        static func set(inside: Bool, login: String) {
            let reference = collection.document(login)
            reference.setData([ "inside": inside ], merge: true)
        }
        
        
        static func getInside(login: String) -> Future<Bool, Error> {
            Future { (promise) in
                collection.document(login).getDocument { (document, error) in
                    switch error {
                    case .some(let error): promise(.failure(error))
                    case .none: break
                    }
                        
                    switch  document?.data() {
                    case .some(let data):
                        switch data["inside"] as? Bool {
                        case .some(let inside): promise(.success(inside))
                        case .none: promise(.success(false))
                        }

                    case .none: promise(.success(false))
                    }
                }
            }
        }
    }
    
    
    struct Images {
        static let storageRef = CloudStorage.storageRef.child("images")
        
        static func upload(image: UIImage, with name: String) -> Future<URL, Error> {
            Future { (promise) in
                guard let uploadData = image.pngData() else {
                    promise(.failure(StudentError.cannotCreatePNG)); return
                }
                
                let imageRef = storageRef.child(name)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/png"
                
                imageRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                    
                    switch (error) {
                    case .some(let error): promise(.failure(error))
                    case .none: break
                    }
                    
                    //                if let error = error {
                    //                    promise(.failure(error))
                    //                }
                    
                    _ = imageRef.downloadURL(completion: { (url, error) in
                        switch (error) {
                        case .some(let error): promise(.failure(error))
                        case .none: break
                        }
                        
                        switch (url) {
                        case .some(let url): promise(.success(url))
                        case .none: promise(.failure(StudentError.noUploadURL))
                        }
                    })
                }
            }
        }
        
        static func get(url: String) -> Future<Image, Error> {
            Future { (promise) in
                Alamofire.request(url).responseImage { (response) in
                    switch response.result {
                    case .success(let image): promise(.success(image))
                    case .failure(let error): promise(.failure(error))
                    }
                }
            }
        }
        
        static func delete(login: String) -> Future<Void, Error> {
            Future { (promise) in
                let imageRef = storageRef.child(login)
                
                imageRef.delete { (error) in
                    switch (error) {
                    case .some(let error): promise(.failure(error))
                    case .none: promise(.success(()))
                    }
                }
            }
        }
    }
}
