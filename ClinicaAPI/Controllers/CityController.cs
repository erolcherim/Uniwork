using ClinicaAPI.DAL.Entities;
using ClinicaAPI.DAL.Models;
using ClinicaAPI.Repositories.CityRepository;
using ClinicaAPI.Repositories.GenericRepository;
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
    public class CityController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly ICityRepository _repository;
        public CityController(AppDbContext context, ICityRepository repository)
        {
            _context = context;
            _repository = repository;
        }
        [HttpPost("new-city")]
        public async Task<IActionResult> CreateCity(CityModel model)
        {
            var city = new City()
            {
                Name = model.Name
            };
            await _context.Cities.AddAsync(city);
            await _context.SaveChangesAsync();
            return Ok();
        }
        [HttpGet("get-by-id")]
        public async Task<IActionResult> GetCityById(int id)
        {
            var city = await _repository.GetByIdAsync(id);
            return Ok(city);
        }
        [HttpGet("get-all")]
        public async Task<IActionResult> GetAllCities()
        {
            var cities = await _repository.GetCitiesAsync();
            return Ok(cities);
        }
        [HttpPut("edit-city")]
        public async Task<IActionResult> EditCity(int id, CityModel model)
        {
            var city = await _repository.GetByIdAsync(id);

            if (city is null)
            {
                return BadRequest($"The city with id {id} does not exist");
            }

            city.Name = model.Name;
            await _context.SaveChangesAsync();

            return Ok();
        }
        [HttpDelete("delete-city")]
        public async Task<IActionResult> DeleteCity(int id)
        {
            var city = await _context.Cities.FirstOrDefaultAsync(city => city.CityId == id);
            _context.Cities.Remove(city);
            await _context.SaveChangesAsync();

            return Ok();
        }
    }
}
