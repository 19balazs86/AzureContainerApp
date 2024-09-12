using Dapr.Client;
using System.Reflection;

namespace WebApi;

public static class Program
{
    private const string _echoServerName = "echo-server";

    public static void Main(string[] args)
    {
        WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

        IServiceCollection services = builder.Services;

        // Add services to the container
        {
            services.AddProblemDetails();

            // services.AddDaprClient();

            services.AddKeyedSingleton(_echoServerName, DaprClient.CreateInvokeHttpClient(_echoServerName));

            services.AddEndpointsApiExplorer();

            services.AddSwaggerGen();
        }

        WebApplication app = builder.Build();

        // Configure the HTTP request pipeline
        {
            app.UseSwagger();
            app.UseSwaggerUI();

            app.UseDeveloperExceptionPage();

            app.MapGet("/", () => TypedResults.Redirect("/swagger"));

            app.MapGet("/version", () => $"Current version: {Assembly.GetExecutingAssembly().GetName().Version?.FormatVersion(2, 4)}");

            app.MapGet("/say-hello/{name}", sayHello);
        }

        app.Run();
    }

    private static async Task sayHello(string name, HttpContext httpContext, [FromKeyedServices(_echoServerName)] HttpClient httpClient)
    {
        using HttpResponseMessage response = await httpClient.PostAsJsonAsync("/say-hello", new SayHelloRequest(name));

        await response.Content.CopyToAsync(httpContext.Response.Body);
    }
}

public readonly record struct SayHelloRequest(string Name);