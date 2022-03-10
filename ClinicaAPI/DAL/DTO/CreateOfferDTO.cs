using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.DAL.DTO
{
    public class CreateOfferDTO
    {
        public string Name { get; set; }
        public int Price { get; set; }
        public int ReturnTime { get; set; }
    }
}
