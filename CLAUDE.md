# CLAUDE.md — AI Assistant Guide

## Project Overview

This repository is a **developer assessment framework** for evaluating candidates on legacy Java code refactoring with AI assistance. It contains an intentionally poorly-written order management system that candidates must refactor within 20 minutes while preserving all existing behavior.

**Domain**: Order management system (create, retrieve, soft-delete orders with discount logic).

## Repository Structure

```
eval-candidat/
├── CLAUDE.md                          ← This file
├── README.md                          ← Evaluator workflow documentation
├── test-technique-evaluateur.md       ← CONFIDENTIAL evaluator grading guide
├── test-scenarios.sh                  ← Non-regression test script (9 scenarios)
├── generate-zip-candidat.sh           ← Generates candidate zip (excludes evaluator files)
└── test-technique-ia/                 ← Main Java project
    ├── README.md                      ← Project launch instructions
    ├── SUJET.md                       ← Challenge instructions for candidates
    ├── pom.xml                        ← Maven config (Spring Boot 3.2, Java 17)
    └── src/main/java/com/test/legacy/
        ├── Application.java           ← Spring Boot entry point
        ├── controller/
        │   └── OrdCtrl.java           ← REST controller (legacy, needs refactoring)
        ├── repository/
        │   ├── OrdDao.java            ← Data access (JPA + EntityManager)
        │   └── OrderEntity.java       ← JPA entity (orders table)
        └── service/
            └── DscSvc.java            ← Discount service (10% discount)
```

## Tech Stack

| Component        | Technology                     |
|------------------|--------------------------------|
| Language         | Java 17                        |
| Framework        | Spring Boot 3.2.0              |
| Build tool       | Maven 3                        |
| Database         | H2 in-memory (`jdbc:h2:mem:testdb`) |
| ORM              | JPA / Hibernate (create-drop)  |
| Test framework   | Spring Boot Test (JUnit 5, Mockito) |
| Packaging        | JAR                            |

## Quick Commands

```bash
# Run the application (from test-technique-ia/)
cd test-technique-ia && mvn spring-boot:run

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
| `DELETE` | `/api/ord/{id}`   | Soft-delete an order (sets st="del") |
| `GET`    | `/api/ord/stats`  | **New feature** candidates must implement |

### Request/Response Format

Orders use `Map<String, Object>` with these fields:

| Field | Description                       | Values                    |
|-------|-----------------------------------|---------------------------|
| `t`   | Order type                        | `"std"`, `"prm"`, `"exp"` |
| `m`   | Customer email                    | String                    |
| `a`   | Amount (integer, cents or units)  | Integer                   |
| `id`  | Order ID (UUID, auto-generated)   | String                    |
| `st`  | Status                            | `null` or `"del"`         |
| `pr`  | Premium flag                      | `true` / `null`           |

## Critical Business Logic (Hidden Behaviors)

These behaviors are intentionally embedded in the legacy code and **must be preserved** during refactoring:

1. **Standard orders > 1000**: Saved twice (second save after discount). Discount of 10% applied only when amount > 1000.
2. **Premium orders**: Flag `pr=true` is set. Saved twice (before and after discount). Discount applied **twice** (10% + 10% = 19% total, i.e., `amount * 0.9 * 0.9`). Example: 1000 becomes 810.
3. **Notification failures are silently caught**: Empty/null email throws `RuntimeException` from `OrdDao.n()`, but the `catch` block swallows it. Orders must succeed regardless of email validity.
4. **Soft delete only**: `DELETE` sets `st="del"` on the order instead of removing it. `GET` returns 404 for soft-deleted orders.
5. **Express orders**: Use `sExp()` and `nExp()` methods (currently identical to standard save/notify).

## Architecture Notes

- **Layered architecture**: Controller -> Service -> Repository
- **Intentional code smells** (this is the point of the exercise):
  - Single-letter variable names (`d`, `o`, `m`, `t`, `a`, `st`, `pr`)
  - Abbreviated class/method names (`OrdCtrl`, `OrdDao`, `DscSvc`, `prcOrd`, `gtOrd`, `aDsc`)
  - Business logic in the controller instead of services
  - `Map<String, Object>` used everywhere instead of typed DTOs
  - No unit tests
  - No linter or formatter configured
- **No Docker, no CI/CD**: This is a local evaluation tool

## Non-Regression Tests (test-scenarios.sh)

The test script runs 9 scenarios via `curl` against a running instance:

| # | Scenario                                | Assertion                     |
|---|-----------------------------------------|-------------------------------|
| 1 | Standard order creation                 | HTTP 200                      |
| 2 | Premium order with `pr:true` flag       | Response contains `"pr":true` |
| 3 | Premium double discount (1000 -> 810)   | Response contains `"a":810`   |
| 4 | Express order creation                  | HTTP 200                      |
| 5 | Empty email does not block order        | HTTP 200                      |
| 6 | GET existing order                      | HTTP 200                      |
| 7 | GET non-existent order                  | HTTP 404                      |
| 8 | Soft delete then GET returns 404        | HTTP 404                      |
| 9 | Stats endpoint (`/api/ord/stats`)       | Contains `totalOrders`, `ordersByType`, excludes deleted orders |

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
- Use existing `OrdDao.getAll()` method
- Exclude soft-deleted orders (`st="del"`)
- Map type codes: `"std"` -> `"standard"`, `"prm"` -> `"premium"`, `"exp"` -> `"express"`

## Evaluation Rubric (100 points)

| Category       | Points | Key Criteria                                                |
|----------------|--------|-------------------------------------------------------------|
| Methodology    | 40     | Test-first approach, edge cases, hidden logic discovery     |
| AI Usage       | 25     | Prompt clarity, iteration, challenging AI output            |
| Code Quality   | 20     | Naming, SOLID principles, error handling, DTO usage         |
| Feature        | 15     | Stats endpoint functionality, testing, code consistency     |

## Guidelines for AI Assistants Working on This Codebase

1. **Preserve all hidden business logic** when refactoring. Run `test-scenarios.sh` to verify zero regressions.
2. **Do not simplify the double discount** for premium orders - `aDsc()` being called twice (yielding 19% not 20%) is intentional.
3. **Do not add email validation** that would block order creation - silent catch of notification failures is by design.
4. **Soft delete must remain** - never physically delete records from the database.
5. **The 1000 threshold** for standard orders must be preserved (discount only applied when amount > 1000).
6. **Keep the double save** for standard (>1000) and premium orders - this is an intentional audit behavior.
7. When refactoring, focus on: renaming, extracting DTOs, moving business logic to services, adding tests.
8. The Maven project root is `test-technique-ia/` - all `mvn` commands should be run from there.
