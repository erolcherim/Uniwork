﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Text;

namespace ClinicaAPI.DAL.Models.User
{
    public class UserAuthenticatedModel
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public List<string> Roles { get; set; }
        public List<string> Permissions { get; set; }
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
    }
}
