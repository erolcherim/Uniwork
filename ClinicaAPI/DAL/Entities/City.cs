using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.DAL.Entities
{
    public class City
    {
        public int CityId { get; set; }
        public string Name { get; set; }
        public virtual ICollection<Location> Locations { get; set; }
    }
}
