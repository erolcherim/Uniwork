using ClinicaAPI.DAL.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ClinicaAPI.DAL.Entities.Auth;

namespace ClinicaAPI
{
    public class AppDbContext : IdentityDbContext<
        User,
        Role,
        int,
        IdentityUserClaim<int>,
        UserRole,
        IdentityUserLogin<int>,
        IdentityRoleClaim<int>,
        IdentityUserToken<int>>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
        public DbSet<City> Cities { get; set; }
        public DbSet<Client> Clients { get; set; }
        public DbSet<Location> Locations { get; set; }
        public DbSet<ClientInfo> ClientInformation { get; set; }
        public DbSet<Offer> Offers { get; set; }
        public DbSet<ClientOfferLocation> Sales{ get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Client has ClientInfo (1:1)
            modelBuilder.Entity<Client>()
                .HasOne(c => c.Info)
                .WithOne(inf => inf.Client);
            //City has multiple Location (1:m)
            modelBuilder.Entity<City>()
                .HasMany(c => c.Locations)
                .WithOne(l => l.City);

            //multiple Client buy multiple Offer from multiple Location (m:m between three entities)
            modelBuilder.Entity<ClientOfferLocation>().HasKey(col => new { col.ClientId, col.OfferId, col.LocationId });
            
            modelBuilder.Entity<ClientOfferLocation>()
                .HasOne(col => col.Client)
                .WithMany(c => c.ClientOfferLocation)
                .HasForeignKey(col => col.ClientId);

            modelBuilder.Entity<ClientOfferLocation>()
                .HasOne(col => col.Location)
                .WithMany(l => l.ClientOfferLocation)
                .HasForeignKey(col => col.LocationId);

            modelBuilder.Entity<ClientOfferLocation>()
                .HasOne(col => col.Offer)
                .WithMany(o => o.ClientOfferLocation)
                .HasForeignKey(col => col.OfferId);

            base.OnModelCreating(modelBuilder);

        }
    }
}

