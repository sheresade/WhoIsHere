//
//  StudenPosition.swift
//  WhoisHere
//
//  Created by carolyne on 07/02/2020.
//  Copyright © 2020 carolyne. All rights reserved.
//

import Foundation

import Firebase

struct StudentPosition {
  
  let ref: DatabaseReference?
  let key: String
  let name: String
  let login: String
  var inside: Bool
  
  init(name: String, login: String, inside: Bool, key: String = "") {
    self.ref = nil
    self.key = key
    self.name = name
    self.login = login
    self.inside = inside
    
  }
  
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let name = value["name"] as? String,
      let login = value["login"] as? String,
      let inside = value["inside"] as? Bool else {
      return nil
    }
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.name = name
    self.login = login
    self.inside = inside
  }
  
  func toAnyObject() -> Any {
    return [
      "name": name,
      "login": login,
      "inside": inside
    ]
  }
}
