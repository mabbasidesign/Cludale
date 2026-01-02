# Cludale Tickets

<img width="1536" height="1024" alt="week-2" src="https://github.com/user-attachments/assets/a4d7bd8b-5582-41f1-bcab-ca2ee6e5a4e8" />


Cludale Tickets is a cloud-native, event-driven concert ticketing platform built on Azure Container Apps, Dapr, and Cosmos DB.

The project demonstrates modern Azure DevOps practices including CI/CD with Azure DevOps, blue-green deployments, event-driven messaging with Azure Service Bus, and distributed tracing with Application Insights.

Designed to showcase scalable microservices, resilient communication, and production-ready cloud architecture.

# Cludale Tickets – Core Services

## Platform Overview

---

## Services

### 1️⃣ Concert Service
- **Purpose**: Source of truth for concerts & seat availability
- **Responsibilities**:
  - Create/manage concerts
  - Track seat inventory
  - Prevent overselling
- **APIs**:
  - `GET /concerts`
  - `GET /concerts/{id}`
  - `POST /concerts`
  - `POST /concerts/{id}/reserve`
- **Data Example**:
```json
{
  "id": "concert-123",
  "artist": "Coldplay",
  "date": "2026-05-20",
  "totalSeats": 1000,
  "availableSeats": 245
}
```
- **Events Published**: SeatsReserved, SeatsReleased
- **Dapr Usage**: Pub/Sub, optional state store

---

### 2️⃣ Order Service
- **Purpose**: Orchestrates ticket reservations & purchases
- **Responsibilities**:
  - Create orders
  - Manage order state
  - Coordinate payment
- **APIs**:
  - `POST /orders`
  - `GET /orders/{id}`
- **Order States**: Pending → Reserved → Paid → Cancelled
- **Data Example**:
```json
{
  "id": "order-789",
  "concertId": "concert-123",
  "userId": "user-1",
  "quantity": 2,
  "status": "Pending"
}
```
- **Events**: Publishes TicketReserved, OrderCancelled; Subscribes PaymentCompleted, PaymentFailed
- **Dapr Usage**: Service invocation, pub/sub

---

### 3️⃣ Payment Service
- **Purpose**: Payment processing (simulated)
- **Responsibilities**:
  - Process payments
  - Handle retries
  - Emit success/failure events
- **APIs**:
  - `POST /payments`
- **Events**: Subscribes TicketReserved; Publishes PaymentCompleted, PaymentFailed
- **Dapr Usage**: Pub/Sub, resilience policies

---

### 4️⃣ Notification Service
- **Purpose**: User communication (email/SMS simulation)
- **Responsibilities**:
  - Send confirmations
  - Send failure notifications
- **Events Subscribed**: PaymentCompleted, OrderCancelled
- **Output**: Logs (Week 2), Email/SMS integration (Week 4)
- **Dapr Usage**: Pub/Sub

---

### 5️⃣ Audit Service
- **Purpose**: Traceability & compliance
- **Responsibilities**:
  - Store all domain events
  - Enable replay/debugging
- **Events Subscribed**: All events (*)
- **Data Example**:
```json
{
  "eventType": "PaymentCompleted",
  "timestamp": "2026-01-10T12:10:00Z",
  "payload": { }
}
```
- **Dapr Usage**: Pub/Sub, state store

---

## Event Flow
1. Order Service requests seat reservation
2. Concert Service publishes SeatsReserved
3. Order Service publishes TicketReserved
4. Payment Service processes payment, publishes PaymentCompleted
5. Notification Service sends confirmation
6. Audit Service records all events

---

## Why This Architecture?
- Concurrency awareness & inventory control
- Distributed workflow & event-driven design
- Async processing & eventual consistency
- Separation of concerns
- Production-grade traceability

---

## Getting Started
1. Build the solution: `dotnet build Cludale.sln`
2. Run services locally: `dotnet run --project src/ConcertService/ConcertService.csproj` (repeat for other services)
3. Deploy to Azure Container Apps (see infra/)
4. Configure Dapr & Service Bus (see docker/ and infra/)

---

## Contact
For questions or contributions, open an issue or pull request.
