using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace DevOpsABCs.Function
{
    public class HttpExample
    {
        private readonly ILogger<HttpExample> _logger;

        public HttpExample(ILogger<HttpExample> logger)
        {
            _logger = logger;
        }

        [Function("HttpExample")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            // Get version from Assembly
            var version = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString();

            // Get the name parameter from the query string or request body
            string name = req.Query["name"].FirstOrDefault() ?? "Anonymous Person";

            if (name == "Anonymous Person")
                return new BadRequestObjectResult($"Welcome to Azure Functions, {name}! (version: {version}). Please provide a name query parameter next time!");

            return new OkObjectResult($"Welcome to Azure Functions, {name}! (version: {version})");
        }
    }
}
