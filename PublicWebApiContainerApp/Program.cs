using Dapr.Client;
using System.Reflection;

namespace PublicWebApiContainerApp;

public static class Program
{
    public static void Main(string[] args)
    {
        WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

        IServiceCollection services = builder.Services;

        // Add services to the container
        {
            services.AddProblemDetails();

            services.AddDaprClient();

            //services.AddSingleton(DaprClient.CreateInvokeHttpClient("echo-server"));

            services.AddEndpointsApiExplorer()
                .AddSwaggerGen();
        }

        WebApplication app = builder.Build();

        // Configure the HTTP request pipeline
        {
            app.UseSwagger();
            app.UseSwaggerUI();

            app.UseDeveloperExceptionPage();

            app.MapGet("/", () => TypedResults.Redirect("/swagger"));

            app.MapGet("/version", () => $"Current version: {Assembly.GetExecutingAssembly().GetName().Version?.FormatVersion(2, 3)}");

            app.MapGet("/say-hello/{name}", sayHello);
        }

        app.Run();
    }

    private static async Task<IResult> sayHello(string name, DaprClient daprClient)
    {
        SayHelloResponse response = await daprClient.InvokeMethodAsync<SayHelloRequest, SayHelloResponse>(
                HttpMethod.Post, "echo-server", "say-hello", new SayHelloRequest(name));

        return TypedResults.Ok(response.Json);
    }
}

public readonly record struct SayHelloRequest(string Name);

public sealed class SayHelloResponse
{
    public SayHelloRequest Json { get; set; }
}
