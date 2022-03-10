using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.DAL.Entities
{
    public class ClientOfferLocation
    {
        public int ClientId { get; set; }
        public Client Client { get; set; }
        public int OfferId { get; set; }
        public Offer Offer { get; set; }
        public int LocationId { get; set; }
        public Location Location { get; set; }
        
    }
}
