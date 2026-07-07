# TEST_COVERAGE_PLAN.md — Pre-Upgrade Test Coverage Plan

## 1. Purpose

Happy House is about to undergo major framework and infrastructure upgrades (Rails,
Ruby, webpacker, and related gems). Before any upgrade branch is cut, every existing
feature and critical path must be covered by tests so that upgrade regressions are
caught by the suite instead of in production.

This document is a work plan. Each task is written so it can be executed
independently, in order, by an engineer or AI agent with no additional context beyond
this file and the repository.

---

## 2. Ground Rules for Executors

**Read this section before starting any task.**

1. **Tests characterize CURRENT behavior.** Do not "fix" application code, even when
   it looks wrong. The point of this suite is to pin down what the app does *today*
   so upgrades can be verified against it. Known bugs are listed in §4 — when a task
   touches one, test the working path and add a code comment in the spec referencing
   the bug ID (e.g. `# See TEST_COVERAGE_PLAN.md BUG-1`).
2. **You may only modify these paths:**
   - `spec/**` (all test code, factories, fixtures, support files)
   - `Gemfile` / `Gemfile.lock` (Phase 0 only, to add simplecov)
   - Never touch `app/`, `lib/`, `config/`, `db/`.
3. **Write request specs, not controller specs.** `type: :controller` specs are
   deprecated in modern Rails and will fight the upgrade. New coverage for
   controllers goes in `spec/requests/`. Existing controller specs are left alone
   unless a task says otherwise. (`config.infer_spec_type_from_file_location!` is
   enabled, so file location sets the spec type automatically.)
4. **Match existing style**: `# frozen_string_literal: true` at the top of every new
   file, `require "rails_helper"`, RSpec `describe`/`context`/`let` style as seen in
   `spec/models/lease_spec.rb` and `spec/models/user_spec.rb`. Use `FactoryBot.create(...)`
   explicitly (the suite does not include FactoryBot syntax methods).
5. **Running tests:**
   - With Docker (preferred, matches the README): `./test spec/path/to/file_spec.rb`
     (runs `docker-compose run --rm web bundle exec rspec ...`). Run the whole suite
     with `./test`.
   - Directly: `bundle exec rspec spec/path/to/file_spec.rb` — requires a Postgres
     reachable via the `DB_HOST` / `DB_USERNAME` / `DB_PASSWORD` env vars used in
     `.env.test.local` (see README "Testing" section).
6. **Acceptance criteria for every task** (in addition to task-specific criteria):
   - The new/changed spec files pass.
   - The **full** suite passes (`./test`). No new `pending`/`skipped` examples unless
     the task explicitly says to skip something.
7. **One task = one commit/PR.** Keep diffs reviewable.
8. **External services**: The HappyHood price-history API integration
   (`app/services/happy_hood/client.rb`, `price_history_service.rb`, `zpid_finder.rb`)
   is **deprecated and unused in production**. Do not write new tests for it; do not
   let any new test make a real HTTP call. In any spec touching `PropertiesController#show`,
   build the property with `zpid: nil` (the factory default) so `PriceHistoryService`
   short-circuits and returns `{}` without a network call.

---

## 3. Current State Inventory

Test stack: RSpec (`rspec-rails`), FactoryBot, Capybara (rack_test driver only — no
JS/selenium), Faker. CI: `.github/workflows/workflow.yml` (GitHub Actions + Postgres
service, runs `bundle exec rspec`).

### Coverage by component

| Component | File(s) | Status |
|---|---|---|
| `User` model | `spec/models/user_spec.rb` | ✅ Good (validations, email rules, activation digest) |
| `Lease` model — date/status methods | `spec/models/lease_spec.rb` | ✅ Good (`expired?`, `started?`, `upcoming?`, `expiring_soon?`, `expiration_status`) |
| `Lease` model — `.active`, `.build_lease!`, `with_eager_loaded_contract` | — | ❌ None |
| `Tenant` model | `spec/models/tenant_spec.rb` | ✅ Good |
| `UserMailer` | `spec/mailers/user_mailer_spec.rb` | ✅ Good |
| `LeaseMailer` | `spec/mailers/lease_mailer_spec.rb` | ❌ Pending stub |
| `Property` model | `spec/models/property_spec.rb` | ❌ Pending stub |
| `ExpenseItem` model | `spec/models/expense_item_spec.rb` | ❌ Pending stub |
| `Event`, `InsuranceDocument`, `PurchaseDocument`, `LeaseTenant`, `LeaseFrequency`, `PropertyDocument(Type)`, `UtilityAccount` models | various `spec/models/*` | ❌ Pending/empty stubs |
| `MortgageStatement` model | — | ❌ No spec file at all |
| Signup / activation / password reset flows | — | ❌ None |
| `SessionsController` create/destroy (login/logout/remember-me) | `spec/controllers/sessions_controller_spec.rb` | ❌ Only `GET #new` smoke test |
| `SessionsHelper` (`current_user`, cookies) | `spec/helpers/sessions_helper_spec.rb` | ❌ Empty stub |
| `PropertiesController` (all 7 actions) | — | ❌ None |
| `ExpenseItemsController` (CRUD + report) | `spec/controllers/expense_items_controller_spec.rb` | ❌ Empty stub |
| `MortgageExpensesController` / `HoaExpensesController` | — | ❌ None |
| `LeasesController` (CRUD, PDF, renewal, signed upload) | `spec/controllers/leases_controller_spec.rb` | ❌ All-`xit` scaffold; `spec/requests/leases_spec.rb` has one heavily-mocked 200 check |
| `EventsController` | — | ❌ None |
| `InsuranceDocumentsController` | `spec/features/insurance_documents_spec.rb` | ⚠️ Partial (index + upload feature spec) |
| `PurchaseDocumentsController`, `MortgageStatementsController` | — | ❌ None |
| `HappyHouse::PropertyInterface` | `spec/happy_house/property_interface_spec.rb` | ⚠️ Only `#transfer_ownership`; 5 methods untested |
| `HappyHouse::Taxes::ExpenseReports::Builder` | — | ❌ None |
| `HappyHouse::Expenses::YearlyMortgage/YearlyHoa` + `ExpenseItemHelpers::OneOffUploaders` | — | ❌ None |
| `Leases::Renewer` service | — | ❌ None |
| `HappyHouse::Leases::Generator` (PDF) | — | ❌ None |
| `daily_lease_reminder` rake task | — | ❌ None |
| `ApplicationRecord.newest/.oldest` | — | ❌ None |
| HappyHood client / PriceHistoryService / ZpidFinder | `spec/services/**` | ✅ Adequate — **deprecated, do not extend** |

### Known factory problems (fixed in Phase 0)

Almost every factory in `spec/factories/` was generator-scaffolded and is unusable
as-is: `nil` associations (`events`, `insurance_documents`, `purchase_documents`,
`lease_tenants`, `utility_accounts`, `expense_items`), the `lease` factory lacks its
required `property`, document factories don't attach files (models validate
`document` presence), there is no `mortgage_statement` factory, and the `user`
factory has no `:activated` trait (nearly every request spec needs an activated user
to log in).

---

## 4. Known Bugs — Characterize, Do NOT Fix

| ID | Location | Bug | Instruction for test authors |
|---|---|---|---|
| BUG-1 | `app/controllers/events_controller.rb` `#create`, JSON success branch | `location: [@current_user, @property, event]` references undefined local `event` → NameError on `format.json` success | Test the HTML create path only. Add a comment in the spec noting the JSON success path is broken. |
| BUG-2 | `app/controllers/mortgage_expenses_controller.rb` and `hoa_expenses_controller.rb` | **VERIFIED**: both controllers read `params[:id]`, but the nested route only provides `:property_id` — GET/POST without an explicit `?id=` raises `ActiveRecord::RecordNotFound`. With `id` passed, `#create` builds the 12 expense items and then raises `NameError` on `redirect_to property_path` (helper doesn't exist). The only UI links to these pages are `disabled` in `properties/show`. | Pinned in `spec/requests/mortgage_and_hoa_expenses_spec.rb`. |
| BUG-3 | `app/controllers/leases_controller.rb` `#create_renewal` failure branch | Raises `StandardError` instead of re-rendering the form (`render :new_renewal` is dead code after `raise`) | Test the success path fully. For the failure path, assert the error is raised. |
| BUG-4 | `app/services/leases/renewer.rb` | `rescue => error` swallows every exception into `OpenStruct(success?: false)` | This is intentional-ish; just cover both branches. |
| BUG-5 | `app/controllers/properties_controller.rb` `#update` | Uses `Property.find_by(id: ...)` then unconditional `@property.update` — nil property would NoMethodError, but `correct_user` filter runs first so it's unreachable in practice | No action; noted so nobody "discovers" it mid-task. |
| BUG-6 | `properties#upload_files` | **VERIFIED** dead feature: no view invokes it, `correct_user` reads `params[:id]` (route provides `:property_id`) → always `ActiveRecord::RecordNotFound`; even with the right id it would fail because `has_many_attached :documents` is commented out of the Property model. | Pinned in `spec/requests/properties_spec.rb`. Candidate for deletion during upgrades. |
| BUG-7 | `expense_items#show` | **VERIFIED**: no `expense_items/show` template exists → `ActionController::MissingExactTemplate` on every request. The UI links to edit, not show — dead action. | Pinned in `spec/requests/expense_items_spec.rb`. |
| BUG-8 | `mortgage_statements#show` / `#edit` | **VERIFIED**: neither template exists (only `index.slim`/`new.slim`) → `MissingExactTemplate`; a failed update's `render :edit` raises `ActionView::MissingTemplate`. Valid updates still work (redirect, no render). | Pinned in `spec/requests/mortgage_statements_spec.rb`. |
| BUG-9 | `leases#show` PDF format | ~~VERIFIED broken~~ **FIXED** by the wicked_pdf → ferrum_pdf swap (pulled forward into the bare-metal step): the ferrum_pdf renderer renders `leases/show` with `formats: [:html]`, so the template-lookup failure is gone and the PDF download works again. | Real-PDF canary restored in `spec/requests/leases_crud_spec.rb`. |

Sentry note: `sentry-rails` 5.7 breaks exception propagation under Rails 7.1
(`request.show_exceptions?` was removed), so `Sentry.init` is skipped in the test
environment (`config/initializers/sentry.rb`). The gem needs a bump during upgrades.

If you discover a **new** bug while writing tests: do not fix it. Pin the current
behavior in the spec if reasonable (or leave the case untested with a comment), and
add a row to this table in your PR.

---

## 5. Phases and Tasks

Execute phases in order. **Phase 0 blocks everything else.** Within a phase, tasks
are independent unless noted.

Priority meaning: **P0** = auth/security-critical, must exist before upgrades.
**P1** = core product flows. **P2** = supporting features. **P3** = nice-to-have.

---

### Phase 0 — Test Infrastructure (blocking)

#### TASK-0.1: Add SimpleCov
- **Files**: `Gemfile`, `spec/spec_helper.rb`
- Add to the `group :test` block in the Gemfile:
  ```ruby
  gem "simplecov", require: false
  ```
  Run `bundle install` (via `docker-compose run --rm web bundle install` if using Docker;
  commit the `Gemfile.lock` change).
- At the **very top** of `spec/spec_helper.rb` (before anything else is required):
  ```ruby
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter "/spec/"
    add_group "Services", "app/services"
    add_group "Lib", "lib/happy_house"
    track_files "{app,lib/happy_house}/**/*.rb"
  end
  ```
- **Acceptance**: `./test` passes and prints a coverage summary; `coverage/` is in
  `.gitignore` (add it if missing — check first, `.gitignore` may already have it).

#### TASK-0.2: Enable `spec/support` and add auth helpers
- **Files**: `spec/rails_helper.rb`, `spec/support/auth_helpers.rb` (new)
- In `spec/rails_helper.rb`, uncomment the existing line:
  ```ruby
  Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
  ```
- Create `spec/support/auth_helpers.rb`:
  ```ruby
  # frozen_string_literal: true

  module AuthHelpers
    # For request specs: performs a real login POST.
    # user must be activated and have password "password" (factory default).
    def log_in_as(user, password: "password", remember_me: "0")
      post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me } }
    end
  end

  module FeatureAuthHelpers
    # For feature specs: logs in through the UI.
    def feature_log_in(user, password: "password")
      visit "/login"
      within("form") do
        fill_in "Email", with: user.email
        fill_in "Password", with: password
      end
      click_button "Log in"
    end
  end

  RSpec.configure do |config|
    config.include AuthHelpers, type: :request
    config.include FeatureAuthHelpers, type: :feature
  end
  ```
- **Acceptance**: full suite still green (the existing feature spec must not break).

#### TASK-0.3: Add file-upload helper and shared fixture
- **Files**: `spec/support/file_helpers.rb` (new)
- A plain-text fixture already exists at
  `spec/fixtures/insurance_documents/upload_test_file.txt`. Reuse it for all
  attachment needs:
  ```ruby
  # frozen_string_literal: true

  module FileHelpers
    FIXTURE_FILE_PATH = Rails.root.join("spec", "fixtures", "insurance_documents", "upload_test_file.txt")

    # For request specs / params
    def uploaded_test_file
      Rack::Test::UploadedFile.new(FIXTURE_FILE_PATH, "text/plain")
    end
  end

  RSpec.configure do |config|
    config.include FileHelpers
  end
  ```
- **Acceptance**: full suite green.

#### TASK-0.4: Repair all factories
- **Files**: everything under `spec/factories/`, plus new `spec/factories/mortgage_statements.rb`
- Column names below are verified against `db/schema.rb`. Make exactly these changes:
  - **users.rb** — add a trait:
    ```ruby
    trait :activated do
      activated { true }
      activated_at { Time.zone.now }
    end
    ```
  - **properties.rb** — add `user` association (`user { FactoryBot.create(:user) }` or `association :user`), keep existing address/property_type/nickname. Do **not** set `zpid` (must default to nil — see Ground Rule 8).
  - **leases.rb** — add `property`, and an `amount { 1500.00 }`; change fixed date strings to relative dates: `start_date { 1.month.ago }`, `end_date { 11.months.from_now }`. Keep the `lease_frequency` association.
  - **events.rb** — replace `property { nil }` with a real `property` association; add `title { "MyEvent" }`.
  - **expense_items.rb** — add `property` association; keep name/cost; make `expense_date { Date.new(2024, 6, 15) }` (a fixed, assertable date).
  - **insurance_documents.rb** — real `property` association, `title { "Insurance Policy" }`, and attach the document (model validates presence):
    ```ruby
    document { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "insurance_documents", "upload_test_file.txt"), "text/plain") }
    ```
  - **purchase_documents.rb** — same pattern as insurance_documents (`title`, `property`, attached `document`).
  - **mortgage_statements.rb** (new file) — same pattern: `property` association, `title { "Mortgage Statement" }`, attached `document`.
  - **lease_tenants.rb** — replace nils with `tenant` and `lease` associations.
  - **utility_accounts.rb** — replace `property { nil }` with `property` association.
  - **tenants.rb** — set `email { Faker::Internet.email }`, `name { Faker::Name.name }`.
  - **lease_frequencies.rb**, **property_document_types.rb**, **property_documents.rb** — leave as-is (dead/unused features).
- Add a smoke spec `spec/factories_spec.rb` that proves the important factories build valid records:
  ```ruby
  # frozen_string_literal: true

  require "rails_helper"

  RSpec.describe "Factories" do
    %i[user property lease event expense_item insurance_document
       purchase_document mortgage_statement tenant lease_tenant].each do |name|
      it "#{name} factory is valid" do
        expect(FactoryBot.create(name)).to be_persisted
      end
    end

    it "user :activated trait works" do
      expect(FactoryBot.create(:user, :activated)).to be_activated
    end
  end
  ```
- **Watch out**: `tenant_spec.rb` passes `property:` explicitly to the lease factory
  — adding a default `property` association must not break it (it won't; explicit
  args override). Run it to confirm.
- **Acceptance**: `spec/factories_spec.rb` green; full suite green.

#### TASK-0.5: Remove the dead LeasesController scaffold spec
- **Files**: delete `spec/controllers/leases_controller_spec.rb`
- It is 100% `xit`/`skip` generator scaffold and provides nothing. Real coverage
  arrives in Phase 3 as request specs.
- **Acceptance**: full suite green.

---

### Phase 1 — Authentication & Authorization (P0)

These are the highest-value tests in the plan. The auth system is hand-rolled
(Hartl-tutorial style) and touches sessions, signed/permanent cookies, BCrypt, and
mailers — all sensitive to Rails upgrades.

#### TASK-1.1: Signup + account activation flow (request spec)
- **Files**: `spec/requests/signup_and_activation_spec.rb` (new)
- Cover, using real records (no mocking):
  1. `GET /start` renders 200.
  2. `POST /users` with valid params: creates a `User` (`change(User, :count).by(1)`),
     user is **not** activated, exactly one email is delivered
     (`ActionMailer::Base.deliveries`), flash tells them to check email, redirect to root.
     (Note: mailer uses `deliver_now`; clear `deliveries` in a `before` block.)
  3. `POST /users` with invalid params (e.g. short password): no user created,
     response re-renders the signup form (200 body contains the form).
  4. Activation success: create an unactivated user via `User.new(...).save` or the
     factory, capture `user.activation_token` (only present on the in-memory
     instance right after create — create the record inside the example), then
     `GET /account_activations/:token/edit?email=...`. Assert user reloaded is
     `activated`, session is logged in (follow redirect; page shows logged-in state),
     redirect to user page.
  5. Activation failure cases (each redirects to root with danger flash):
     wrong token, wrong email, already-activated user.
- **Acceptance**: file green; full suite green.

#### TASK-1.2: Login / logout / remember-me (request spec)
- **Files**: `spec/requests/sessions_spec.rb` (new)
- Cover with real users (`FactoryBot.create(:user, :activated)`):
  1. Valid login → redirect to root (then root redirects to properties), session works
     (subsequent `GET /users/:id` succeeds instead of redirecting to /login).
  2. Login is case-insensitive on email (login with `user.email.upcase`).
  3. Wrong password → 200 re-render with danger flash.
  4. Unknown email → 200 re-render with danger flash.
  5. **Unactivated** user with correct password → redirect to root with warning flash, not logged in.
  6. `remember_me: "1"` → response sets `user_id` and `remember_token` cookies, and
     user's `remember_digest` becomes non-nil.
  7. `remember_me: "0"` → `remember_digest` stays nil / cookies not set.
  8. `DELETE /logout` → session cleared (protected page redirects to login afterward), redirect to root.
  9. Friendly forwarding: hit `GET /users/:id/edit` while logged out → redirected to
     /login; after logging in, you are redirected back to the edit page
     (`redirect_back_or` / `store_location` behavior).
- **Acceptance**: file green; full suite green.

#### TASK-1.3: Password reset flow (request spec)
- **Files**: `spec/requests/password_resets_spec.rb` (new)
- Cover:
  1. `GET /password_resets/new` → 200.
  2. `POST /password_resets` with a known email → sets `reset_digest`/`reset_sent_at`
     on the user, sends one email, redirects to login with info flash.
  3. `POST /password_resets` with unknown email → **same** flash/redirect (no user
     enumeration), no email sent.
  4. `GET /password_resets/:token/edit?email=...` with valid token → 200 form.
  5. Same with invalid token or wrong email → redirect to root.
  6. Expired reset (`reset_sent_at` > 2 hours ago — use `user.update_columns(reset_sent_at: 3.hours.ago)`) → redirect to `new_password_reset_url` with danger flash.
  7. `PATCH /password_resets/:token` with blank password → re-renders edit.
  8. With mismatched confirmation → re-renders edit.
  9. With valid new password → user can log in with the new password, success flash,
     redirect to user.
  - To get a valid token in specs: call `user.create_reset_digest` then read
    `user.reset_token` (attr_accessor, in-memory).
- **Acceptance**: file green; full suite green.

#### TASK-1.4: `SessionsHelper` unit spec
- **Files**: `spec/helpers/sessions_helper_spec.rb` (replace the empty stub)
- Helper specs get `session` and `cookies` for free. Cover:
  1. `log_in(user)` sets `session[:user_id]`; `current_user` returns the user;
     `logged_in?` is true; `current_user?(user)` true / other user false.
  2. `current_user` returns nil (and `logged_in?` false) with empty session.
  3. `log_out` clears session and `@current_user`.
  4. Remember-cookie path: call `remember(user)`, clear `session`, assert
     `current_user` re-authenticates from `cookies.signed[:user_id]` +
     `cookies[:remember_token]` and logs the user in.
     (Note: in helper specs `cookies.permanent.signed` works; if it proves flaky,
     cover the cookie path via the request spec in TASK-1.2 case 6 and assert here
     only `remember` sets `remember_digest`. Document whichever you did.)
  5. `forget(user)` nils the digest and deletes cookies.
- **Acceptance**: file green; full suite green.

#### TASK-1.5: Authorization guard (`correct_user`) shared examples
- **Files**: `spec/support/shared_examples/correct_user.rb` (new),
  `spec/requests/authorization_spec.rb` (new)
- Every nested controller has a `correct_user` filter that must redirect strangers
  to root. Create a shared example:
  ```ruby
  # frozen_string_literal: true

  RSpec.shared_examples "redirects other users to root" do
    it "redirects a different logged-in user to root" do
      log_in_as(other_user)
      subject
      expect(response).to redirect_to(root_url)
    end
  end
  ```
- In `authorization_spec.rb`, set up `owner` (activated user), `other_user`
  (activated user), and `property` belonging to `owner`, plus one child record each
  (lease, expense_item, event, insurance_document, purchase_document,
  mortgage_statement). Apply the shared example to at least these GET endpoints
  (each as a `describe` with `subject { get <path> }`):
  - `user_property_path(owner, property)` (properties#show)
  - `edit_user_property_path(owner, property)`
  - `user_property_expense_items_path(owner, property)`
  - `user_property_leases_path(owner, property)`
  - `user_property_events_path(owner, property)`
  - `user_property_insurance_documents_path(owner, property)`
  - `user_property_purchase_documents_path(owner, property)`
  - `user_property_mortgage_statements_path(owner, property)`
  - `user_property_new_mortgage_expense_path(owner, property)` and
    `user_property_new_hoa_expense_path(owner, property)`
  - Run `bundle exec rails routes` (or `docker-compose run --rm web rails routes`) if a
    helper name doesn't match; use whatever the routes file actually generates.
- Also cover `UsersController#correct_user`: logged-in user A requesting
  `edit_user_path(user_b)` is redirected to A's own page (`current_user`), not root.
- Also cover unauthenticated access: logged-out `GET user_property_leases_path(...)`
  currently behaves how? (`logged_in?` before_action returns a boolean, it does not
  redirect; `correct_user` compares against nil `current_user` and redirects to root.)
  Assert the redirect-to-root behavior for at least leases and insurance_documents
  while logged out.
- **Acceptance**: file green; full suite green.

---

### Phase 2 — Properties & Expenses (P1)

#### TASK-2.1: `Property` model spec
- **Files**: `spec/models/property_spec.rb` (replace pending stub)
- Cover:
  1. Factory produces a valid property.
  2. `property_type` presence + inclusion: each value of `Property::PROPERTY_TYPES`
     (titleized, e.g. `"Single Family Home"`) is valid; `"Castle"` and `nil` are invalid.
  3. `display_name`: returns nickname when present; returns
     `address["street_address"]` when nickname is blank (`nil` and `""`).
  4. Scopes: create one property of each type, assert `Property.townhomes`,
     `.single_family_homes`, `.apartments`, `.condos`, `.commercials` each return
     exactly the right record.
  5. `expense_years`: property with expense items dated in 2022, 2023, 2023, 2024 →
     returns `[2024, 2023, 2022]` (unique, descending).
  6. `property_interface` returns a `HappyHouse::PropertyInterface` memoized instance.
- **Acceptance**: file green; full suite green.

#### TASK-2.2: `PropertiesController` request specs
- **Files**: `spec/requests/properties_spec.rb` (new)
- Setup: `user = FactoryBot.create(:user, :activated)`, `log_in_as(user)`.
- Cover:
  1. `GET /users/:id/properties` (index) → 200, lists the user's properties.
  2. `GET .../properties/new` → 200.
  3. `POST .../properties` valid (nested `address` params:
     `{ property: { nickname:, property_type: "Condo", address: { street_address:, city:, state:, zip_code: } } }`)
     → creates record, success flash, redirect to root.
  4. `POST` invalid (missing property_type) → 200 re-render, no record.
  5. `GET .../properties/:id` (show) → 200. Property must have `zpid: nil`
     (Ground Rule 8).
  6. `GET .../properties/:id/edit` → 200.
  7. `PATCH` valid → updates nickname, success flash, redirect to the user.
  8. `PATCH` invalid (`property_type: "Castle"`) → re-renders edit, record unchanged.
  9. `PATCH .../upload_files` with `{ property: { documents: [uploaded_test_file] } }`
     → info flash, redirect to property page. (Note: `Property` has no
     `has_many_attached :documents` — it's commented out in the model. Verify what
     actually happens: `update` with unknown attribute likely raises. If it raises,
     pin that behavior with `raise_error` and note it as a new bug row in §4.)
- **Acceptance**: file green; full suite green.

#### TASK-2.3: `ExpenseItem` model + `ExpenseItemsController` request specs
- **Files**: `spec/models/expense_item_spec.rb` (replace stub),
  `spec/requests/expense_items_spec.rb` (new)
- Model spec:
  1. Validations: name, cost, expense_date presence.
  2. `for_year` scope: items in 2023 and 2024; `ExpenseItem.for_year(2023)` returns
     only the 2023 item.
  3. Can attach multiple `attachments` (attach two fixtures, assert
     `attachments.count == 2`).
- Request spec (logged-in owner; property belongs to them):
  1. `GET .../expense_items` (index) → 200; shows yearly summary (create items in
     two different years; body includes both years).
  2. `GET .../expense_items/new` → 200.
  3. `POST` valid → creates item, info flash, redirect to index.
  4. `POST` invalid (blank name) → 200 re-render, no record.
  5. `GET .../expense_items/:id` (show) → 200.
  6. `GET .../expense_items/:id/edit` → 200; `PATCH` valid → success flash + redirect
     to index; `PATCH` invalid → re-render.
  7. `GET .../expense_items/report?expense_year=2024` → 200; body includes the 2024
     item names and total (this exercises `PropertyInterface#build_expense_report`
     and `#monthly_expense_summary` end-to-end — the groupdate upgrade canary).
- **Acceptance**: files green; full suite green.

#### TASK-2.4: `HappyHouse::PropertyInterface` — remaining methods
- **Files**: `spec/happy_house/property_interface_spec.rb` (extend the existing file;
  keep the `#transfer_ownership` block)
- Cover with real DB records (groupdate needs real SQL):
  1. `yearly_expense_summary`: items of cost 10.5 and 20.25 in 2023, 5 in 2024 →
     `{ "2023" => "30.75", "2024" => "5.00" }` (values are formatted strings).
  2. `monthly_expense_summary(year)`: two items in June 2024, one in July 2024 →
     keys formatted `"Jun 2024"`, `"Jul 2024"`, string-formatted sums; items from
     other years excluded.
  3. `build_expense_report(year:)`: returns `{ total_cost:, expenses: [...] }`,
     expenses sorted by date, each item hash has `:id, :name, :cost, :date`.
  4. `build_yearly_hoa_payments` / `build_yearly_mortgage_payment`:
     - Missing `:year` or `:monthly_payment` → raises `ArgumentError` with the
       matching message.
     - Valid params (`{ year: "2024", monthly_payment: "150.0" }`) → creates 12
       expense items (see TASK-2.5 for detailed assertions; here just count + delegation).
- **Acceptance**: file green; full suite green.

#### TASK-2.5: Yearly payment generators (`OneOffUploaders` / `YearlyMortgage` / `YearlyHoa`)
- **Files**: `spec/models/expense_item_helpers/one_off_uploaders_spec.rb` (new)
- Cover `ExpenseItem.create_yearly_mortgage_payments!(property, 2024, 1200.50)`:
  1. Creates exactly 12 `ExpenseItem`s for the property.
  2. Names are `"1-2024 Mortgage Payment"` … `"12-2024 Mortgage Payment"`.
  3. Each cost equals the amount; expense_dates are the 1st of each month of 2024.
  4. Same for `create_yearly_hoa_payments!` with `"... HOA Payment"` names.
  5. One thin spec for the `HappyHouse::Expenses::YearlyMortgage.create_new_mortgage_payments!`
     and `YearlyHoa.create_new_hoa_payments!` wrappers (12 records created) — can
     live in the same file or in `spec/happy_house/expenses_spec.rb`.
- **Acceptance**: file green; full suite green.

#### TASK-2.6: Mortgage/HOA expense controllers (BUG-2 verification)
- **Files**: `spec/requests/mortgage_and_hoa_expenses_spec.rb` (new)
- Logged-in owner. Cover for BOTH controllers (they're near-identical):
  1. `GET` index (`user_property_new_mortgage_expense_path` /
     `user_property_new_hoa_expense_path`) → 200.
  2. `POST` create with `{ year: "2024", monthly_payment: "100.0" }`:
     - Assert 12 expense items are created.
     - Then pin the redirect behavior. Per BUG-2 the `redirect_to property_path` is
       expected to raise. Verify empirically: if it raises, wrap in
       `expect { ... }.to raise_error(NoMethodError)` (or the actual error class) AND
       assert the ExpenseItem count changed by 12 (creation happens before the
       redirect). If it somehow succeeds, assert the flash and redirect instead.
       Update §4 BUG-2 row with what you found.
  3. Wrong user → shared example "redirects other users to root".
- **Acceptance**: file green; full suite green; §4 updated with verified BUG-2 behavior.

---

### Phase 3 — Leases (P1)

#### TASK-3.1: `Lease` model — untested class methods & scopes
- **Files**: `spec/models/lease_spec.rb` (extend existing file; don't touch the
  existing method specs)
- Cover:
  1. `.active`: leases (past, current, future) → only current returned; also test
     with an explicit timestamp argument.
  2. `.build_lease(property, lease_details, lease_pdf)`: pass
     `lease_details = { tenants: [tenant], starting_date: ..., rent_amount: 1000, ending_date: ... }`
     and a fake pdf string (`"%PDF-1.4 fake"`). Assert: not persisted, property set,
     tenants set, dates/amount mapped, `lease_frequency_id == 1`, `contract.attached?`
     is true with `content_type: "application/pdf"`.
     (Note: a `LeaseFrequency` with id 1 must exist — create one and, if ids drift,
     use `FactoryBot.create(:lease_frequency)` and assert `lease_frequency_id == 1`
     only if that's the record's id; otherwise just assert it equals 1 per the
     hardcoding and create the record with `id: 1` explicitly:
     `LeaseFrequency.create!(id: 1, frequency: "monthly")`.)
  3. `.build_lease!`: same but persisted (`change(Lease, :count).by(1)`).
  4. `with_eager_loaded_contract` scope: returns leases; smoke-assert it includes a
     lease with an attached contract and doesn't raise.
- **Acceptance**: file green; full suite green.

#### TASK-3.2: `LeasesController` request specs (replaces the deleted scaffold)
- **Files**: `spec/requests/leases_crud_spec.rb` (new; leave the existing thin
  `spec/requests/leases_spec.rb` alone)
- Setup: activated owner, their property, `LeaseFrequency.create!(id: 1, frequency: "monthly")`,
  a lease via factory. Log in as owner.
- Cover:
  1. `GET index` → 200, newest-first ordering (create two leases with different
     start_dates, assert order in body or via `assigns`-free body regex).
  2. `GET new` → 200. `GET edit` → 200.
  3. `POST create` valid (`lease: { start_date:, end_date:, amount:, lease_frequency_id: }`)
     → +1 lease, redirect to lease page with notice.
  4. `POST create` invalid — Lease validates `belongs_to` only, which the controller
     sets; try `lease_frequency_id: nil` → re-renders new, no record.
  5. `GET show` (HTML) → 200.
  6. `GET show.pdf` → 200 with `Content-Type: application/pdf` and body starting with
     `%PDF`. **This is the wicked_pdf upgrade canary — do not stub it.** (wkhtmltopdf
     ships via the `wkhtmltopdf-binary` gem, works in the Docker/CI environment.)
  7. `PATCH update` valid → redirect with notice; invalid (`lease_frequency_id: nil`)
     → re-render edit.
  8. `DELETE destroy` → -1 lease, redirect to index.
  9. `PATCH upload_signed_lease` with `{ lease: { signed_contract: uploaded_test_file } }`
     → success flash, `lease.reload.signed_contract.attached?` true, redirect to lease.
  10. `GET new_renewal` (route: `user_property_lease_new_renewal_path(user, property, lease_id: lease.id)` —
      check `rails routes`; the nested route uses `lease_id`) → 200, body contains the
      default dates derived from the old lease's end_date.
- **Acceptance**: file green; full suite green.

#### TASK-3.3: Lease renewal — `Leases::Renewer` + `create_renewal` endpoint
- **Files**: `spec/services/leases/renewer_spec.rb` (new), plus a `describe "POST create_renewal"`
  block in `spec/requests/leases_crud_spec.rb`
- Renewer service spec:
  1. Success path: build params
     `{ property: property, original_lease: original_lease, lease: { start_date: "2025-01-01", end_date: "2026-01-01", amount: "1800" } }`
     where `original_lease` has tenants. Stub the PDF generation only:
     `allow_any_instance_of(HappyHouse::Leases::Generator).to receive(:generate!).and_return("%PDF-fake")`.
     Assert: returns `success?: true`, payload is a persisted `Lease` with the
     original lease's tenants, new dates/amount, attached contract.
  2. Failure path: make `Generator` raise → returns `success?: false`, payload is the
     error message string, no lease created (BUG-4 documented behavior).
- Endpoint spec (`POST user_property_lease_create_renewal_path(...)` — verify helper
  via `rails routes`):
  3. Success: with Generator stubbed as above → redirect to the new lease with notice.
  4. Failure: Generator raises inside Renewer → controller raises `StandardError`
     (BUG-3): `expect { post ... }.to raise_error(StandardError, /Could not renew/)`.
- **Acceptance**: files green; full suite green.

#### TASK-3.4: `HappyHouse::Leases::Generator` (real PDF integration canary)
- **Files**: `spec/happy_house/leases/generator_spec.rb` (new)
- The only template on disk is
  `app/views/leases/templates/standard_residential_fl.html.erb`, so `state` must be
  `"FL"`/`"fl"` in the details.
- Cover:
  1. `generate!` with a full details hash (`street_address, city, state: "FL",
     zip_code, tenants: [tenant], starting_date, ending_date, rent_amount,
     lease_creation_date, landlord_name, landlord_email` — see
     `app/services/leases/renewer.rb` for the exact shape) returns a String starting
     with `%PDF` (real WickedPdf render — upgrade canary, do not stub).
  2. Unknown state (e.g. `state: "CA"`) → raises `Errno::ENOENT` (missing template).
- Inspect the template first (`app/views/leases/templates/standard_residential_fl.html.erb`)
  to see which keys it actually interpolates; make the details hash satisfy it
  (e.g. tenants may need `name` methods — pass real `Tenant` records).
- **Acceptance**: file green; full suite green.

#### TASK-3.5: `LeaseMailer` + daily reminder rake task
- **Files**: `spec/mailers/lease_mailer_spec.rb` (replace pending stub),
  `spec/tasks/daily_lease_reminder_spec.rb` (new)
- Mailer spec (mirror the style of `spec/mailers/user_mailer_spec.rb`):
  1. `LeaseMailer.with(lease: lease).expiration_reminder`: subject
     `"Lease Expiration Reminder"`, to == property owner's email, from
     `"noreply@happyhouse.live"`, body includes the new_renewal URL for the lease.
- Rake task spec:
  ```ruby
  before do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
    Rake::Task["daily_lease_reminder_job:run"].reenable
  end
  ```
  1. A currently-active lease whose `end_date` is exactly 4 months from today →
     invoking the task delivers exactly one `expiration_reminder`.
  2. Active lease ending 5 months out, and an expired lease → no mail.
  - Use `ActionMailer::Base.deliveries` (task uses `deliver_now`). Construct the
    qualifying lease as `end_date: 4.months.from_now` — note the task checks
    `(l.end_date - 4.months).today?`, so set `end_date` to a time today + 4 months.
- **Acceptance**: files green; full suite green.

---

### Phase 4 — Documents & Events (P2)

#### TASK-4.1: Document model specs (3 small files)
- **Files**: `spec/models/insurance_document_spec.rb` (replace empty),
  `spec/models/purchase_document_spec.rb` (replace stub),
  `spec/models/mortgage_statement_spec.rb` (new)
- For each model, identically:
  1. Factory is valid.
  2. Invalid without `title`.
  3. Invalid without attached `document`.
  4. `belongs_to :property` (invalid without property).
- **Acceptance**: files green; full suite green.

#### TASK-4.2: `InsuranceDocumentsController` request spec (the pattern-setter)
- **Files**: `spec/requests/insurance_documents_spec.rb` (new)
- Logged-in owner + their property. Cover:
  1. `GET index` → 200; documents listed newest-first (create two, check order).
  2. `GET new` → 200.
  3. `POST create` valid (`insurance_document: { title: "Policy", document: uploaded_test_file }`)
     → +1 record, redirect to index with "Successfully Uploaded" notice.
  4. `POST create` without document → 200 re-render, no record.
  5. Logged-out access → redirect to root (the `correct_user` filter fires with nil user).
- Keep `spec/features/insurance_documents_spec.rb` as-is (it's the one end-to-end
  browser-level flow in the suite).
- **Acceptance**: file green; full suite green.

#### TASK-4.3: Purchase documents + mortgage statements request specs
- **Files**: `spec/requests/purchase_documents_spec.rb`,
  `spec/requests/mortgage_statements_spec.rb` (both new)
- Replicate the TASK-4.2 pattern exactly, plus the extra actions these controllers
  have:
  5. `GET show` → 200.
  6. `GET edit` → 200.
  7. `PATCH update` valid (change title) → redirect to the document with notice.
  8. `PATCH update` invalid (`title: ""`) → 200 re-render, title unchanged.
  - Mortgage statements additionally accept `notes` (ActionText) — include a `notes`
    value in create params and assert it persists (`record.notes.to_plain_text`).
- **Acceptance**: files green; full suite green.

#### TASK-4.4: `Event` model + `EventsController` request specs
- **Files**: `spec/models/event_spec.rb` (replace stub), `spec/requests/events_spec.rb` (new)
- Model: factory valid; belongs_to property required; `content` is ActionText
  (`has_rich_text` — set and read back `to_plain_text`).
- Request spec (logged-in owner):
  1. `GET index` → 200. Create one `Event` AND one `ExpenseItem` for the property;
     assert the page body includes **both** titles (this covers the
     expense-items-as-pseudo-events OpenStruct transform and renders the
     simple_calendar view — a key upgrade canary for both simple_calendar and
     Ruby's OpenStruct behavior).
  2. `GET show` → 200. `GET new`, `GET edit` → 200.
  3. `POST create` valid (HTML) → +1 event, redirect with notice. Do **not** test the
     JSON success path (BUG-1) — add a comment.
  4. `POST create` invalid: `Event` has no validations beyond `belongs_to` (property
     comes from the URL), so there is no reachable invalid HTML path — skip with a
     comment rather than forcing it.
  5. `PATCH update` valid → redirect with notice.
  6. `DELETE destroy` → -1 event, redirect to index.
  7. Wrong user → shared example.
- **Acceptance**: files green; full suite green.

---

### Phase 5 — Cleanup & Low Priority (P3)

#### TASK-5.1: Odds and ends
- **Files**: `spec/models/application_record_spec.rb` (new),
  `spec/requests/static_pages_spec.rb` (new)
- `ApplicationRecord.newest` / `.oldest`: using `User`, create two records with
  different `created_at` (`update_columns(created_at: ...)`), assert `.newest`
  returns the most recent. **Heads-up**: read the implementation — both methods
  order `created_at: :desc` and take `.first`/`.last`, so `.oldest` genuinely
  returns the oldest. Assert actual behavior.
- Static pages: `/help`, `/about`, `/contact` → 200 logged out; `/` logged out → 200;
  `/` logged in → redirect to `user_properties_path(current_user)`.
- **Acceptance**: files green; full suite green.

#### TASK-5.2: Stub-spec hygiene
- **Files**: `spec/models/{lease_frequency,lease_tenant,property_document,property_document_type,utility_account}_spec.rb`
- Replace each `pending "add some examples..."` with a one-line association smoke
  test (e.g. `it { expect(FactoryBot.create(:lease_tenant)).to be_persisted }`) or,
  for the dead `PropertyDocument`/`PropertyDocumentType` models (marked
  "can delete" in the code), a comment noting they are dead code slated for removal
  during the upgrade, plus a trivial `Model.new` smoke test so the file isn't pending.
  The goal: **zero `pending` examples in the suite** so upgrade runs are cleanly
  green/red.
- Also delete or fill the empty controller stubs
  `spec/controllers/{account_activations,expense_items}_controller_spec.rb`
  (both are superseded by Phase 1/2 request specs — delete them).
- **Acceptance**: `./test` output shows 0 pending examples; full suite green.

---

## 6. Explicitly Out of Scope

- **HappyHood integration** (`app/services/happy_hood/client.rb`,
  `app/services/price_history_service.rb`, `app/services/zpid_finder.rb`): deprecated,
  unused in production. Existing specs stay as-is; write nothing new. Flag for
  deletion during the upgrade itself.
- **JS-driven behavior** (Trix/ActionText editor UI, chartkick charts rendering):
  the suite has no JS driver. Request specs assert server-rendered output only.
- **View specs / routing specs**: existing ones stay; no new ones. Request specs
  render views and exercise routes already.
- **Fixing any bug in §4.**

---

## 7. Verification & Exit Criteria

The coverage effort is done — and upgrades may begin — when ALL of the following hold:

1. **Full suite green** locally (`./test`) and in GitHub Actions CI, with **0 pending
   examples**.
2. **SimpleCov** (from TASK-0.1) reports:
   - No file under `app/controllers`, `app/models`, `app/services/leases`,
     `app/mailers`, or `lib/happy_house` at 0% coverage (deprecated
     `app/services/happy_hood`, `price_history_service.rb`, `zpid_finder.rb` exempt).
   - Overall line coverage ≥ 85% across `app/` + `lib/happy_house/`.
3. **Critical-path checklist** — each of these flows has a passing request/feature spec:
   - [ ] Signup → activation email → activation
   - [ ] Login (incl. remember-me), logout, friendly forwarding
   - [ ] Password reset end-to-end
   - [ ] Cross-user authorization denied on every nested resource
   - [ ] Property create/edit/show
   - [ ] Expense item CRUD + yearly report (groupdate)
   - [ ] Bulk mortgage/HOA expense generation
   - [ ] Lease CRUD + **PDF render via wicked_pdf** + renewal + signed-contract upload
   - [ ] Lease expiration reminder (mailer + rake task)
   - [ ] All three document-upload features (insurance / purchase / mortgage statement)
   - [ ] Events CRUD + calendar index with merged expense items (simple_calendar)
4. §4 bug table updated with verified behavior for BUG-2 and any new discoveries.

Suggested upgrade-time usage: run the suite on the upgrade branch after every major
bump (Ruby, Rails, gem groups). The "canary" specs called out above (wicked_pdf PDF
bytes, groupdate summaries, simple_calendar index, OpenStruct pseudo-events,
ActiveStorage attachments, ActionText notes) are the most likely to surface breakage.
