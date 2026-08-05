To clearly distinguish between an **Adjective-based Capability (Data Object with Powers)** and a **Noun-based Service (Infrastructure/Action Worker)**, it helps to see how they would exist *side-by-side* in the exact same application.

Let's look at a complete, runnable example that uses both naming styles correctly to show exactly how their responsibilities, structure, and usage differ.

### The Real-World Distinction Code

```csharp
using System;

namespace NamingConventionDemo;

// ============================================================================
// TYPE 1: THE ADJECTIVE INTERFACE (An Object's Capability or Quality)
// Rules: Describes what an object "IS" or what qualities it possesses.
//        It encapsulates internal data state and acts on itself.
// ============================================================================
public interface IBonusEligible
{
    string EmployeeName { get; set; }
    decimal Salary { get; set; }
    decimal CalculateBonus(); // Uses its OWN internal data (Salary) to calculate
}

public class PermanentEmployee : IBonusEligible
{
    public required string EmployeeName { get; set; }
    public decimal Salary { get; set; }

    // This class handles the calculation itself because it owns the data
    public decimal CalculateBonus() => Salary * 0.10m; 
}


// ============================================================================
// TYPE 2: THE NOUN INTERFACE (A Stateless Service or Utility Worker)
// Rules: Describes what a component "DOES" for other objects.
//        It has no personal data state. It is an engine that processes external data.
// ============================================================================
public interface IBonusCalculator
{
    // It cannot calculate anything on its own; you MUST feed it data from the outside
    decimal CalculateTaxDeduction(decimal bonusAmount); 
}

public class GovernmentTaxCalculator : IBonusCalculator
{
    // A stateless utility worker. It doesn't care who the employee is.
    // It just takes a raw number and applies an external business formula.
    public decimal CalculateTaxDeduction(decimal bonusAmount) => bonusAmount * 0.30m; 
}


// ============================================================================
// THE ORCHESTRATOR (How they work together)
// ============================================================================
public class PayrollProcessor(IBonusCalculator taxCalculator)
{
    public void ProcessPayroll(IBonusEligible employee)
    {
        // 1. We ask the CAPABILITY object to compute its own numbers
        decimal rawBonus = employee.CalculateBonus();

        // 2. We pass that raw result to the infrastructure SERVICE worker
        decimal taxDeduction = taxCalculator.CalculateTaxDeduction(rawBonus);

        decimal netBonus = rawBonus - taxDeduction;

        Console.WriteLine($"[Payroll] Employee: {employee.EmployeeName}");
        Console.WriteLine($"   Gross Bonus: {rawBonus:C}");
        Console.WriteLine($"   Tax Withheld: {taxDeduction:C}");
        Console.WriteLine($"   Net Payout: {netBonus:C}\n");
    }
}

// ============================================================================
// EXECUTION
// ============================================================================
internal class Program
{
    static void Main()
    {
        // Instantiate the Service worker (Noun) - typically registered as Singleton
        IBonusCalculator federalTaxService = new GovernmentTaxCalculator();

        // Instantiate the Orchestrator
        PayrollProcessor payrollEngine = new PayrollProcessor(federalTaxService);

        // Instantiate our Data Entities with capabilities (Adjectives)
        IBonusEligible engineer = new PermanentEmployee { EmployeeName = "Alice", Salary = 100000m };
        IBonusEligible pilot = new PermanentEmployee { EmployeeName = "Bob", Salary = 150000m };

        Console.WriteLine("--- Processing Enterprise Payroll ---");
        payrollEngine.ProcessPayroll(engineer);
        payrollEngine.ProcessPayroll(pilot);

        Console.ReadKey();
    }
}

```

---

### Key Takeaways to Clear the Confusion

1. **Look at the Data Ownership:**
* `IBonusEligible` (Adjective) **owns** the properties `EmployeeName` and `Salary`. The method `CalculateBonus()` is designed to read the object's *own data fields*.
* `IBonusCalculator` (Noun) **owns nothing**. It is completely blank until you pass a number into `CalculateTaxDeduction(decimal bonusAmount)`. It is a function machine.


2. **Look at the English Sentence Flow:**
* *Adjective usage:* `payrollEngine.ProcessPayroll(employee)` $\rightarrow$ "Process payroll for this object which **is bonus-eligible**."
* *Noun usage:* `new PayrollProcessor(taxCalculator)` $\rightarrow$ "Build a payroll processor using this **tax calculator service**."


3. **Why this matters for your architecture:**
If you named the employee's interface `IBonusCalculator`, a developer reading your orchestrator might get confused and try to write code like this:
`decimal tax = employee.CalculateTaxDeduction(5000); // Wait, why can an individual employee calculate global system taxes?`
Keeping them segregated by name ensures that **Data Entities with internal rules** sound like characteristics (`IBonusEligible`), and **Global Processing Engines** sound like operational tools (`IBonusCalculator`).