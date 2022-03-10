using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.DAL.Entities
{
    public class Location
    {
        public int LocationId { get; set; }
        public string Name { get; set; }
        public string ZipCode { get; set; }
        public int CityId { get; set; }
        public virtual City City { get; set; }
        public ICollection<ClientOfferLocation> ClientOfferLocation { get; set; }
    }
}
