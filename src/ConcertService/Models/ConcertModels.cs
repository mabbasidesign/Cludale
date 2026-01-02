using System.ComponentModel.DataAnnotations;

namespace ConcertService.Models
{
    public class Concert
    {
        public string Id { get; set; } = default!;
        public string Artist { get; set; } = default!;
        public DateTime Date { get; set; }
        public int TotalSeats { get; set; }
        public int AvailableSeats { get; set; }
    }

    public class ConcertCreateRequest
    {
        [Required]
        public string Artist { get; set; } = default!;
        [Required]
        public DateTime Date { get; set; }
        [Range(1, int.MaxValue)]
        public int TotalSeats { get; set; }
    }

    public class SeatReservationRequest
    {
        [Range(1, int.MaxValue)]
        public int Quantity { get; set; }
    }
}
