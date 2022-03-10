using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.DAL.Models
{
    public class LocationModel
    {
        public string Name { get; set; }
        public string ZipCode { get; set; }
        public int CityId { get; set; }
    }
}
