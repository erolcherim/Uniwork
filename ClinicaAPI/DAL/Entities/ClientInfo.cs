using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.DAL.Entities
{
    public class ClientInfo
    {
        public int ClientInfoId { get; set; }
        public string DateOfBirth { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public string Gender { get; set; }
        public int ClientId { get; set; }
        public virtual Client Client { get; set; }
    }
}
