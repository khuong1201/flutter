# Architecture

## Overview

This project follows **Domain-Driven Design (DDD)** with **Clean Architecture**.

The primary goals are:

- Clear separation of concerns
- Maintainable codebase
- Scalable module design
- High testability
- Consistent AI-generated code

---

# Architecture Layers

Every module follows the same architecture.

```
Presentation
        │
        ▼
Application
        │
        ▼
Domain
        ▲
        │
Infrastructure
```

Dependencies always point toward the Domain.

---

# Project Structure

```
test/
├── e2e/
│
src/
├── main.ts
├── app.module.ts
│
├── config/
│   ├── app.config.ts
│   ├── database.config.ts
│   ├── jwt.config.ts
│   ├── redis.config.ts
│   └── swagger.config.ts
│
├── common/
│   ├── constants/
│   ├── decorators/
│   ├── enums/
│   ├── exceptions/
│   ├── filters/
│   ├── guards/
│   ├── interceptors/
│   ├── middlewares/
│   ├── pipes/
│   ├── types/
│   └── utils/
│
├── database/
│   ├── prisma.module.ts
│   └── prisma.service.ts
│
├── providers/
│   ├── cache/
│   ├── storage/
│   ├── mail/
│   └── queue/
│
└── modules/
    ├── auth/
    ├── users/
    ├── characters/
    ├── lessons/
    ├── practice/
    └── progress/
```

---

# Module Structure

Every business module must follow this structure.

```
module/

application/
├── dto/
├── mappers/
├── services/
└── use-cases/

domain/
├── entities/
├── repositories/
├── services/
├── value-objects/
└── exceptions/

infrastructure/
├── persistence/
│   ├── prisma/
│   └── repositories/
├── mappers/
├── cache/
└── storage/

presentation/
├── controllers/
├── dto/
└── presenters/

module.module.ts
```

All modules must follow the same structure.

Do not create custom folder layouts.

---

# Layer Responsibilities

## Presentation

Responsibilities

- Receive HTTP requests
- Validate request data
- Authenticate requests
- Authorize requests
- Call Application layer
- Return HTTP responses
- Swagger documentation

Presentation must not contain business logic.

---

## Application

Responsibilities

- Execute use cases
- Coordinate business workflows
- Manage transactions
- Call repository interfaces
- Call external providers when necessary

Application must not access Prisma directly.

Application must not contain persistence logic.

---

## Domain

Responsibilities

- Business rules
- Entities
- Value Objects
- Domain Services
- Repository Interfaces
- Domain Exceptions

Domain must remain framework independent.

Domain must never import:

- NestJS
- Prisma
- PostgreSQL
- Redis
- AWS SDK

---

## Infrastructure

Responsibilities

- Prisma
- PostgreSQL
- Redis
- Storage
- Email
- Queue
- External APIs
- Database Mappers (mapping Prisma models to Domain Entities)

Infrastructure implements interfaces defined in the Domain.

Infrastructure must not contain business rules.
Prisma models are not Domain Entities. They must be mapped to Domain Entities before returning to the Application layer.

---

# Dependency Rules

Allowed

Presentation
→ Application

Application
→ Domain

Infrastructure
→ Domain

Forbidden

Presentation
→ Infrastructure

Presentation
→ Prisma

Application
→ Prisma

Application
→ PostgreSQL

Domain
→ Infrastructure

Domain
→ NestJS

Domain
→ Prisma

Domain
→ Redis

---

# Repository Rules

Repository interfaces belong to the Domain layer.

Repository implementations belong to the Infrastructure layer.

Repositories are responsible only for persistence.

Repositories must never contain business logic.

---

# Business Rules

Business rules belong only to:

- Domain
- Application

Never place business rules inside:

- Controllers
- Repositories
- Prisma services
- Providers

---

# Transactions

Transactions are managed by the Application layer via a Unit of Work (UoW) pattern.

The Domain layer defines the Unit of Work interface.
The Infrastructure layer implements the Unit of Work, wrapping Prisma's transaction client.

Repositories must not start or commit transactions directly.
The Application layer must not access Prisma's transaction objects.

---

# Validation

Presentation Layer

- DTO validation
- Request validation

Domain Layer

- Business validation

Infrastructure Layer

- Database constraints

---

# Module Communication

Modules should remain independent to prevent circular dependencies.

Modules communicate through:

- Module Facades (explicit public services)
- Public interfaces
- Domain events (e.g., using NestJS EventEmitter2)

Direct repository access between modules is forbidden.
Direct injection of one module's internal Application Service into another is discouraged; use a dedicated Facade instead.

---

# Storage

Structured data

- PostgreSQL

Cache

- Redis

Media

- AWS S3

The database stores only media URLs.

---

# Error Handling

Global Exception Filter handles all HTTP responses.

Business exceptions belong to the Domain.

Application exceptions belong to the Application layer.

Infrastructure exceptions must not leak implementation details.

---

# Logging

Use NestJS Logger.

Do not use console.log.

Never log:

- Passwords
- Access Tokens
- Refresh Tokens
- Sensitive user data

---

# Testing

Every feature should include:

- Unit Tests for business logic
- Integration Tests for persistence
- End-to-End Tests for public APIs

---

# Creating a New Module

Every new module must follow the standard module structure.

Example

```
flashcards/

application/
domain/
infrastructure/
presentation/

flashcards.module.ts
```

Do not create alternative structures.

---

# Development Workflow

When implementing a feature:

1. Update Domain
2. Implement Application
3. Implement Infrastructure
4. Implement Presentation
5. Add Tests
6. Verify Build
7. Update Swagger

Always preserve architecture consistency.

Never bypass the defined layers.