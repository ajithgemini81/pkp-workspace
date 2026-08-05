using Microsoft.Extensions.DependencyInjection;
using System;

namespace SRP;

// THE FUEL: Pure short-lived data container. Kept out of the IoC container completely.
public class Invoice
{
    public int InvoiceNumber { get; set; }
    public decimal TotalAmount { get; set; }        
}

// THE TOOLS: Long-lived infrastructure services (Stateless -> Singletons)
public class InvoiceRepository
{
    public void SaveInvoice(Invoice invoice)
    {
        Console.WriteLine($"[Database] Saved: Invoice No: {invoice.InvoiceNumber} with Total Amount {invoice.TotalAmount:C}");
    }
}

public class NotificationService
{
    public void SendInvoiceGeneratedNotification(Invoice invoice)
    {
        Console.WriteLine($"[Notification] Dispatched: Confirmation channel sent for Invoice No: {invoice.InvoiceNumber}");
    }
}

public class LoggerService
{
    public void WriteLog(string message)
    {
        Console.WriteLine($"[Log - {DateTime.UtcNow:yyyy-MM-dd}]: {message}");
    }
}

// THE ORCHESTRATOR: Tools injected via Primary Constructor, Fuel passed via Method Parameter.
public class InvoiceProcessor(
    InvoiceRepository invoiceRepository, 
    NotificationService notificationService, 
    LoggerService loggerService)
{ 
    public void ProcessInvoice(Invoice invoice)
    {
        invoiceRepository.SaveInvoice(invoice);
        notificationService.SendInvoiceGeneratedNotification(invoice);
        loggerService.WriteLog($"Invoice processed completely for control number: {invoice.InvoiceNumber}");
    }
}

internal class Program
{
    public static void Main(string[] args)
    {
        Console.WriteLine("=== ENTERPRISE DI CONFIGURATION COMPOSITION ROOT ===");
        
        var services = new ServiceCollection();

        // Registering our stateless infrastructure services as Singletons
        services.AddSingleton<InvoiceRepository>();
        services.AddSingleton<NotificationService>();
        services.AddSingleton<LoggerService>();

        // Registering the service worker workflow orchestrator as Transient
        services.AddTransient<InvoiceProcessor>();

        var provider = services.BuildServiceProvider();

        // Resolve the worker system infrastructure from the container
        var invoiceProcessor = provider.GetRequiredService<InvoiceProcessor>();

        // Scenario: Imagine looping through values coming from a real data source or UI input
        Invoice runtimeInvoice1 = new() { InvoiceNumber = 104, TotalAmount = 234.71m };
        Invoice runtimeInvoice2 = new() { InvoiceNumber = 105, TotalAmount = 1450.00m };

        // Process various data payloads ("fuel") through the same infrastructure service ("tool")
        invoiceProcessor.ProcessInvoice(runtimeInvoice1);
        invoiceProcessor.ProcessInvoice(runtimeInvoice2);

        Console.ReadKey();
    }
}
❓ Question 2: AddSingleton or AddTransient to be used, and why?
Choosing service lifetimes is entirely dictated by State Preservation. If a class retains data values across execution steps, it is stateful. If it merely processes inputs and has no instance fields/properties, it is stateless.

1. Invoice (The Data Model / Fuel)
Rule: NEVER register pure data models/entities into an Inversion of Control (IoC) container.

Why: The IoC container's purpose is to manage structural infrastructure and dependencies. Registering a concrete data context block like service.AddSingleton<Invoice>(...) forces a dynamic, short-lived runtime model to act like a static global application value. In a multi-threaded system or web application, separate threads would continually overwrite or read the same instance data, resulting in severe data cross-contamination bugs. Data models are initialized via data access tools or runtime inputs and passed as arguments.

2. InvoiceRepository, NotificationService, LoggerService (The Infrastructure / Tools)
Recommendation: AddSingleton (provided they do not internally store instance state).

Why: Look closely at your implementations: they don't hold private state variables or open database connections at a class level. They merely accept an input, execute a console output, and finish. Manufacturing a brand new slice of heap memory for these services on every single operation call creates unnecessary work for the .NET Garbage Collector. Instantiating them once (AddSingleton) and allowing all threads to share their stateless processing logic is highly performant.

3. InvoiceProcessor (The Orchestrator / Tool)
Recommendation: AddTransient or AddSingleton (depending on scale).

Why: In standard enterprise architectures, orchestrators are registered as AddTransient by convention. This ensures a clean blueprint is referenced every time a workflow is requested. However, if your orchestrator remains completely stateless (meaning it doesn't hold data within private instance fields between method calls), it can safely run as a AddSingleton too.