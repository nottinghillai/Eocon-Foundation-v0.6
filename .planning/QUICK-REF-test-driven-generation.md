# Test-Driven Generation - Quick Reference Card

**Core Principle**: Code and tests are ONE unit. Generate together, run together, debug together.

---

## The Protocol (4 Steps)

### 1️⃣ WRITE CODE + TESTS SIMULTANEOUSLY
```
✅ Implementation code
✅ Unit tests (happy path, edge cases, errors)
✅ UI tests (if applicable)
✅ Accessibility identifiers & labels
```

### 2️⃣ RUN TESTS IMMEDIATELY
```
swift test
```
Do NOT proceed until tests PASS.

### 3️⃣ DEBUG CODE AND TESTS IN PARALLEL
```
IF FAIL:
  - Analyze BOTH code and test
  - Fix whichever is wrong
  - Re-run tests
  - Max 3 attempts → human intervention
```

### 4️⃣ ONLY THEN PROCEED
```
✅ Tests passing
✅ Code documented
✅ Accessibility validated
→ Move to next feature
```

---

## Checklist (Before Marking Complete)

- [ ] Implementation code written
- [ ] Unit tests written
- [ ] UI tests written (if UI component)
- [ ] Accessibility identifiers added
- [ ] Tests compiled successfully
- [ ] Tests executed successfully
- [ ] ALL tests PASSED
- [ ] Code documented

---

## Dialogue Pattern

```
AI: "Implementing [Feature]..."

AI: "Code:"
[Swift implementation with accessibility]

AI: "Tests:"
[Unit + UI + Accessibility tests]

AI: "Running tests..."
swift test

AI: "Results: [PASS/FAIL]"

IF FAIL → Debug → Fix → Re-run
IF PASS → "✓ Complete, moving on..."
```

---

## Accessibility Requirements (MANDATORY)

Every interactive element:
```swift
.accessibilityIdentifier("unique_id")
.accessibilityLabel("Clear description")
.accessibilityHint("Action description") // if needed
```

---

## Test Naming Convention

```swift
// Unit tests
func test_functionName_condition_expectedResult() { }

// UI tests
func testUI_componentName_action_expectedBehavior() { }

// Accessibility tests
func testAccessibility_componentName_feature() { }
```

---

## Debug Loop (Max 3 Attempts)

**Attempt 1**: Analyze error, state hypothesis, fix
**Attempt 2**: Review both code AND test, fix
**Attempt 3**: Deep analysis, alternative approach, fix

**Still failing?** → Request human help with:
- What was attempted
- Why it's failing
- What's unclear
- Specific help needed

---

## What NOT to Do

❌ Write code without tests
❌ Write tests after code
❌ Skip running tests
❌ Proceed with failing tests
❌ Ignore accessibility
❌ Assume tests are correct

---

## What TO Do

✅ Write code + tests together
✅ Run tests immediately
✅ Debug both code and tests
✅ Add accessibility by default
✅ Only proceed when passing
✅ Document everything

---

## Quick Example

```swift
// Code + Tests generated together ✅

struct LoginView: View {
    @State private var username = ""
    
    var body: some View {
        TextField("Username", text: $username)
            .accessibilityIdentifier("login_username_field")
            .accessibilityLabel("Username")
    }
}

// Unit Test
func test_loginView_initialState_usernameEmpty() {
    let view = LoginView()
    XCTAssertEqual(view.username, "")
}

// Accessibility Test
func testAccessibility_loginView_usernameField_hasLabel() {
    let app = XCUIApplication()
    app.launch()
    let field = app.textFields["login_username_field"]
    XCTAssertEqual(field.label, "Username")
}

// Run immediately: swift test
// Result: PASS ✓
// → Move to next component
```

---

## Key Metrics

- Test coverage: >80%
- First-run pass rate: >80%
- Avg debug attempts: <2
- Human intervention: <10%

---

## Remember

**"Code without tests is just hopes and dreams."**

**"In Foundation, untested code doesn't exist."**

**"Generate together, run together, pass together."**

---

**Full docs**: `.planning/Notes/test-driven-generation-strategy.md`
**Cursor template**: `.planning/Proofs/cursorrules-template-swift.md`
