# CLAUDE.md — AI Assistant Guide

## Project Overview

This repository is a **developer assessment framework** designed to evaluate a candidate's ability to work with legacy code **while being assisted by AI** (ChatGPT, Claude, Copilot, etc.). The goal is to observe how the candidate uses AI as a productivity tool: prompt quality, critical thinking on AI suggestions, and ability to validate output.

The project contains an intentionally poorly-written order management system that candidates must refactor within 20 minutes while preserving all existing behavior and implementing a new feature.

**Domain**: Order management system (create, retrieve, soft-delete orders with discount logic).

## Repository Structure

```
eval-candidat/
├── CLAUDE.md                          ← This file
├── README.md                          ← Evaluator workflow documentation
├── test-technique-evaluateur.md       ← CONFIDENTIAL evaluator grading guide
├── test-scenarios.sh                  ← Non-regression test script (12 scenarios)
├── generate-zip-candidat.sh           ← Generates candidate zip (excludes evaluator files)
├── .github/workflows/
│   └── test-scenarios.yml             ← CI: build + non-regression tests (--skip-feature)
└── test-technique-ia/                 ← Main Java project
    ├── mvnw                           ← Maven Wrapper (Unix)
    ├── mvnw.cmd                       ← Maven Wrapper (Windows)
    ├── .mvn/wrapper/                  ← Maven Wrapper config
    ├── README.md                      ← Project launch instructions
    ├── SUJET.md                       ← Challenge instructions + functional rules
    ├── pom.xml                        ← Maven config (Spring Boot 3.2, Java 17)
    └── src/main/java/com/test/legacy/
        └── Application.java           ← Single file: Spring Boot entry + controller + entity + persistence + business logic
```

## Tech Stack

| Component        | Technology                     |
|------------------|--------------------------------|
| Language         | Java 17                        |
| Framework        | Spring Boot 3.2.0              |
| Build tool       | Maven 3 (wrapper included)     |
| Database         | H2 in-memory (`jdbc:h2:mem:testdb`) |
| ORM              | JPA / Hibernate (create-drop)  |
| Test framework   | Spring Boot Test (JUnit 5, Mockito) |
| Packaging        | JAR                            |

## Quick Commands

```bash
# Run the application (from test-technique-ia/)
cd test-technique-ia && ./mvnw spring-boot:run

# Run non-regression tests (app must be running on localhost:8080)
./test-scenarios.sh

# Run tests against custom URL
./test-scenarios.sh http://localhost:8080

# Generate candidate zip
./generate-zip-candidat.sh

# Access H2 console (when app is running)
# http://localhost:8080/h2-console  (user: sa, no password)
```

## API Endpoints

| Method   | Path              | Description                          |
|----------|-------------------|--------------------------------------|
| `POST`   | `/api/ord`        | Create an order (std, prm, exp)      |
| `GET`    | `/api/ord/{id}`   | Get order by ID (404 if deleted)     |
| `DELETE` | `/api/ord/{id}`   | Soft-delete an order (sets status="del") |
| `GET`    | `/api/ord/stats`  | **New feature** candidates must implement |

### Request/Response Format

Orders use `Map<String, Object>` with these fields:

| Field       | Description                       | Values                    |
|-------------|-----------------------------------|---------------------------|
| `type`      | Order type                        | `"std"`, `"prm"`, `"exp"` |
| `email`     | Customer email                    | String                    |
| `amount`    | Amount (integer)                  | Integer                   |
| `id`        | Order ID (UUID, auto-generated)   | String                    |
| `status`    | Status                            | `null` or `"del"`         |
| `premium`   | Premium flag                      | `true` / `null`           |

## Critical Business Logic

These behaviors are embedded in the legacy code and **must be preserved** during refactoring. All functional rules are documented in `SUJET.md` and given to the candidate (there are no hidden behaviors):

1. **Standard orders > 1000**: Saved twice (second save after discount). Discount of 10% applied only when amount > 1000.
2. **Premium orders**: Flag `premium=true` is set. Saved twice (before and after discount). Discount applied **twice** (10% + 10% = 19% total, i.e., `amount * 0.9 * 0.9`). Example: 1000 becomes 810.
3. **Notification failures are silently caught**: Empty/null email throws `RuntimeException`, but the `catch` block swallows it. Orders must succeed regardless of email validity.
4. **Soft delete only**: `DELETE` sets `status="del"` on the order instead of removing it. `GET` returns 404 for soft-deleted orders.
5. **Express orders**: Saved and notified like standard orders.

## Architecture Notes

- **God-class design**: Everything lives in a single file `Application.java` — Spring Boot main, REST endpoints, JPA entity (static inner class `E`), persistence via `EntityManager`, business rules, notifications, and discount logic. This is intentional to maximize the refactoring challenge.
- **Intentional code smells** (this is the point of the exercise):
  - Single-letter variable/class names (`d`, `o`, `E`, `s`, `g`, `n`)
  - Abbreviated method names (`prcOrd`, `gtOrd`, `dlOrd`, `aDsc`, `toE`, `toM`)
  - JPA entity as a static inner class with package-private fields (no getters/setters)
  - All business logic, persistence, and HTTP handling in one class
  - `Map<String, Object>` used everywhere instead of typed DTOs
  - No unit tests
  - No linter or formatter configured
- **CI/CD**: GitHub Actions workflow (`.github/workflows/test-scenarios.yml`) runs the build and non-regression tests on push/PR. Uses `--skip-feature` flag to skip the stats endpoint scenario (not yet implemented in the base code). No Docker.

## Non-Regression Tests (test-scenarios.sh)

The test script runs 12 scenarios via `curl` against a running instance:

| # | Scenario                                | Assertion                     |
|---|-----------------------------------------|-------------------------------|
| 1 | Standard order (amount <= 1000)         | HTTP 200 + `"amount":500` unchanged |
| 2 | Premium order (amount=800)              | `"premium":true` + `"amount":648` (double discount) |
| 3 | Premium double discount (1000 -> 810)   | `"amount":810`   |
| 4 | Express order creation                  | HTTP 200                      |
| 5 | Empty email does not block order        | HTTP 200                      |
| 6 | Absent email does not block order       | HTTP 200                      |
| 7 | GET existing order — content verified   | HTTP 200 + body contains type, amount, email |
| 8 | GET non-existent order                  | HTTP 404                      |
| 9 | Soft delete then GET returns 404        | DELETE returns HTTP 200 + GET returns HTTP 404 |
| 10 | DELETE non-existent order              | HTTP 200                      |
| 11 | Stats endpoint (`/api/ord/stats`)      | Contains all 4 fields, `totalOrders=7`, `ordersByType` values + type mapping |
| 12 | Standard order (amount > 1000)         | `"amount":1800` (10% discount applied) |

## Stats Endpoint Specification (New Feature)

Candidates must implement `GET /api/ord/stats` returning:

```json
{
  "totalOrders": 6,
  "ordersByType": {
    "standard": 3,
    "premium": 2,
    "express": 1
  },
  "totalRevenue": 12500,
  "averageOrderAmount": 833.33
}
```

Constraints:
- Exclude soft-deleted orders (`status="del"`)
- Map type codes: `"std"` -> `"standard"`, `"prm"` -> `"premium"`, `"exp"` -> `"express"`

## Evaluation Rubric (100 points)

| Category       | Points | Key Criteria                                                |
|----------------|--------|-------------------------------------------------------------|
| Methodology    | 40     | Test-first approach, right test type (integration HTTP), edge cases |
| AI Usage       | 25     | Prompt clarity, iteration, challenging AI output            |
| Code Quality   | 20     | Naming, SOLID principles, error handling, DTO usage         |
| Feature        | 15     | Stats endpoint functionality, testing, code consistency     |

## Guidelines for AI Assistants Working on This Codebase

1. **Preserve all business logic** when refactoring. Run `test-scenarios.sh` to verify zero regressions.
2. **Do not simplify the double discount** for premium orders - `aDsc()` being called twice (yielding 19% not 20%) is intentional.
3. **Do not add email validation** that would block order creation - silent catch of notification failures is by design.
4. **Soft delete must remain** - never physically delete records from the database.
5. **The 1000 threshold** for standard orders must be preserved (discount only applied when amount > 1000).
6. **Keep the double save** for standard (>1000) and premium orders - this is an intentional audit behavior.
7. When refactoring, focus on: renaming, extracting DTOs, separating into proper layers (controller/service/repository), adding tests.
8. The Maven project root is `test-technique-ia/` - all Maven commands should be run from there using `./mvnw` (Maven Wrapper).
