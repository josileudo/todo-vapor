//
//  File.swift
//  
//
//  Created by Josileudo on 07/09/24.
//

import Foundation
import Fluent
import Vapor

final class Todo: Model, Content {
    static let schema: String = "todos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "checked")
    var checked: Bool
    
    init() {}
    
    init(id: UUID? = nil, description: String, checked: Bool) {
        self.id = id
        self.description = description
        self.checked = checked
    }
}
