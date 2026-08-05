Here is the detailed, complete structural breakdown of the **SOLID Principles** formatted explicitly as a production-ready Markdown (.md) file.

This document contains all the detailed explanations, code patterns, and the .NET 10 dependency injection examples we discussed, fully written out with code fences so you can copy, save, and reference it during your development journey.

---

```markdown
# Comprehensive Guide to SOLID Principles in Modern C# (.NET 10)
### Architectural Implementation for Enterprise Software Engineering

This reference blueprint translates theoretical software design principles into concrete, production-ready C# code. To ground these concepts in large-scale enterprise development, all architectural examples are modeled within the **Airline Engineering, Logistics, and Fleet Management** domain.

---

## 1. Single Responsibility Principle (SRP)
> *A class should have one, and only one, reason to change.*

### ❌ The Anti-Pattern: The Monolithic Class
A single service manages domain validation, executes raw database connections, and coordinates external SMTP email logic. Changes to database access mechanisms or shifting to a cloud email provider force modifications to the core business logic file.

```csharp
using System;
using Microsoft.Data.SqlClient;
using System.Net.Mail;

public class PartMaintenanceService
{
    public void LogInspection(string partId, string status)
    {
        // 1. Business Logic & Validation
        if (string.IsNullOrEmpty(partId)) 
            throw new ArgumentException("Invalid Part ID specified.");

        // 2. Data Access Layer (Violates SRP)
        string connectionString = "Server=AirlineLogisticsProd;Database=FleetInventory;Trusted_Connection=True;";
        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open();
            var query = "UPDATE MaintenanceLogs SET Status = @Status, InspectedDate = GETDATE() WHERE PartId = @Id";
            using (var command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Id", partId);
                command.Parameters.AddWithValue("@Status", status);
                command.ExecuteNonQuery();
            }
        }

        // 3. Notification Layer (Violates SRP)
        using (var smtpClient = new SmtpClient("mail.airlinecorp.com"))
        {
            var mailMessage = new MailMessage("logistics@airline.com", "eng-lead@airline.com")
            {
                Subject = $"Component Alert: Part {partId}",
                Body = $"Part {partId} has been updated with status: {status}."
            };
            smtpClient.Send(mailMessage);
        }
    }
}

```

### The Architectural Pattern: Decoupled Single-Purpose Components

The monolithic class is refactored into three independent, atomic layers. Each class owns exactly one core operational domain, drastically improving testability and code maintainability.

```csharp
namespace AirlineLogistics.Core
{
    // Layer 1: Data Access Layer - Responsible exclusively for data persistence boundaries
    public class PartRepository
    {
        private readonly string _connectionString = "Server=AirlineLogisticsProd;Database=FleetInventory;Trusted_Connection=True;";

        public void UpdatePartStatus(string partId, string status)
        {
            // Database-specific driver operations live strictly inside this boundary
        }
    }

    // Layer 2: Communication Infrastructure - Responsible exclusively for external alerting structures
    public class NotificationService
    {
        public void NotifyEngineeringLead(string partId, string status)
        {
            // Email, SMS, or Push infrastructure messaging logic lives strictly here
        }
    }

    // Layer 3: Domain Workflow Layer - Orchestrates business components via composition
    public class PartMaintenanceService
    {
        private readonly PartRepository _repository;
        private readonly NotificationService _notification;

        public PartMaintenanceService(PartRepository repository, NotificationService notification)
        {
            _repository = repository;
            _notification = notification;
        }

        public void LogInspection(string partId, string status)
        {
            if (string.IsNullOrEmpty(partId)) 
                throw new ArgumentException("Invalid Part ID specified.");

            // Delegating tasks cleanly to dedicated underlying single-responsibility units
            _repository.UpdatePartStatus(partId, status);
            _notification.NotifyEngineeringLead(partId, status);
        }
    }
}

```

---

## 2. Open/Closed Principle (OCP)

> *Software entities should be open for extension, but closed for modification.*

### ❌ The Anti-Pattern: The `switch` Statement / Pattern-Matching Trap

When calculating maintenance severity or prioritization offsets across differing component classes, nesting procedural `switch` blocks forces developers to edit core legacy systems whenever a new component classification arrives (e.g., *Hazardous Avionics Batteries*), introducing severe regression risks.

```csharp
public class PriorityCalculator
{
    public int CalculatePriority(string partType, int daysInService)
    {
        // Modifying this class file is strictly required every time a new part specification emerges (Violates OCP)
        return partType switch
        {
            "Avionics" => daysInService * 3,
            "Mechanical" => daysInService * 2,
            "Hydraulics" => daysInService * 5,
            _ => daysInService
        };
    }
}

```

### The Architectural Pattern: Strategy Design Pattern

By declaring a standardized polymorphic implementation contract through an interface, behavior can be dynamically extended by implementing clean, uncoupled strategy modules without touching a single line of validated, production execution paths.

```csharp
using System.Collections.Generic;
using System.Linq;

namespace AirlineLogistics.Prioritization
{
    // Define the behavioral contract
    public interface IPriorityStrategy
    {
        string PartType { get; }
        int Calculate(int daysInService);
    }

    // Individual isolated strategy extensions
    public class AvionicsPriority : IPriorityStrategy
    {
        public string PartType => "Avionics";
        public int Calculate(int daysInService) => daysInService * 3;
    }

    public class MechanicalPriority : IPriorityStrategy
    {
        public string PartType => "Mechanical";
        public int Calculate(int daysInService) => daysInService * 2;
    }

    // EXTENSION: Adding a new rule is as simple as creating an entirely separate class file
    public class HazardousBatteryPriority : IPriorityStrategy
    {
        public string PartType => "HazardousBattery";
        public int Calculate(int daysInService) => (daysInService * 6) + 50; // Special priority rule
    }

    // The Engine: Evaluates strategies abstractly via polymorphic collections
    public class PriorityCalculator
    {
        private readonly IEnumerable<IPriorityStrategy> _strategies;

        // .NET Core Dependency Injection auto-populates this collection via IoC
        public PriorityCalculator(IEnumerable<IPriorityStrategy> strategies)
        {
            _strategies = strategies;
        }

        public int CalculatePriority(string partType, int daysInService)
        {
            var strategy = _strategies.FirstOrDefault(s => s.PartType == s.PartType);
            return strategy != null ? strategy.Calculate(daysInService) : daysInService;
        }
    }
}

```

---

## 3. Liskov Substitution Principle (LSP)

> *Objects of a superclass should be replaceable with objects of its subclasses without breaking the application.*

### ❌ The Anti-Pattern: Forcing Non-Applicable Class Hierarchies

Inheritance hierarchies are designed poorly, leading to instances where base class signatures force derived subtypes to throw catastrophic exceptions because the contract cannot structurally apply to that type's operational characteristics.

```csharp
using System;

public abstract class Aircraft
{
    public abstract void RunPreFlightChecks();
    public abstract void InspectPassengerCabinSafety(); 
}

public class Boeing777 : Aircraft
{
    public override void RunPreFlightChecks() { /* Verify critical telemetry */ }
    public override void InspectPassengerCabinSafety() { /* Validate seatbelts and oxygen masks */ }
}

public class AutonomousCargoDrone : Aircraft
{
    public override void RunPreFlightChecks() { /* Check remote satellite positioning links */ }
    
    // VIOLATES LSP: Client programs tracking collection references to abstract "Aircraft" 
    // will crash unexpectedly if they invoke cabin inspections on a Drone subclass.
    public override void InspectPassengerCabinSafety() 
    {
        throw new NotImplementedException("Fatal Structural Error: Cargo Drones possess no passenger space.");
    }
}

```

### The Architectural Pattern: Behavioral Role Interface Segregation

Subclasses are mapped along true operational attributes. Abstract base definitions are scoped purely to common attributes shared unconditionally across all sub-types, shifting specific behavioral footprints onto atomic implementations.

```csharp
namespace AirlineLogistics.Fleet
{
    public abstract class Aircraft
    {
        // Behaviors explicitly guaranteed to apply to EVERY aircraft variant in the fleet
        public abstract void RunPreFlightChecks();
    }

    public interface IPassengerCarrier
    {
        void InspectPassengerCabinSafety();
    }

    public class Boeing777 : Aircraft, IPassengerCarrier
    {
        public override void RunPreFlightChecks() { /* Telemetry check logic */ }
        public void InspectPassengerCabinSafety() { /* Passenger cabin verification */ }
    }

    public class AutonomousCargoDrone : Aircraft
    {
        public override void RunPreFlightChecks() { /* Satellite link check logic */ }
        // Safe substitution: Structural components strictly match execution constraints.
    }
}

```

---

## 4. Interface Segregation Principle (ISP)

> *Clients should not be forced to depend on methods they do not use.*

### ❌ The Anti-Pattern: The Heavy Interface Problem

Declaring a monolithic interface contract that attempts to govern wide swaths of unrelated application domains forces internal operational modules to write empty definitions or execute dummy implementations for services they do not require.

```csharp
using System;

public interface ILogisticsOrchestrator
{
    void ReorderWarehouseParts(string partId, int quantity);
    void UpdateAeroEngineFlightHours(string airframeId, double hours);
    void CompileEasaRegulatoryReport();
}

// A simple ground inventory client application only manages physical inventory, 
// yet it is structurally bound to handle complex engine operations and international flight regulations.
public class WarehouseInventoryService : ILogisticsOrchestrator
{
    public void ReorderWarehouseParts(string partId, int quantity) { /* Allocation logic */ }

    // Boilerplate garbage code inserted strictly to satisfy compilation (Violates ISP)
    public void UpdateAeroEngineFlightHours(string airframeId, double hours) => throw new NotImplementedException();
    public void CompileEasaRegulatoryReport() => throw new NotImplementedException();
}

```

### The Architectural Pattern: Segregated Role Interfaces

Deconstruct monolithic contracts into micro-interfaces based on operational functionality. Concrete classes implement only the specific interfaces required for their operational duties.

```csharp
namespace AirlineLogistics.Contracts
{
    public interface IPartInventoryCommand
    {
        void ReorderWarehouseParts(string partId, int quantity);
    }

    public interface IEngineLogbookWriter
    {
        void UpdateAeroEngineFlightHours(string airframeId, double hours);
    }

    public interface IRegulatoryAuditor
    {
        void CompileEasaRegulatoryReport();
    }

    // Concrete execution blocks implement strictly the roles they map to
    public class WarehouseInventoryService : IPartInventoryCommand
    {
        public void ReorderWarehouseParts(string partId, int quantity)
        {
            // Stock procurement logic strictly encapsulated here
        }
    }
}

```

---

## 5. Dependency Inversion Principle (DIP)

> *High-level modules should not depend on low-level modules. Both should depend on abstractions (interfaces).*

### ❌ The Anti-Pattern: Tightly Coupled Real-World Instantiations

A high-level coordinator explicitly instantiates an un-abstracted concrete lower-level infrastructure class via the `new` keywords. This introduces intense cross-dependencies, destroying the ability to abstract data boundaries, implement automated unit mocking, or adapt to cloud migrations.

```csharp
public class SqlServerInventoryDataStore
{
    public void PersistLogEntry(string details) { /* Direct low-level execution context using ADO.NET/SQL */ }
}

public class AircraftTurnaroundCoordinator
{
    private SqlServerInventoryDataStore _store;

    public AircraftTurnaroundCoordinator()
    {
        // CRITICAL DIP VIOLATION: Tight coupling. 
        // High-level operational class depends directly on low-level storage primitives.
        _store = new SqlServerInventoryDataStore();
    }

    public void FinalizeTurnaroundEvent(string flightId)
    {
        _store.PersistLogEntry($"Flight event {flightId} officially authorized.");
    }
}

```

### The Architectural Pattern: Abstraction Inversion & Dependency Injection

An abstract interface contract acts as the structural decoupling layer. High-level orchestrators rely strictly on the interface contract, while the actual implementation is decoupled and provided at runtime via standard inversion of control.

```csharp
namespace AirlineLogistics.DataBoundary
{
    // The structural decoupling layer
    public interface IAirlineDataRepository
    {
        void PersistLogEntry(string details);
    }

    // Concrete Infrastructure Strategy 1: Local SQL Server Engine
    public class SqlServerDataRepository : IAirlineDataRepository
    {
        public void PersistLogEntry(string details) { /* Transact-SQL operational pipeline */ }
    }

    // Concrete Infrastructure Strategy 2: Enterprise Cloud Architecture Storage Engine
    public class AzureCosmosDbDataRepository : IAirlineDataRepository
    {
        public void PersistLogEntry(string details) { /* Dynamic cloud storage execution */ }
    }

    // High-Level Orchestrator Module remains entirely agnostic of low-level data engine architectures
    public class AircraftTurnaroundCoordinator
    {
        private readonly IAirlineDataRepository _repository;

        // The implementation dependency is "inverted" and provided safely via standard constructor injection
        public AircraftTurnaroundCoordinator(IAirlineDataRepository repository)
        {
            _repository = repository;
        }

        public void FinalizeTurnaroundEvent(string flightId)
        {
            _repository.PersistLogEntry($"Flight event {flightId} officially authorized.");
        }
    }
}

```

---

## 🚀 Native Dependency Lifecycle Orchestration in .NET 10

To activate these architectural principles in production scenarios using standard **ASP.NET Core Web APIs**, dependencies are registered cleanly within the application's root composition pipeline (`Program.cs`).

```csharp
using AirlineLogistics.DataBoundary;
using AirlineLogistics.Prioritization;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);

// ----------------------------------------------------------------------------------
// Inversion of Control (IoC) Service Container Registration Lifecycle
// ----------------------------------------------------------------------------------

// 1. Map Abstractions to Concrete Implementations seamlessly (DIP Implementation)
builder.Services.AddScoped<IAirlineDataRepository, SqlServerDataRepository>();

// 2. Automatically populate Collections of Polymorphic Strategies (OCP Strategy Pattern Setup)
builder.Services.AddTransient<IPriorityStrategy, AvionicsPriority>();
builder.Services.AddTransient<IPriorityStrategy, MechanicalPriority>();
builder.Services.AddTransient<IPriorityStrategy, HazardousBatteryPriority>();

// 3. Register Core Business Orchestrators 
builder.Services.AddScoped<AircraftTurnaroundCoordinator>();
builder.Services.AddScoped<PriorityCalculator>();

var app = builder.Build();

app.Run();

```

```

---

### 💾 Storing the Master Blueprint File
You can copy the code fence above, paste it into a file named `SOLID_Design_Principles_Guide.md` using any local text editor (like Notepad, VS Code, or Notepad++), and save it. It will instantly render into a perfectly formatted, high-level documentation file for your personal records and upcoming modern web architecture training!

```