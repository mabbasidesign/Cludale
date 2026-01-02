
using System.Collections.Concurrent;
using ConcertService.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}




// In-memory store for demo purposes
var concerts = new ConcurrentDictionary<string, Concert>();

// Seed data
var seedConcerts = new[]
{
    new Concert
    {
        Id = "concert-1",
        Artist = "The Rolling Codes",
        Date = DateTime.Now.AddDays(10),
        TotalSeats = 100,
        AvailableSeats = 100
    },
    new Concert
    {
        Id = "concert-2",
        Artist = "Null Pointer Exceptionals",
        Date = DateTime.Now.AddDays(20),
        TotalSeats = 150,
        AvailableSeats = 150
    },
    new Concert
    {
        Id = "concert-3",
        Artist = "Async Awaiters",
        Date = DateTime.Now.AddDays(30),
        TotalSeats = 200,
        AvailableSeats = 200
    }
};
foreach (var concert in seedConcerts)
{
    concerts[concert.Id] = concert;
}

// GET /concerts
app.MapGet("/concerts", () => Results.Ok(concerts.Values))
    .WithName("GetConcerts")
    .WithOpenApi();

// GET /concerts/{id}
app.MapGet("/concerts/{id}", (string id) =>
{
    if (concerts.TryGetValue(id, out var concert))
        return Results.Ok(concert);
    return Results.NotFound();
})
    .WithName("GetConcertById")
    .WithOpenApi();

// POST /concerts
app.MapPost("/concerts", (ConcertCreateRequest req) =>
{
    var id = $"concert-{Guid.NewGuid()}";
    var concert = new Concert
    {
        Id = id,
        Artist = req.Artist,
        Date = req.Date,
        TotalSeats = req.TotalSeats,
        AvailableSeats = req.TotalSeats
    };
    concerts[id] = concert;
    return Results.Created($"/concerts/{id}", concert);
})
    .WithName("CreateConcert")
    .WithOpenApi();

// POST /concerts/{id}/reserve
app.MapPost("/concerts/{id}/reserve", (string id, SeatReservationRequest req) =>
{
    if (!concerts.TryGetValue(id, out var concert))
        return Results.NotFound();
    if (req.Quantity <= 0)
        return Results.BadRequest("Quantity must be positive.");
    if (concert.AvailableSeats < req.Quantity)
        return Results.BadRequest("Not enough seats available.");
    concert.AvailableSeats -= req.Quantity;
    concerts[id] = concert;
    // Here you would publish a SeatsReserved event
    return Results.Ok(concert);
})
    .WithName("ReserveSeats")
    .WithOpenApi();


app.Run();


