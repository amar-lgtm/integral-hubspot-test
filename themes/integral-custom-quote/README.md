# Dynamic Quote Theme for HubSpot

This is a boilerplate theme for creating dynamic quote pages in HubSpot's Design Manager.

## Structure

```
themes/dynamic-quote-theme/
├── templates/
│   └── dynamic-quote.html      # Main quote template
├── styles/
│   └── dynamic-quote.css      # Stylesheet for the quote template
├── imports/
│   └── mock_data.html         # Mock data for preview
└── README.md                   # This file
```

## Features

- **Dynamic Quote Template**: Fully customizable quote template with HubL
- **Responsive Design**: Mobile-friendly layout
- **Print Styles**: Optimized for PDF generation
- **Line Items Table**: Dynamic table for quote line items
- **Totals Calculation**: Automatic totals display
- **Company Information**: Bill-to section with company details
- **Signature Module**: Integration with HubSpot's quote signature module
- **Download Module**: Integration with HubSpot's quote download module

## Usage

1. **Upload to Design Manager**:
   - Navigate to Design Manager in your HubSpot account
   - Create a new folder or use an existing one
   - Upload the files maintaining the folder structure

2. **Set as Quote Theme**:
   - Go to Settings → Objects → Quotes → Quote templates
   - Select this theme as your default or create a new quote template using `dynamic-quote.html`

3. **Customize**:
   - Edit `dynamic-quote.html` to customize the layout
   - Modify `dynamic-quote.css` to change styling
   - Add additional modules or sections as needed

## Available Variables

The template uses the following HubL variables:

- `QUOTE`: Main quote object with all quote properties
- `DEAL`: Associated deal information
- `COMPANY`: Company/billing information
- `LINE_ITEMS`: Array of line items
- `TOTALS`: Calculated totals (subtotal, tax, discount, total)
- `CURRENCY`: Quote currency code
- `LOCALE`: Quote locale

## HubL Reference

For more information on HubL quote variables, see:
https://developers.hubspot.com/docs/reference/cms/hubl/quote-variables

## Customization Tips

1. **Styling**: Modify the CSS file to match your brand colors and fonts
2. **Layout**: Adjust the HTML structure in the template file
3. **Modules**: Add custom HubSpot modules for additional functionality
4. **Conditional Logic**: Use HubL conditionals to show/hide sections based on quote data

## Support

For HubSpot CMS documentation, visit:
https://developers.hubspot.com/docs/cms

