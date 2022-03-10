using ClinicaAPI.DAL.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.DAL.DTO
{
    public class OfferDTO
    {
        public int OfferId { get; set; }
        public string Name { get; set; }
        public int Price { get; set; }
        public int ReturnTime { get; set; }
        public List<ClientOfferLocation> ClientOfferLocations { get; set; }

        public OfferDTO(Offer offer)
        {
            this.OfferId = offer.OfferId;
            this.Name = offer.Name;
            this.Price = offer.Price;
            this.ReturnTime = offer.ReturnTime;
            this.ClientOfferLocations = new List<ClientOfferLocation>();
        }
    }
}
