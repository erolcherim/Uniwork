using ClinicaAPI.DAL.Entities;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ClinicaAPI.DAL.Models;
using ClinicaAPI.Repositories.GenericRepository;

namespace ClinicaAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ClientOfferLocationController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IClientOfferLocationRepository _repository;
        public ClientOfferLocationController(AppDbContext context, IClientOfferLocationRepository repository)
        {
            _context = context;
            _repository = repository;
        }

        [HttpPost("create-new-sale")] 
        public async Task<ActionResult> CreateClientOfferLocation(ClientOfferLocationModel model)
        {
            var clientOfferLocation = new ClientOfferLocation()
            {
                ClientId = model.ClientId,
                OfferId = model.OfferId,
                LocationId = model.LocationId
            };
        await _context.Sales.AddAsync(clientOfferLocation);
        await _context.SaveChangesAsync();
            return Ok();
        }
        [HttpGet("get-all-sales")]
        public async Task<ActionResult> GetAllSales()
        {
            var sales = await _repository.GetSalesAsync();
            return Ok(sales);
        }
    }
}
