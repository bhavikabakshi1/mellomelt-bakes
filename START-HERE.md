# Open this project in VS Code

This ZIP contains the complete source of the published Mellow & Melt website,
including the React interface, Tailwind styling, Framer Motion animations,
backend API, images, database migrations, and Supabase SQL setup.

This is a React + Vinext application with a Cloudflare Workers backend, rather
than a plain frontend-only Vite project.

## Local setup

1. Extract the ZIP and open the mellow-and-melt folder in VS Code.
2. Install Node.js 22.13 or newer (required by this project).
3. Open the VS Code terminal in that folder and run:

```sh
npm install
npm run build
node --import ./scripts/sites-env.mjs ./node_modules/wrangler/bin/wrangler.js d1 execute DB --local --config dist/server/wrangler.json --persist-to .wrangler/state --file drizzle/0000_flat_rachel_grey.sql
npm run dev
```

Open the local address printed by the terminal (normally http://localhost:5173).
Apply the database migration once for a fresh local database, not on every run.
The database starts empty; the API creates the eight sample products on its first load.
Dependencies are excluded from the ZIP and installed by npm install.
The source was built and checked in the hosted Linux environment; Windows local
installation has not been tested.

## Files you will edit most

- app/page.tsx: storefront, shopping flows, customer and admin dashboards
- app/globals.css: colors, typography, responsive layouts
- lib/catalog.ts: sample products and recipe content
- app/api/shop/route.ts: server API and authorization
- public/images/: bakery photographs
- db/schema.ts and drizzle/: local D1 database schema and migrations
- SUPABASE_SETUP.sql: Supabase database and transaction setup
- README.md: backend activation and deployment details
- .env.example: required configuration variable names (no real secrets)

## Authentication and backend configuration

The published site uses ChatGPT authentication supplied by Sites. That production
identity integration is not a standalone login provider on your laptop. The
portable development configuration includes the starter's local mock-auth support;
never use mock identity as production authentication.

For real standalone email/password authentication, configure your own Supabase
project, run SUPABASE_SETUP.sql, and follow README.md. With Cloudflare local
runtime development, put your private local variables into an untracked
.dev.vars file. Use the variable names from .env.example. Configure ADMIN_EMAIL
to your verified administrator email. Supabase service-role keys are server-only.

The Supabase project and credentials are not included. The ZIP does not contain
the live database, customer data, cloud runtime secrets, or installed dependencies.
Supabase starts with separate data from D1. Online payment processing is not
connected; checkout uses pay on delivery.

The existing .openai/hosting.json identifies the current hosted Site. Keep it
for reference; create a new Site identity before publishing this as a separate
hosted copy. Do not commit private configuration files to GitHub.
