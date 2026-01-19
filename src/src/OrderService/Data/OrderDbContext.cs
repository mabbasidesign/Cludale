using Microsoft.EntityFrameworkCore;
using OrderService.Models;

namespace OrderService.Data
{
    public class OrderDbContext : DbContext
    {
        public OrderDbContext(DbContextOptions<OrderDbContext> options)
            : base(options)
        {
        }

        public DbSet<Order> Orders { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Order>().HasData(
                new Order
                {
                    Id = 1,
                    CustomerName = "Alice",
                    CreatedAt = new DateTime(2026, 1, 19),
                    Status = "Pending"
                },
                new Order
                {
                    Id = 2,
                    CustomerName = "Bob",
                    CreatedAt = new DateTime(2026, 1, 18),
                    Status = "Paid"
                }
            );
        }
    }
}
