# Coding Conventions

## Overview

This document defines the coding standards used throughout the project.

All source code must follow these conventions to ensure consistency, readability, and maintainability.

---

# General Principles

- Write clean and self-documenting code.
- Prefer readability over clever implementations.
- Keep code simple.
- Avoid unnecessary abstractions.
- Follow SOLID principles.
- Follow DRY (Don't Repeat Yourself).
- Follow KISS (Keep It Simple, Stupid).

---

# TypeScript

Enable strict mode.

Never use

- any
- unknown as a workaround
- @ts-ignore

Prefer

- interfaces
- enums
- readonly
- utility types

Always define explicit return types for public methods.

---

# Naming Convention

## Files

Use kebab-case.

Example

```
user.controller.ts

user.repository.ts

create-user.dto.ts
```

---

## Classes

Use PascalCase.

```
UserService

CreateLessonUseCase

CharacterRepository
```

---

## Interfaces

Prefix with I only when representing external contracts.

```
IStorageProvider
```

Repository interfaces should be descriptive.

```
UserRepository

CharacterRepository
```

---

## Variables

Use camelCase.

```
userId

nextReviewDate
```

Avoid abbreviations.

Bad

```
usr

tmp

obj
```

Good

```
user

reviewHistory

learningProgress
```

---

## Constants

Use UPPER_SNAKE_CASE.

```
MAX_RETRY

JWT_EXPIRES_IN
```

---

# DTO

Every request body must use DTO.

Never accept raw objects.

Use

- class-validator
- class-transformer

Presentation DTOs handle HTTP mapping and validation (`class-validator`, `@ApiProperty`).
Application DTOs represent internal application commands/queries.
Keep them separate to avoid coupling the Application layer to HTTP frameworks.

---

# Validation

Validate all external input.

Prefer declarative validation.

Example

- IsEmail
- IsUUID
- IsString
- IsEnum
- IsOptional

Business validation belongs in the Domain.

---

# Controllers

Controllers should only

- Receive requests
- Validate input
- Call application services
- Return responses

Controllers must never

- Access Prisma
- Contain business logic
- Perform calculations

---

# Services

Services should contain one business responsibility.

Avoid services with hundreds of lines.

Extract reusable business logic into Domain Services.

---

# Repository

Repositories only perform persistence.

Repositories must not

- Validate business rules
- Calculate values
- Call external APIs

Repository methods should express intent.

Good

```
findByEmail()

findDueReviews()

save()
```

Bad

```
executeQuery()

handleData()
```

---

# Prisma

Use Prisma Client for all database operations.

Never write raw SQL unless absolutely necessary.

Use Prisma transactions for multi-step persistence.

Never expose Prisma models directly to Controllers.

---

# Error Handling

Throw meaningful exceptions.

Do not swallow exceptions.

Use custom exceptions for business errors.

Return consistent error responses.

---

# Logging

Use NestJS Logger.

Never use

```
console.log()
```

Never log

- passwords
- tokens
- secrets
- personal information

---

# Async Code

Prefer async/await.

Avoid nested Promise chains.

Handle all asynchronous errors.

---

# Functions

Keep functions focused.

Recommended

20–40 lines.

Avoid deeply nested conditions.

Prefer early returns.

---

# Dependency Injection

Always use constructor injection.

Never instantiate services manually.

Bad

```
new UserRepository()
```

Good

NestJS Dependency Injection.

---

# Comments

Write code that explains itself.

Only add comments when explaining

- business rules
- non-obvious decisions
- algorithm complexity

Do not comment obvious code.

---

# Imports

Order imports

1. Node modules
2. Third-party packages
3. Internal modules
4. Relative imports

Avoid unused imports.

---

# Testing

Business logic requires Unit Tests.
- Place unit tests adjacent to the source file (e.g., `user.service.spec.ts`).

Persistence requires Integration Tests.

Public APIs require End-to-End Tests.
- Place E2E tests in the global `test/e2e/` directory.

Use descriptive test names (e.g., Given/When/Then structure).

---

# API Documentation

Every public endpoint must include

- ApiTags
- ApiOperation
- ApiResponse
- ApiBearerAuth (when required)

Swagger documentation must always be updated.

---

# Performance

Select only required fields.

Avoid N+1 queries.

Use pagination.

Cache immutable content.

Do not prematurely optimize.

---

# Security

Hash passwords using Argon2.

Never store plaintext passwords.

Validate every request.

Use parameterized queries through Prisma.

Never trust client input.

---

# REST API Conventions

Use plural nouns for resource URIs (e.g., `/users`, `/users/:id/lessons`).

Use standard HTTP methods (GET, POST, PUT, PATCH, DELETE) to represent actions.

# API Responses

Return a consistent envelope for responses.

Success Envelope:

```json
{
  "data": { ... }
}
```

Pagination Envelope:

```json
{
  "data": [ ... ],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 10
  }
}
```

# Data Formats

**Dates and Times:**
Always store and transfer dates in UTC format using ISO-8601 strings (e.g., `2024-01-01T12:00:00Z`).
Use native `Date` or a standard library like `date-fns` for manipulation.

---

# Git

Commit messages follow Conventional Commits.

Examples

```
feat(auth): add refresh token

fix(progress): correct SRS calculation

refactor(character): simplify repository

test(user): add login tests
```

---

# AI Guidelines

When generating code

- Follow the existing project structure.
- Reuse existing components before creating new ones.
- Avoid duplicated code.
- Keep modules independent.
- Preserve architecture boundaries.
- Generate tests whenever business logic changes.
- Prefer consistency over personal preference.

---