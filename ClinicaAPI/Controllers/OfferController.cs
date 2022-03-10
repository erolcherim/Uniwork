using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ClinicaAPI.Repositories.OfferRepository;
using ClinicaAPI.DAL.Entities;
using ClinicaAPI.DAL.DTO;
using Microsoft.EntityFrameworkCore;

namespace ClinicaAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OfferController : ControllerBase
    {
        private readonly IOfferRepository _repository;
        private readonly AppDbContext _context;

        public OfferController(AppDbContext context, IOfferRepository repository)
        {
            _repository = repository;
            _context = context;
        }
        [HttpPost("new-offer")]
        public async Task<IActionResult> CreateOffer(CreateOfferDTO dto)
        {
            Offer newOffer = new Offer();

            newOffer.Name = dto.Name;
            newOffer.Price = dto.Price;
            newOffer.ReturnTime = dto.ReturnTime;

            _repository.Create(newOffer);

            await _repository.SaveAsync();
            return Ok(new OfferDTO(newOffer));
        }
        [HttpGet("get-all")]
        public async Task<IActionResult> GetAllOffers()
        {
            var offers = await _repository.GetOffersAsync();
            return Ok(offers);
        }
        [HttpGet("get-by-id")]
        public async Task<IActionResult> GetOfferById(int id)
        {
            var offer = await _repository.GetByIdAsync(id);
            return Ok(offer);
        }
        [HttpPut]
        public async Task<IActionResult> EditOffer(int id, CreateOfferDTO dto)
        {
            var offer = await _repository.GetByIdAsync(id);

            if (offer is null)
            {
                return BadRequest($"The offer with id {id} does not exist");
            }

            offer.Name = dto.Name;
            offer.Price = dto.Price;
            offer.ReturnTime = dto.ReturnTime;

            await _context.SaveChangesAsync();

            return Ok();
        }

        [HttpDelete]
        public async Task<IActionResult> DeleteOffer(int id)
        {
            var offer = await _repository.GetByIdAsync(id);

            if (offer is null)
            {
                return BadRequest($"The offer with id {id} does not exist");
            }
            
            _repository.Delete(offer);
            await _repository.SaveAsync();

            return Ok();
        }

        [HttpGet("get-orderby")]
        public async Task<IActionResult> GetOfferOrderByPrice()
        {
            var offer = await _context
                .Offers
                .Where(x => x.Price > 0)
                .OrderByDescending(x => x.Price)
                .Select(x => x.Name)
                .ToListAsync();

            return Ok(offer);
        }

        
    }

}
