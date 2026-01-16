import { chromium } from 'playwright';
const BASE_URL = process.env.BASE_URL || 'http://localhost:5041';
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  const errors = [];
  page.on('pageerror', e => errors.push(String(e)));
  page.on('console', m => { if (m.type() === 'error') errors.push(m.text()); });
  try {
    await page.goto(BASE_URL, { waitUntil: 'networkidle', timeout: 30000 });
    await page.screenshot({ path: 'verification-screenshot.png', fullPage: true });
    if (errors.length > 0) { console.error('Console errors:', errors); process.exit(2); }
    console.log('✓ Visual verification passed');
    console.log('Screenshot: verification-screenshot.png');
  } catch (e) {
    console.error('Verification failed:', e.message);
    process.exit(1);
  } finally { await browser.close(); }
})();
