using Microsoft.EntityFrameworkCore;
using SeuNameSpace;


namespace aspnetapp
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            string host = Environment.GetEnvironmentVariable("DB_HOST");
            string database = Environment.GetEnvironmentVariable("DB_NAME");
            string user = Environment.GetEnvironmentVariable("DB_USER");
            string password = Environment.GetEnvironmentVariable("DB_PASSWORD");

            string connectionString = $"Server={host};Database={database};User={user};Password={password}";

                services.AddDbContext<AppDbContext>(options =>
                {
                    options.UseMySQL(connectionString); // UseMySql instead of UseMySQL
        });

            // Other service configurations
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            // Configuration for the request/response pipeline
        }
    }
}
