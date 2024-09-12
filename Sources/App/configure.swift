import Vapor
import Fluent
import FluentMongoDriver

// configures your application
public func configure(_ app: Application) async throws {
    // migrations configurations
    app.migrations.add(CreateUserTableMigration())
    
    // database configuration
    try app.databases.use(.mongo(
        connectionString: "mongodb+srv://Username123:Password123$@todo.eoxtf.mongodb.net/toDO?retryWrites=true&w=majority&appName=ToDO"
    ), as: .mongo)
    
    // register controllers
    try app.register(collection: TodosController())
    
    // register routes
    try routes(app)
}
