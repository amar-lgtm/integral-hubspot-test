# INT-2296: HubSpot Quote App Implementation

## Overview
Implement the Integral quote experience using HubSpot's quote template system. The template lives in `themes/integral-custom-quote/` and deploys via CI/CD to HubSpot Design Manager.

## Technical Approach
HubSpot quote templates support:
- Full HTML/CSS customization via HubL templating
- Access to quote, deal, company, contact, and line item data
- Native signature module (`@hubspot/quote_signature`)
- JavaScript embeds including HubSpot Conversations chat
- Print/PDF rendering

This is sufficient to build the target experience.

## Template Structure

```
integral-quote.html
├── Header
│   ├── Integral logo
│   └── Welcome message ("You're nearly there!")
│
├── Main Content (left column)
│   ├── Services Table
│   │   ├── Column: Articles & Descriptions
│   │   ├── Column: Price (netto)
│   │   ├── Row: line item name + provider + description
│   │   ├── Row: frequency badge (Einmalig/Monatlich)
│   │   └── Total row
│   │
│   ├── All Services Section (expandable)
│   │   └── List of included services
│   │
│   └── Signature Block
│       ├── Acceptance checkbox
│       └── "Agree & Sign" CTA
│
├── Sidebar (right column)
│   ├── Company Info Card
│   │   ├── Company name + address
│   │   └── Contact name + email + phone
│   │
│   ├── Timeline Card
│   │   ├── Step 1: Contract and signature (active)
│   │   ├── Step 2: Setup & tax advisor takeover
│   │   └── Step 3: Initial accounting
│   │
│   └── Trust Card
│       ├── Advisor photo + name + title
│       └── Experience statement
│
├── Footer
│   └── Legal: Sicherheit & Haftung • Steuerberaterkammer Berlin • DSGVO-konform • §67 StBerG • Verschlüsselte Kommunikation
│
└── Chat Widget (floating, bottom-right)
    └── HubSpot Conversations embed
```

## Data Mapping

| UI Element | HubSpot Source |
|------------|----------------|
| Company name | `COMPANY.name` |
| Company address | `COMPANY.address`, `COMPANY.city`, `COMPANY.zip` |
| Contact name | `CONTACT.firstname`, `CONTACT.lastname` |
| Contact email | `CONTACT.email` |
| Contact phone | `CONTACT.phone` |
| Line item name | `item.name` |
| Line item description | `item.description` |
| Line item price | `item.price` (formatted with `format_currency`) |
| Line item quantity | `item.quantity` |
| Line item frequency | `item.hs_recurring_billing_period` or default "Einmalig" |
| Total | `TOTALS.total` |
| Quote ID | `QUOTE.hs_object_id` |

## Implementation Tasks

### 1. Fix CSS Reference
File: `templates/integral-quote.html` line 21
```
Change: '../styles/dynamic-quote.css'
To: '../styles/integral-quote.css'
```

### 2. Add Contact Data
File: `templates/integral-quote.html`
```hubl
{% set CONTACT = QUOTE.associated_objects.contact %}
```

### 3. Restructure HTML
Replace current template body with two-column layout:
- Left: 70% width — services, included services, signature
- Right: 30% width — company card, timeline, trust card

### 4. Services Table
```hubl
{% for item in LINE_ITEMS %}
  <tr>
    <td>
      <strong>{{ item.name }}</strong>
      <span class="provider">Leistung durch {{ item.hs_product_id|default('Integral Services GmbH') }}</span>
      <p class="description">{{ item.description }}</p>
    </td>
    <td class="price">
      {{ item.price|format_currency(CURRENCY, LOCALE) }}
      <span class="frequency">
        {% if item.hs_recurring_billing_period %}
          Monatlich
        {% else %}
          Einmalig
        {% endif %}
      </span>
    </td>
  </tr>
{% endfor %}
```

### 5. Timeline Section
```html
<div class="timeline">
  <h3>Timeline to join Integral</h3>
  <div class="step active">
    <span class="dot"></span>
    <div class="content">
      <strong>Contract and signature</strong>
      <span>Now · 15 Min</span>
    </div>
  </div>
  <div class="step">
    <span class="dot"></span>
    <div class="content">
      <strong>Setup & tax advisor takeover</strong>
      <span>Aprox 3 weeks</span>
    </div>
  </div>
  <div class="step">
    <span class="dot"></span>
    <div class="content">
      <strong>Initial accounting</strong>
      <span>Aprox 4 weeks</span>
    </div>
  </div>
</div>
```

### 6. Trust Card
```html
<div class="trust-card">
  <p>With over 15 years of experience, Fabian and his team offer trusted expertise in taxation, bookkeeping, and financial reporting.</p>
  <div class="advisor">
    <img src="{{ get_asset_url('../images/advisor.jpg') }}" alt="Fabian Sommer" />
    <div>
      <strong>Fabian Sommer</strong>
      <span>Certified Tax Advisor LLM</span>
      <span>Integral Tax GmbH Wirtsch</span>
    </div>
  </div>
</div>
```

### 7. Signature Block
```html
<div class="signature-block">
  <label class="checkbox">
    <input type="checkbox" required />
    I have reviewed the offer and accept the services.
  </label>
  {% module "signature" path="@hubspot/quote_signature" %}
</div>
```

### 8. Chat Widget
```html
<!-- HubSpot Conversations Embed -->
<script type="text/javascript" id="hs-script-loader" async defer src="//js.hs-scripts.com/{{ hub_id }}.js"></script>
```

### 9. CSS Updates
File: `styles/integral-quote.css`
- Two-column flexbox layout
- Integral brand colors (#1a1a2e primary, #f5a623 accent)
- Card styles with shadows
- Timeline vertical line with dots
- Frequency badge styling
- Signature block styling
- Print media query (hide chat, single column)
- Mobile responsive (stack columns below 768px)

## File Changes Summary

| File | Action |
|------|--------|
| `templates/integral-quote.html` | Rewrite with new structure |
| `styles/integral-quote.css` | Rewrite with new styles |
| `images/advisor.jpg` | Add advisor photo asset |
| `images/integral-logo.svg` | Add Integral logo asset |

## Deployment
Uses existing CI/CD workflow (`.github/workflows/deploy-to-hubspot.yml`):
1. Push to `main` branch
2. GitHub Actions uploads to HubSpot Design Manager
3. Template available at `themes/integral-custom-quote`

## Validation Checklist
- [ ] Template renders in HubSpot Design Manager preview
- [ ] Line items display correctly with frequency badges
- [ ] Company and contact info populates from quote data
- [ ] Timeline displays with correct styling
- [ ] Trust card renders with advisor info
- [ ] Signature module functional
- [ ] Chat widget loads
- [ ] Print/PDF output clean (no chat widget)
- [ ] Mobile layout stacks correctly
- [ ] CI/CD deploys without errors
