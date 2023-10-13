using aspnetapp;
using aspnetapp.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

var root = Directory.GetCurrentDirectory();
var dotenv = Path.Combine(root, ".env");
DotEnv.Load(dotenv);

var dbName = builder.Configuration["DB_NAME:ConnectionString"] = Environment.GetEnvironmentVariable("DB_NAME");
var dbHost = builder.Configuration["DB_HOST:ConnectionString"] = Environment.GetEnvironmentVariable("DB_HOST");
var dbPort = builder.Configuration["DB_PORT:ConnectionString"] = Environment.GetEnvironmentVariable("DB_PORT");
var dbPassword = builder.Configuration["DB_PASSWORD:ConnectionString"] = Environment.GetEnvironmentVariable("DB_PASSWORD");

// string connectionString = $"Server={host};Database={database};User={user};Password={password}";

var connectionString = $"server={dbHost};port={dbPort};database={dbName};user=root;password={dbPassword}";

// builder.Services.AddDbContext<AppDbContext>(o => o.UseMySql(connectionString));

builder.Services.AddDbContext<AppDbContext>(o => o.UseMySQL(connectionString));

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddHealthChecks();

var app = builder.Build();
app.MapHealthChecks("/healthz");


        

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");


CancellationTokenSource cancellation = new();
app.Lifetime.ApplicationStopping.Register( () =>
{
    cancellation.Cancel();
});

app.MapGet("/Environment", () =>
{
    return new EnvironmentInfo();
});

// This API demonstrates how to use task cancellation
// to support graceful container shutdown via SIGTERM.
// The method itself is an example and not useful.
app.MapGet("/Delay/{value}", async (int value) =>
{
    try
    {
        await Task.Delay(value, cancellation.Token);
    }
    catch(TaskCanceledException)
    {
    }
    
    return new {Delay = value};
});

app.Run();