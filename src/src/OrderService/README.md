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

## Running OrderService in Docker

1. Build the Docker image:
   ```sh
   docker build -t orderservice .
   ```
2. Run the container (replace <SQL_CONNECTION_STRING> as needed):
   ```sh
   docker run -e ConnectionStrings__DefaultConnection="<SQL_CONNECTION_STRING>" -p 8080:8080 orderservice
   ```

- The service will be available at http://localhost:8080
- Ensure your SQL Server is accessible from the container (use host.docker.internal for localdb, or a network-accessible SQL Server instance).
