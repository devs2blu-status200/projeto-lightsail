using Microsoft.EntityFrameworkCore;
using VisitorApp.Models;

namespace SeuNameSpace
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }
        public DbSet<Visitor> Visitors { get; set; }
        // ... outras entidades

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Configurações de mapeamento e relacionamentos
        }
    }
}
