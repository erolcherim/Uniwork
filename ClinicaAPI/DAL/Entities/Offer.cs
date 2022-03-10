using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.DAL.Entities
{
    public class Offer
    {
        public int OfferId { get; set; }
        public string Name { get; set; }
        public int Price { get; set; }
        public int ReturnTime { get; set; }
        public ICollection<ClientOfferLocation> ClientOfferLocation { get; set; }
    }
}
