using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using aspnetapp.Models;
using aspnetapp.Data;
using Microsoft.EntityFrameworkCore;

namespace aspnetapp.Controllers;

public class HomeController : Controller
{
    private readonly AppDbContext _dbContext; 

    public HomeController(AppDbContext DbContext)
    {
        _dbContext = DbContext;
    }

    public IActionResult Index()
    {
        // Count visitors
        int visitorCount = _dbContext.Visitors.Count();

        // Show connected databases (if needed)
        var databaseNames = _dbContext.Database.GetDbConnection().DataSource;

        ViewBag.VisitorCount = visitorCount;
        ViewBag.DatabaseNames = databaseNames;
        
        return View();
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
