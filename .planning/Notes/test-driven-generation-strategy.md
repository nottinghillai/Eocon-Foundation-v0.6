# Test-Driven Generation Strategy

**Date**: 2024  
**Status**: Core Implementation Strategy for Phase 1+  
**Priority**: CRITICAL - Foundation of autonomous execution

---

## The Problem with Sequential Generation

### Traditional Approach (DON'T DO THIS):
```
1. Generate code
2. THEN generate tests
3. THEN run tests
4. THEN debug code
5. THEN debug tests
6. Repeat until passing
```

**Issues**:
- Code and tests developed in isolation
- Tests might be invalid but you don't know until later
- Debugging happens after generation is "complete"
- Wastes tokens/time on code that won't work
- Accessibility considerations added as afterthought

---

## Test-Driven Generation (THE FOUNDATION WAY)

### Simultaneous Development:
```
1. Generate code + complimentary tests TOGETHER
2. Run tests IMMEDIATELY (compile + execute)
3. Debug code AND tests IN PARALLEL
4. Verify accessibility considerations
5. Only mark complete when tests pass
6. Move to next feature
```

**Benefits**:
- Catch bugs DURING generation, not after
- Ensure tests are valid (they run and provide feedback)
- Tight feedback loop (seconds, not minutes)
- AI thinks about testability while coding
- Accessibility baked in from start
- Reduces wasted generation on broken code

---

## Implementation via Cursor Rules

### `.cursorrules` Template

```markdown
# Foundation Framework - Swift Development Rules

## Test-Driven Generation Protocol

When writing Swift code, you MUST follow this exact sequence:

### 1. WRITE CODE + TESTS SIMULTANEOUSLY
For every function/component you create:
- Write the implementation code
- Write unit tests for that code
- Write UI tests if applicable
- Include accessibility identifiers/labels
- Document test coverage expectations

### 2. RUN TESTS IMMEDIATELY
After writing code + tests:
- Run swift test (unit tests)
- Run UI tests if applicable
- Check compilation errors
- Check linting warnings

### 3. VERIFY RESULTS
- All tests must PASS before proceeding
- Code must compile without errors
- Linting warnings should be minimal/justified
- Accessibility tests must validate properly

### 4. DEBUG IN PARALLEL
If tests fail:
- Debug BOTH the code AND the test
- Tests might have bugs too
- Fix whichever is wrong
- Re-run and verify

### 5. ONLY THEN PROCEED
Do NOT move to the next feature until current tests pass.

## Test Requirements

### Every Swift Function Must Have:
- [ ] Unit test covering happy path
- [ ] Unit test covering edge cases
- [ ] Unit test covering error conditions
- [ ] Documentation of what's being tested

### Every UI Component Must Have:
- [ ] Unit tests for logic
- [ ] UI test for user interactions
- [ ] Accessibility identifiers set
- [ ] Accessibility test validating labels/hints
- [ ] Screenshot test (if applicable)

### Test Naming Convention:
- Unit tests: `test_functionName_condition_expectedResult()`
- UI tests: `testUI_componentName_interaction_expectedBehavior()`
- Accessibility: `testAccessibility_componentName_feature()`

## Accessibility Requirements

### Every Interactive Element Must Have:
```swift
// Accessibility Identifier (for UI tests)
.accessibilityIdentifier("descriptive_id")

// Accessibility Label (for screen readers)
.accessibilityLabel("Clear description")

// Accessibility Hint (if needed)
.accessibilityHint("What happens when activated")

// Accessibility Traits
.accessibilityAddTraits(.isButton) // or appropriate trait
```

### Accessibility Tests Must Validate:
- Elements are discoverable
- Labels are clear and descriptive
- Hints provide context when needed
- Proper traits are assigned
- Keyboard navigation works (if applicable)

## Example: Correct Approach

```swift
// STEP 1: Write implementation + tests together

// Implementation
struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .accessibilityIdentifier("login_username_field")
                .accessibilityLabel("Username")
            
            SecureField("Password", text: $password)
                .accessibilityIdentifier("login_password_field")
                .accessibilityLabel("Password")
            
            Button("Login") {
                performLogin()
            }
            .accessibilityIdentifier("login_submit_button")
            .accessibilityLabel("Login")
            .accessibilityHint("Tap to log in with your credentials")
        }
    }
    
    func performLogin() {
        // Login logic
    }
}

// Unit Tests (in same generation)
import XCTest
@testable import MyApp

class LoginViewTests: XCTestCase {
    
    func test_performLogin_withValidCredentials_succeeds() {
        // Test logic here
    }
    
    func test_performLogin_withInvalidCredentials_fails() {
        // Test logic here
    }
    
    func test_performLogin_withEmptyFields_showsError() {
        // Test logic here
    }
}

// UI Tests (in same generation)
import XCTest

class LoginUITests: XCTestCase {
    
    func testUI_loginView_submitButton_triggersLogin() {
        let app = XCUIApplication()
        app.launch()
        
        let usernameField = app.textFields["login_username_field"]
        usernameField.tap()
        usernameField.typeText("testuser")
        
        let passwordField = app.secureTextFields["login_password_field"]
        passwordField.tap()
        passwordField.typeText("password123")
        
        let loginButton = app.buttons["login_submit_button"]
        loginButton.tap()
        
        // Assert expected behavior
    }
    
    func testAccessibility_loginView_allElementsAccessible() {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.textFields["login_username_field"].exists)
        XCTAssertEqual(
            app.textFields["login_username_field"].label,
            "Username"
        )
        
        XCTAssertTrue(app.secureTextFields["login_password_field"].exists)
        XCTAssertEqual(
            app.secureTextFields["login_password_field"].label,
            "Password"
        )
        
        XCTAssertTrue(app.buttons["login_submit_button"].exists)
        XCTAssertEqual(
            app.buttons["login_submit_button"].label,
            "Login"
        )
    }
}
```

// STEP 2: Run tests immediately
// swift test
// Check output - all passing? Continue. Failures? Debug.

// STEP 3: Only after tests pass, move to next component

## Dialogue Tree Structure

When generating code, follow this dialogue pattern:

```
AI: "I'm going to implement the [Feature] component."

AI: "Here's the implementation code..."
[Code block]

AI: "Here are the complimentary unit tests..."
[Test code block]

AI: "Here are the UI/accessibility tests..."
[UI test code block]

AI: "Running tests now..."
[Execute: swift test]

AI: "Test results: [PASS/FAIL details]"

IF FAIL:
  AI: "Debugging failures..."
  AI: "Issue found: [description]"
  AI: "Applying fix to [code/test]..."
  [Updated code]
  AI: "Re-running tests..."
  [Repeat until pass]

IF PASS:
  AI: "All tests passing ✓"
  AI: "Moving to next component..."
```

## Validation Checklist

Before marking ANY code as complete:

- [ ] Implementation code written
- [ ] Unit tests written and included
- [ ] UI tests written (if applicable)
- [ ] Accessibility identifiers added
- [ ] Accessibility tests written
- [ ] Tests compiled successfully
- [ ] Tests executed successfully
- [ ] All tests PASSED
- [ ] Code reviewed for quality
- [ ] Documentation added

## Debug Loop Protocol

When tests fail:

### 1. Analyze Failure
```
- What test failed?
- What was expected vs actual?
- Is the CODE wrong or the TEST wrong?
- Is it a logic bug or assumption bug?
```

### 2. Hypothesis
```
- State what you think is wrong
- Explain your reasoning
- Identify which to fix (code or test)
```

### 3. Apply Fix
```
- Make targeted change
- Explain what changed and why
- Update related tests if needed
```

### 4. Re-run
```
- Execute tests again
- Verify fix worked
- Check for regression
```

### 5. Iterate or Complete
```
- If still failing: repeat 1-4
- If max attempts reached: signal human intervention
- If passing: mark complete and proceed
```

## Max Attempts Before Human Intervention

- Unit test failures: 3 attempts
- UI test failures: 3 attempts
- Compilation errors: 2 attempts
- If unable to resolve: document issue and request human review

## Code Quality Standards

All generated code must:
- Follow Swift naming conventions
- Include inline comments for complex logic
- Use meaningful variable/function names
- Handle errors appropriately
- Be accessible by default
- Pass all linting rules
- Have > 80% test coverage

## Performance Considerations

While generating:
- Don't over-generate (write minimal code to pass tests)
- Keep test execution fast (mock external dependencies)
- Run only relevant tests (not entire suite every time)
- Use parallel test execution when possible

## Documentation Requirements

Every feature must include:
- Code comments explaining non-obvious logic
- Test comments explaining what's being validated
- Accessibility annotations
- Edge cases documented
- Error handling documented

---

## Integration with Foundation Pipeline

This approach integrates with the larger Foundation architecture:

### Constitution → Plan → Generate
When a Plan.md says "Implement login functionality":
1. Planner includes test requirements in the plan
2. Generator follows test-driven generation protocol
3. Tests run automatically during generation
4. Results feed back into the pipeline
5. Only successful generations proceed to merge

### Guides Documentation
After successful generation:
- Document what was implemented
- Document what tests were created
- Document any issues encountered
- Document debugging process
- Feed learnings back to improve future generation

---

## Why This Matters

This isn't just "best practice" - it's **essential for autonomous execution**.

Without test-driven generation:
- AI generates code that might not work
- Tests might not work
- You waste time/tokens debugging later
- Can't validate quality automatically
- Human intervention required constantly

With test-driven generation:
- Code is validated AS IT'S WRITTEN
- Tests are validated AS THEY'RE WRITTEN
- Immediate feedback loop
- High confidence in generated code
- Autonomous execution possible
- Human intervention only when truly needed

---

## Metrics to Track

For each generation session:
- Tests written / features implemented (ratio)
- Test pass rate on first run
- Average debug attempts per feature
- Human interventions required
- Time from generation to passing tests
- Code coverage percentage

Target metrics:
- 1:1 or better test:feature ratio
- >80% first-run pass rate
- <2 average debug attempts
- <10% human intervention rate
- <5 minutes generation to passing
- >80% code coverage

---

## Future Enhancements

As Foundation evolves:
- AI generates property-based tests
- AI generates performance tests
- AI generates security tests
- AI improves its own test generation
- Test templates evolve based on success patterns
- Autonomous test quality improvement

---

## Conclusion

**Test-Driven Generation is not optional - it's the foundation of Foundation.**

Every piece of code generated must:
1. Come with tests
2. Run those tests immediately
3. Pass those tests before proceeding
4. Include accessibility from the start

This is how we achieve autonomous execution at scale.

This is how we go from speech to company.

---

*"Code without tests is just hopes and dreams. Code with passing tests is production-ready."*