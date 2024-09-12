//
//  File.swift
//  
//
//  Created by Josileudo on 10/09/24.
//

import Foundation
import Fluent
import Vapor

struct CreateUserTableMigration: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("users")
            .id()
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "email")
            .create()
        
    }

    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("users")
            .delete()
    }
}
