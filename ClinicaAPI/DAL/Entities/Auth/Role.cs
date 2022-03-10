using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using System.Text;

namespace ClinicaAPI.DAL.Entities.Auth
{
    public class Role : IdentityRole<int>
    {
        public Role() { }
        public Role(string roleName) : base(roleName) { } 
    }
}
