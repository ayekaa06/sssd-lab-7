# ── Stage 1: Build ──────────────────────────────────────────────────────────
FROM golang:1.27.3-alpine AS builder

WORKDIR /app

# Зависимости кешируем отдельным слоем
COPY go.mod go.sum ./
RUN go mod download

# Исходники
COPY . .

# Статичная сборка — не нужна libc в alpine
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -a -installsuffix cgo \
    -ldflags="-w -s" \
    -o server ./cmd/server

# ── Stage 2: Final ───────────────────────────────────────────────────────────
FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /app
RUN adduser -D -u 10001 appuser

COPY --from=builder /app/server .

# .env опциональный — можно не включать в image (использовать env vars)

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:8080/health || exit 1

USER appuser
CMD ["./server"]
