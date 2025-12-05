# Farmer Service

Farmer Profile and Management Service for Krushi Kranti platform.

## Overview

The Farmer Service manages farmer profiles, starting with the "My Details" section which includes:
- Personal Information (First Name, Last Name, DOB, Gender)
- Contact Details (Phone, Email from Auth Service, Alternate Phone)
- Address Details (Pincode, Village, District, Taluka, State)

## Architecture

- **Database**: PostgreSQL (farmer_db)
- **Inter-Service Communication**: gRPC (calls Auth Service for user info)
- **API Gateway**: Routes `/farmer/**` requests to this service
- **Authentication**: JWT validation handled by API Gateway (X-User-Id header passed)

## Database Schema

### farmers table
- Stores farmer profile information
- Links to `auth.users` via `user_id`

### pincode_master table
- Stores pincode → address mapping (district, taluka, state, villages)
- Populated from Excel file import

## API Endpoints

### Profile Management

#### GET `/farmer/profile/my-details`
Get farmer's "My Details" profile.
- **Headers**: `X-User-Id` (from API Gateway)
- **Response**: `MyDetailsResponse` with all profile data including email/phone from Auth Service

#### PUT `/farmer/profile/my-details`
Create or update farmer's "My Details" profile.
- **Headers**: `X-User-Id` (from API Gateway)
- **Body**: `MyDetailsRequest`
- **Response**: `MyDetailsResponse`

### Address Lookup

#### GET `/farmer/profile/address/lookup?pincode={pincode}`
Lookup address details by pincode.
- **Query Params**: `pincode` (6 digits)
- **Response**: `AddressLookupResponse` with district, taluka, state, and list of villages

### Admin/Development

#### POST `/farmer/admin/pincode/import?filePath={path}`
Import pincode data from Excel file.
- **Query Params**: `filePath` (full path to Excel file)
- **Response**: Number of records imported

#### GET `/farmer/admin/pincode/count`
Get count of pincode records in database.

## Excel Import Format

The Excel file should have the following columns (in order):
1. Pincode (6 digits)
2. Village
3. Taluka
4. District
5. State

Example:
```
Pincode | Village      | Taluka    | District | State
411001  | Pune City    | Pune      | Pune     | Maharashtra
411002  | Shivajinagar| Pune      | Pune     | Maharashtra
```

## gRPC Integration

The service calls Auth Service via gRPC to fetch user information:
- **Method**: `GetUserById(userId)`
- **Returns**: email, phoneNumber, username, roles, active status

## Running the Service

### Local Development
```bash
mvn spring-boot:run -pl farmer-service
```

### Docker
```bash
docker-compose up farmer-service
```

## Configuration

### application.yml (localhost)
- Database: `localhost:5450/farmer_db`
- gRPC Auth Service: `localhost:9090`

### application-docker.yml (Docker)
- Database: `farmer-db:5432/farmer_db`
- gRPC Auth Service: `auth-service:9090`

## Dependencies

- Spring Boot 3.2.0
- PostgreSQL
- gRPC Client (for Auth Service)
- Apache POI (for Excel import)
- Flyway (for database migrations)
- MapStruct (for DTO mapping)
- Lombok

## Next Steps

Future enhancements:
- KYC section
- Farm details
- Crop management
- Bank details

