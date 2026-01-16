---
name: dev-browser
description: Visual verification and browser automation using Playwright
metadata:
  short-description: use playwright to verify ui, take screenshots, and run browser tests
---

# dev-browser Skill

## When to use

Use this skill when:

- Verifying frontend changes visually
- Taking screenshots for documentation or debugging
- Running end-to-end browser tests
- Checking responsive layouts across viewports
- Validating that UI changes render correctly before commit

## Setup (run once per project)

Before using this skill, ensure Playwright is installed. Run the appropriate setup for your project type:

### Node.js Projects

```bash
# Check if playwright is installed
if ! npm ls playwright &>/dev/null; then
  echo "Installing Playwright..."
  npm install -D playwright @playwright/test
  npx playwright install chromium
else
  echo "Playwright already installed"
fi
```

### Python Projects

```bash
# Check if playwright is installed
if ! python -c "import playwright" &>/dev/null; then
  echo "Installing Playwright..."
  pip install playwright
  playwright install chromium
else
  echo "Playwright already installed"
fi
```

### One-liner Setup Scripts

**Node.js:**

```bash
npm ls playwright &>/dev/null || (npm install -D playwright @playwright/test && npx playwright install chromium)
```

**Python:**

```bash
python -c "import playwright" 2>/dev/null || (pip install playwright && playwright install chromium)
```

## Core Instructions

### Quick Visual Verification

When asked to "check the UI" or "verify visually", use this pattern:

```javascript
// verify-ui.mjs — run with: node verify-ui.mjs
import { chromium } from "playwright";

const browser = await chromium.launch();
const page = await browser.newPage();

await page.goto("http://localhost:3000");
await page.screenshot({ path: "screenshot.png", fullPage: true });

console.log("Screenshot saved to screenshot.png");
await browser.close();
```

### Python equivalent

```python
# verify_ui.py — run with: python verify_ui.py
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto("http://localhost:3000")
    page.screenshot(path="screenshot.png", full_page=True)
    print("Screenshot saved to screenshot.png")
    browser.close()
```

### Common Verification Patterns

#### 1. Check element exists and is visible

```javascript
await page.goto("http://localhost:3000");
const button = page.locator('button:has-text("Submit")');
await expect(button).toBeVisible();
```

#### 2. Verify text content

```javascript
await expect(page.locator("h1")).toHaveText("Welcome");
```

#### 3. Check multiple viewports (responsive)

```javascript
const viewports = [
  { width: 375, height: 667, name: "mobile" },
  { width: 768, height: 1024, name: "tablet" },
  { width: 1440, height: 900, name: "desktop" },
];

for (const vp of viewports) {
  await page.setViewportSize({ width: vp.width, height: vp.height });
  await page.screenshot({ path: `screenshot-${vp.name}.png` });
}
```

#### 4. Wait for network idle (SPA apps)

```javascript
await page.goto("http://localhost:3000", { waitUntil: "networkidle" });
```

#### 5. Fill form and verify submission

```javascript
await page.fill('input[name="email"]', "test@example.com");
await page.click('button[type="submit"]');
await expect(page.locator(".success-message")).toBeVisible();
```

### Headless vs Headed

```javascript
// Headless (default, faster, for CI)
const browser = await chromium.launch();

// Headed (see the browser, for debugging)
const browser = await chromium.launch({ headless: false, slowMo: 500 });
```

## Integration with Ralph Loop

When verifying frontend tasks:

1. **Start dev server** in background (if not running):

   ```bash
   npm run dev &
   sleep 3  # wait for server
   ```

2. **Run verification script** to capture screenshot

3. **Report result** — if visual check passes, mark task complete

4. **Clean up** — kill dev server if started

## Verification Checklist

- [ ] Dev server is running on expected port
- [ ] Page loads without console errors
- [ ] Key elements are visible
- [ ] Screenshot captured for evidence
- [ ] No accessibility violations (optional: use @axe-core/playwright)

## Troubleshooting

| Issue                       | Solution                                          |
| --------------------------- | ------------------------------------------------- |
| `browser.launch()` fails    | Run `npx playwright install` to download browsers |
| Timeout waiting for element | Increase timeout or check selector                |
| Screenshot is blank         | Wait for `networkidle` or specific element        |
| ECONNREFUSED                | Dev server not running on expected port           |

## Example: Full Verification Script

```javascript
// scripts/verify-ui.mjs
import { chromium } from "playwright";

const BASE_URL = process.env.BASE_URL || "http://localhost:3000";

async function verify() {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();

  const errors = [];
  page.on("pageerror", (err) => errors.push(err.message));
  page.on("console", (msg) => {
    if (msg.type() === "error") errors.push(msg.text());
  });

  try {
    await page.goto(BASE_URL, { waitUntil: "networkidle", timeout: 30000 });
    await page.screenshot({
      path: "verification-screenshot.png",
      fullPage: true,
    });

    if (errors.length > 0) {
      console.error("Console errors detected:", errors);
      process.exit(1);
    }

    console.log("✓ Visual verification passed");
    console.log("  Screenshot: verification-screenshot.png");
  } catch (err) {
    console.error("✗ Verification failed:", err.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
}

verify();
```

Run with: `node scripts/verify-ui.mjs`
