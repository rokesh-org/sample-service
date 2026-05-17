# Docker Instructions — sample-service

## Overview

A Ruby on Rails "Hello World" web service exposing a `GET /hello` endpoint.

- **Language:** Ruby 3.2
- **Framework:** Rails 8.1.3
- **Server:** Puma
- **Port:** 3000

---

## Build

From the root of the extracted source directory:

```bash
docker build -t sample-service .
```

---

## Run

```bash
docker run -p 3000:3000 sample-service
```

The application will be available at:

- `http://localhost:3000/hello` — returns `Hello, World!`

---

## Environment Variables

No environment variables are required for this application.

---

## Secret Handling

For production deployments, manage any secrets using:

- **ECS:** [AWS Secrets Manager integration with ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/secrets-envvar-secrets-manager.html)
- **EKS:** [AWS Secrets Manager or KMS encryption with EKS](https://docs.aws.amazon.com/eks/latest/userguide/security-k8s.html)

---

## Health Check

| Path     | Method | Expected Status |
|----------|--------|-----------------|
| `/hello` | GET    | 200             |

---

## Notes

- The container runs as a non-root user (`appuser`) for security.
- Rails runs in `development` mode by default. Set `RAILS_ENV=production` for production deployments and ensure `SECRET_KEY_BASE` is set.
- SQLite is used as the default database (in-memory/file-based). For production, configure an external database via `DATABASE_URL`.
