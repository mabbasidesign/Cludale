
using ConcertService.Data;
using ConcertService.Models;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);



// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Register DbContext with connection string
builder.Services.AddDbContext<ConcertDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();

// Configure the HTTP request pipeline.

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// ...existing code...

// Minimal API endpoints for Concert
app.MapGet("/api/concerts", async (ConcertDbContext db) =>
    await db.Concerts.ToListAsync()
);

app.MapGet("/api/concerts/{id}", async (string id, ConcertDbContext db) =>
    await db.Concerts.FindAsync(id) is Concert concert ? Results.Ok(concert) : Results.NotFound()
);

app.MapPost("/api/concerts", async (ConcertCreateRequest request, ConcertDbContext db) =>
{
    var concert = new Concert
    {
        Id = Guid.NewGuid().ToString(),
        Artist = request.Artist,
        Date = request.Date,
        TotalSeats = request.TotalSeats,
        AvailableSeats = request.TotalSeats
    };
    db.Concerts.Add(concert);
    await db.SaveChangesAsync();
    return Results.Created($"/api/concerts/{concert.Id}", concert);
});

app.MapPut("/api/concerts/{id}", async (string id, ConcertCreateRequest request, ConcertDbContext db) =>
{
    var concert = await db.Concerts.FindAsync(id);
    if (concert is null) return Results.NotFound();
    concert.Artist = request.Artist;
    concert.Date = request.Date;
    concert.TotalSeats = request.TotalSeats;
    concert.AvailableSeats = request.TotalSeats; // Optionally update available seats
    await db.SaveChangesAsync();
    return Results.NoContent();
});

app.MapDelete("/api/concerts/{id}", async (string id, ConcertDbContext db) =>
{
    var concert = await db.Concerts.FindAsync(id);
    if (concert is null) return Results.NotFound();
    db.Concerts.Remove(concert);
    await db.SaveChangesAsync();
    return Results.NoContent();
});
app.Run();
