# Coding Standards for Ralph Wiggum AI Automation

## C# Coding Standards

### Formatting

#### Indentation
- Use 4 spaces for indentation (no tabs)
- Indent code blocks consistently
- Align related code vertically for readability

#### Line Length
- Maximum line length: 120 characters
- Break long lines at logical points
- Use multiple lines for method chains when appropriate

#### Bracing Style
```csharp
// Always use braces, even for single-line statements
if (condition)
{
    DoSomething();
}

// Opening brace on new line for types and methods
public class MyClass
{
    public void MyMethod()
    {
        // Method body
    }
}
```

#### Spacing
```csharp
// Space after keywords
if (condition)
while (condition)
for (int i = 0; i < count; i++)

// Space around operators
int result = a + b;
bool isValid = x == y;

// No space before semicolons or between method name and parentheses
DoSomething();
var list = new List<int>();
```

### Naming Conventions

#### Classes and Interfaces
```csharp
// PascalCase for classes
public class CustomerService { }

// PascalCase with 'I' prefix for interfaces
public interface ICustomerRepository { }

// PascalCase for structs and enums
public struct Point { }
public enum OrderStatus { }
```

#### Methods and Properties
```csharp
// PascalCase for public methods
public void ProcessOrder() { }

// PascalCase for properties
public string CustomerName { get; set; }

// PascalCase for events
public event EventHandler OrderProcessed;
```

#### Fields and Variables
```csharp
// camelCase for private fields
private string customerName;
private readonly ILogger logger;

// camelCase for local variables
var orderCount = 10;
string userName = "john";

// PascalCase for constants
private const int MaxRetryCount = 3;
public const string DefaultCulture = "en-US";
```

#### Parameters
```csharp
// camelCase for method parameters
public void ProcessOrder(int orderId, string customerName)
{
    // Implementation
}
```

### Code Organization

#### Using Directives
```csharp
// Order using statements alphabetically
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Extensions.Logging;
using MyProject.Domain;
using MyProject.Services;

// Remove unused using directives
```

#### File Structure
```csharp
// 1. Using directives
using System;

// 2. Namespace
namespace MyProject.Services
{
    // 3. Class documentation
    /// <summary>
    /// Handles customer order processing.
    /// </summary>
    public class OrderService
    {
        // 4. Constants
        private const int DefaultTimeout = 30;
        
        // 5. Fields
        private readonly ILogger<OrderService> logger;
        
        // 6. Constructors
        public OrderService(ILogger<OrderService> logger)
        {
            this.logger = logger;
        }
        
        // 7. Properties
        public int ProcessedCount { get; private set; }
        
        // 8. Methods
        public void ProcessOrder(Order order)
        {
            // Implementation
        }
        
        // 9. Private methods
        private void ValidateOrder(Order order)
        {
            // Implementation
        }
    }
}
```

### Documentation

#### XML Comments
```csharp
/// <summary>
/// Processes a customer order and updates inventory.
/// </summary>
/// <param name="order">The order to process.</param>
/// <returns>True if the order was processed successfully; otherwise, false.</returns>
/// <exception cref="ArgumentNullException">Thrown when order is null.</exception>
public bool ProcessOrder(Order order)
{
    // Implementation
}
```

#### Code Comments
```csharp
// Use comments to explain WHY, not WHAT
// Good: Explain complex business logic
// Calculate discount based on customer tier and order history
var discount = CalculateDiscount(customer, order);

// Bad: State the obvious
// Increment counter by one
counter++;

// Use TODO comments for future work
// TODO: Optimize this query for large datasets
```

### Best Practices

#### Null Handling
```csharp
// Use null-coalescing operators
string name = customer?.Name ?? "Unknown";

// Check for null before use
if (order != null)
{
    ProcessOrder(order);
}

// Use ArgumentNullException for parameters
public void ProcessOrder(Order order)
{
    if (order == null)
        throw new ArgumentNullException(nameof(order));
}
```

#### LINQ
```csharp
// Use LINQ for clarity
var activeCustomers = customers
    .Where(c => c.IsActive)
    .OrderBy(c => c.Name)
    .ToList();

// Use method syntax for simple queries
var count = orders.Count(o => o.Status == OrderStatus.Pending);
```

#### String Operations
```csharp
// Use string interpolation
string message = $"Order {orderId} processed for {customerName}";

// Use StringBuilder for multiple concatenations
var builder = new StringBuilder();
foreach (var item in items)
{
    builder.AppendLine(item.ToString());
}
```

#### Async/Await
```csharp
// Use async/await for I/O operations
public async Task<Order> GetOrderAsync(int orderId)
{
    return await repository.GetByIdAsync(orderId);
}

// Use ConfigureAwait(false) in library code
var result = await SomeOperationAsync().ConfigureAwait(false);
```

### Code Smells to Avoid

- **Magic Numbers**: Use named constants instead
- **Long Methods**: Break down into smaller, focused methods
- **Deep Nesting**: Refactor to reduce complexity
- **Duplicate Code**: Extract common logic into methods
- **Large Classes**: Split into smaller, focused classes
- **Commented Code**: Remove instead of commenting out

### Security Guidelines

- Never hardcode credentials or API keys
- Validate all user input
- Use parameterized queries to prevent SQL injection
- Sanitize output to prevent XSS attacks
- Use HTTPS for sensitive data transmission
- Implement proper authentication and authorization

## AI-Specific Guidelines

### For Code Generation
1. Always follow these standards when generating new code
2. Match the style of surrounding code
3. Use consistent naming throughout the project
4. Include appropriate documentation

### For Code Modification
1. Preserve existing style in files being modified
2. Don't reformat unrelated code
3. Maintain consistency with the rest of the file
4. Update documentation to match changes

### For Code Review
1. Check adherence to these standards
2. Suggest improvements that align with guidelines
3. Flag security concerns
4. Recommend better patterns when appropriate
