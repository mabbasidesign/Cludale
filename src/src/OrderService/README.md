# OrderService

Minimal API for managing orders in Cludale.

## Stack
- .NET 8 Minimal API
- Entity Framework Core
- Swagger/OpenAPI

## Endpoints
- `GET /orders` – List all orders
- `POST /orders` – Create a new order

## EF Core
- Order model and DbContext defined in Program.cs
- Migrations directory included for schema management

## Configuration
- Set your Azure SQL connection string in `appsettings.json`

## Run
```
dotnet run --project src/src/OrderService/OrderService.csproj
```

## Swagger
- Available at `/swagger` in development mode
