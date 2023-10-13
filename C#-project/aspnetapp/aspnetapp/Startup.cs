using Microsoft.EntityFrameworkCore;
using aspnetapp.Data;


namespace aspnetapp
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        DotEnv.Load(); // Carregue as variáveis de ambiente do arquivo .env

            // Obtenha as variáveis de ambiente
            string dbHost = DotEnv.Get("DB_HOST");
            string dbName = DotEnv.Get("DB_NAME");
            string dbUser = DotEnv.Get("DB_USER");
            string dbPassword = DotEnv.Get("DB_PASSWORD");

        options.UseMySQL(connectionString); // UseMySql instead of UseMySQL
        

            // Other service configurations
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            // Configuration for the request/response pipeline
        }
    }
}
