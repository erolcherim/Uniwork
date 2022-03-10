using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.DAL.Entities
{
    public class Client
    {
        public int ClientID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public virtual ClientInfo Info { get; set; }
        public ICollection<ClientOfferLocation> ClientOfferLocation { get; set; }
    }
}
