# Use the official .NET SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY src/src/OrderService/OrderService.csproj ./
RUN dotnet restore OrderService.csproj

# Copy the rest of the source code
COPY src/src/OrderService/ ./

# Build the application
RUN dotnet publish -c Release -o out

# Use the official ASP.NET runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Expose port 8080 for the app
EXPOSE 8080

# Set the entrypoint
ENTRYPOINT ["dotnet", "OrderService.dll"]
