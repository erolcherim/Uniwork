using ClinicaAPI.DAL.Entities;
using ClinicaAPI.DAL.Models;
using ClinicaAPI.Repositories.LocationRepository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ClinicaAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LocationController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly ILocationRepository _repository;
        public LocationController(AppDbContext context, ILocationRepository repository)
        {
            _context = context;
            _repository = repository;
        }
        [HttpPost("add-new-location")]
        public async Task<ActionResult> Location(LocationModel model)
        {
            var location = new Location()
            {
                Name = model.Name,
                ZipCode = model.ZipCode,
                CityId = model.CityId
            };
            await _context.Locations.AddAsync(location);
            await _context.SaveChangesAsync();
            return Ok();
        }
        [HttpGet("get-join-by-id")]
        public async Task<IActionResult> GetLocationsByCity(int id)
        {
            var location = await _context
                .Locations
                .Include(x => x.City)
                .Where(x => x.City.CityId == id)
                .Select(x => x.Name)
                .ToListAsync();
            return Ok(location);
        }
        [HttpGet("get-all")]
        public async Task<IActionResult> GetAllLocations()
        {
            var locations = await _repository.GetLocationsAsync();
            return Ok(locations);
        }
        [HttpPut]
        public async Task<IActionResult> Location(int id, LocationModel model)
        {
            var location = await _repository.GetByIdAsync(id);

            if (location is null)
            {
                return BadRequest($"The location with id {id} does not exist");
            }

            location.Name = model.Name;
            location.ZipCode = model.ZipCode;
            location.CityId = model.CityId;

            await _context.SaveChangesAsync();

            return Ok();
        }
        [HttpDelete("delete-location")]
        public async Task<IActionResult> DeleteLocation(int id)
        {
            var location = await _context.Locations.FirstOrDefaultAsync(location => location.LocationId == id);
            _context.Locations.Remove(location);
            await _context.SaveChangesAsync();

            return Ok();
        }
    }
}
