using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.DAL.Models
{
    public class ClientOfferLocationModel
    {
        public int ClientId { get; set; }
        public int OfferId { get; set; }
        public int LocationId { get; set; }
    }
}
