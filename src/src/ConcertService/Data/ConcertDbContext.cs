using Microsoft.EntityFrameworkCore;
using ConcertService.Models;

namespace ConcertService.Data
{
    public class ConcertDbContext : DbContext
    {
        public ConcertDbContext(DbContextOptions<ConcertDbContext> options)
            : base(options)
        {
        }

        public DbSet<Concert> Concerts { get; set; }
        // Add other DbSets as needed

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Concert>().HasData(
                new Concert
                {
                    Id = "1",
                    Artist = "The Rolling Codes",
                    Date = new DateTime(2026, 2, 15),
                    TotalSeats = 5000,
                    AvailableSeats = 5000
                },
                new Concert
                {
                    Id = "2",
                    Artist = "Null Pointer Exception",
                    Date = new DateTime(2026, 3, 10),
                    TotalSeats = 3000,
                    AvailableSeats = 3000
                }
            );
        }
    }
}
