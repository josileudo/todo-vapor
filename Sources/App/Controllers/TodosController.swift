//
//  File.swift
//  
//
//  Created by Josileudo on 07/09/24.
//

import Foundation
import Vapor
import Fluent
import FluentMongoDriver

struct TodosController: RouteCollection {
    func boot (routes: RoutesBuilder) throws {
        let api = routes.grouped("api" , "todos")
        
        // POST: /api/todos
        api.post("todos", use: createTodo)
        // GET: /api/todos
        api.get("todos", use: getAll)
        // GET: /api/todos/:todoId
        api.get("todos", ":todoId", use: getById)
        // DELETE: /api/todos/:todoId
        api.delete("todos", ":todoId", use: deleteTodo)
        // PUT: /api/todos/:todoId
        api.put("todos", ":todoId", use: updateTodo)
    }
    
    @Sendable func getAll(req: Request) async throws -> [Todo] {
        return try await Todo.query(on: req.db).all()
    }
    
    @Sendable func getById(req: Request) async throws -> Todo {
        guard let todoId = req.parameters.get("todoId", as: UUID.self) else {
            throw Abort(.notFound)
        }
        
        guard let todo = try await Todo.find(todoId, on: req.db) else {
            throw Abort(.notFound, reason: "TodoId \(todoId) was not found.")
        }
        
        return todo
    }
    
    @Sendable func createTodo(req: Request) async throws -> Todo {
        let todo = try req.content.decode(Todo.self)
        try await todo.save(on: req.db)
        return todo
    }
    
    @Sendable func deleteTodo(req: Request) async throws -> Todo {
        guard let todoId = req.parameters.get("todoId", as: UUID.self) else {
            throw Abort(.notFound)
        }
        
        guard let todo = try await Todo.find(todoId, on: req.db) else {
            throw Abort(.notFound, reason: "TodoID \(todoId) war not found.")
        }
        
        try await todo.delete(on: req.db)
        
        return todo
    }
    
    @Sendable func updateTodo(req: Request) async throws -> Todo {
        guard let todoId = req.parameters.get("todoId", as: UUID.self) else {
            throw Abort(.notFound)
        }
        guard let todo = try await Todo.find(todoId, on: req.db) else {
            throw Abort(.notFound, reason: "TodoId \(todoId) was not found")
        }
        
        let updateTodo = try req.content.decode(Todo.self)
        todo.description = updateTodo.description
        todo.checked = updateTodo.checked
        
        try await todo.update(on: req.db)
        
        return todo
    }
}
