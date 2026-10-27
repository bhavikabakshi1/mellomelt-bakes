# Mellow & Melt

Responsive bakery storefront using React (Vinext), Tailwind CSS, Framer Motion, and a dual D1/Supabase backend.

## Live functionality

Catalog with categories, name/description search and instant quick-view results; price/rating filters; responsive product pages; local guest carts and wishlists; server-persisted signed-in cart and wishlist; secure accounts; profile and addresses; pay-on-delivery checkout; atomic inventory decrement; order history and status tracking; verified-purchase reviews; custom cake and contact inquiries; protected product/order/customer/inquiry management; actual revenue charts.

The hosted version defaults to D1 and the Sites ChatGPT identity integration. It does not pretend that email/password login or online card payment is enabled. Bakery launch status is disclosed in checkout, and delivery requires bakery confirmation. Product images are illustrative. The catalog starts with eight sample products and zero customer ratings. No fabricated customer reviews or orders are included.

## Supabase activation

1. Create or select a Supabase project and execute `SUPABASE_SETUP.sql` in its SQL editor.
2. Configure Site runtime values `SUPABASE_URL`, `SUPABASE_ANON_KEY` (public publishable/anon key), and `SUPABASE_SERVICE_ROLE_KEY` (secret). The service role key stays server-side.
3. Configure the Supabase Auth Site URL and permitted redirect URLs to the deployed Site origin. Enable email/password auth and configure production email delivery as appropriate.
4. Set `ADMIN_EMAIL` to the exact verified email of the bakery administrator. Privileges are checked on every server request, never accepted from browser state or profile metadata. With no setting, management is securely disabled.
5. Redeploy the Site. Supabase Auth enables sign-up, sign-in, sign-out, reset email, and password update. With the service key set, catalog, profiles, cart, wishlist, orders, reviews and inquiries use Supabase.

The Supabase database starts independently of D1. Existing D1 records are not automatically copied, and ChatGPT identities differ from Supabase user IDs; plan account/data migration before changing a store with real customers. Never expose service-role credentials in client code. Tables use RLS with direct browser access revoked; the server checks every owner and admin operation before accessing them. The order RPC is restricted to service_role and uses row locks.

## Administration and payments

Admin route: `/#admin`. No unauthenticated preview or client-side role override grants access. Set `ADMIN_EMAIL`, then sign in with that verified email. Revenue charts count collected totals of delivered orders, by order date. Product removal archives inventory so past order data stays intact.

Checkout is pay-on-delivery only. No card information is requested and no payment success is simulated. Real online payments require a payment provider integration. Confirm delivery zones, business contact details, product recipes/allergens, prices, tax treatment, and fulfillment before opening to customers.

## Development

Use the installed pnpm runtime. `pnpm dev`, `pnpm exec tsc --noEmit`, `pnpm build`. Database schema is in `db/schema.ts`. Generate migrations with `pnpm db:generate`; local migrations use the Sites starter workflow. The Sites build and publishing helpers preserve deployment configuration.
