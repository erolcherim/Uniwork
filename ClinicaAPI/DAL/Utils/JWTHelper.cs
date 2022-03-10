using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using ClinicaAPI.DAL.Entities.Auth;

namespace ClinicaAPI.DAL.Utils
{
    public class JWTHelper
    {
        private readonly IConfiguration _configuration;

        public JWTHelper(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public string GenerateJwtToken(User user, List<string> roles, IList<Claim> claimsToAdd)
        {
            var claims = new List<Claim>()
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString())
            };

            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }

            if (claimsToAdd?.Count > 0)
            {
                claims.AddRange(claimsToAdd);
            }

            var tokenManagement = _configuration.GetSection("TokenManagement").Get<TokenManagement>();
            tokenManagement.Secret = _configuration.GetSection("TokenMangementSecret").Get<string>();

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(tokenManagement.Secret));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256Signature);

            var token = new JwtSecurityToken(
                tokenManagement.Issuer,
                tokenManagement.Audience,
                claims,
                DateTime.Now,
                DateTime.Now.AddHours(tokenManagement.AccessExpiration),
                creds);

            var tokenHandler = new JwtSecurityTokenHandler();
            return tokenHandler.WriteToken(token);
        }

        public string GenerateRefreshToken()
        {
            var randomNumber = new byte[32];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(randomNumber);
                return Convert.ToBase64String(randomNumber);
            }
        }
    }
}