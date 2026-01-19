using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using OrderService.Models;
using OrderService.Data;

var builder = WebApplication.CreateBuilder(args);

// Use SQL Server like ConcertService
builder.Services.AddDbContext<OrderDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Order API", Version = "v1" });
});

var app = builder.Build();

// Swagger
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}


// Minimal API endpoints
app.MapGet("/orders", async (OrderDbContext db) => await db.Orders.ToListAsync());

app.MapGet("/orders/{id}", async (int id, OrderDbContext db) =>
    await db.Orders.FindAsync(id) is Order order ? Results.Ok(order) : Results.NotFound()
);

app.MapPost("/orders", async (Order order, OrderDbContext db) =>
{
    db.Orders.Add(order);
    await db.SaveChangesAsync();
    return Results.Created($"/orders/{order.Id}", order);
});

app.MapPut("/orders/{id}", async (int id, Order updatedOrder, OrderDbContext db) =>
{
    var order = await db.Orders.FindAsync(id);
    if (order is null) return Results.NotFound();
    order.CustomerName = updatedOrder.CustomerName;
    order.Status = updatedOrder.Status;
    order.CreatedAt = updatedOrder.CreatedAt;
    await db.SaveChangesAsync();
    return Results.NoContent();
});

app.MapDelete("/orders/{id}", async (int id, OrderDbContext db) =>
{
    var order = await db.Orders.FindAsync(id);
    if (order is null) return Results.NotFound();
    db.Orders.Remove(order);
    await db.SaveChangesAsync();
    return Results.NoContent();
});

app.Run();

