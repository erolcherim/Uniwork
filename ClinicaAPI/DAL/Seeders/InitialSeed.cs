using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClinicaAPI.DAL.Entities.Auth;
using ClinicaAPI.DAL.Enums;
using Microsoft.AspNetCore.Identity;

namespace ClinicaAPI.DAL.Seeders
{
    public class InitialSeed
    {
        private readonly RoleManager<Role> _roleManager;
        private readonly AppDbContext _context;
        public InitialSeed(RoleManager<Role> roleManager, AppDbContext context)
        {
            _roleManager = roleManager;
            _context = context;
        }
        public async void SeedRoles()
        {
            if (_context.Roles.Any())
            {
                return;
            }

            var roles = Enum.GetValues(typeof(RolesEnum));

            foreach (var role in roles)
            {
                var roleName = Enum.GetName(typeof(RolesEnum), role);
                var roleToAdd = new Role(roleName);
                _roleManager.CreateAsync(roleToAdd).Wait();
            }
        }
    }
}
