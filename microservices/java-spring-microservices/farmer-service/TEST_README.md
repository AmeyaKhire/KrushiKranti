# Farmer Service Tests

This directory contains comprehensive tests for the Farmer Service, including unit tests, integration tests, and repository tests.

## Test Structure

```
src/test/java/com/krushikranti/farmer/
├── controller/
│   ├── FarmerControllerIntegrationTest.java    # Integration tests for farmer endpoints
│   └── PincodeImportControllerTest.java         # Unit tests for pincode import endpoints
├── exception/
│   └── GlobalExceptionHandlerTest.java          # Tests for exception handling
├── repository/
│   ├── FarmerRepositoryTest.java                # Repository tests for Farmer entity
│   └── PincodeMasterRepositoryTest.java         # Repository tests for PincodeMaster entity
└── service/
    ├── AuthServiceClientTest.java               # Unit tests for gRPC client
    ├── FarmerProfileServiceTest.java            # Unit tests for profile service
    └── PincodeServiceTest.java                  # Unit tests for pincode lookup service
```

## Test Types

### Unit Tests
- **Service Tests**: Test business logic with mocked dependencies
- **Controller Tests**: Test controller endpoints with mocked services
- **Exception Handler Tests**: Test global exception handling

### Integration Tests
- **Repository Tests**: Test database operations with H2 in-memory database
- **Controller Integration Tests**: Test full request/response flow with mocked external services

## Running Tests

### Run All Tests
```bash
mvn test -pl :farmer-service
```

### Run Specific Test Class
```bash
mvn test -pl :farmer-service -Dtest=FarmerProfileServiceTest
```

### Run Tests with Coverage
```bash
mvn test -pl :farmer-service jacoco:report
```

### Run Only Unit Tests
```bash
mvn test -pl :farmer-service -Dtest="*Test"
```

### Run Only Integration Tests
```bash
mvn test -pl :farmer-service -Dtest="*IntegrationTest"
```

## Test Configuration

Tests use the `test` profile with the following configuration:
- **Database**: H2 in-memory database (for fast execution)
- **Mocked Services**: Auth Service Client, Pincode Service (in integration tests)
- **Flyway**: Disabled (Hibernate DDL auto-create used instead)

Configuration file: `src/test/resources/application-test.yml`

## Test Coverage

### Services Covered
- ✅ `FarmerProfileService` - Complete coverage
- ✅ `PincodeService` - Complete coverage
- ✅ `AuthServiceClient` - Complete coverage

### Controllers Covered
- ✅ `FarmerController` - All endpoints tested
- ✅ `PincodeImportController` - All endpoints tested

### Repositories Covered
- ✅ `FarmerRepository` - All methods tested
- ✅ `PincodeMasterRepository` - All query methods tested

### Exception Handling
- ✅ `GlobalExceptionHandler` - All exception types tested

## Test Scenarios

### Farmer Profile Service
- Get profile when exists
- Get profile when not exists (returns auth data only)
- Create new profile
- Update existing profile
- Invalid village validation

### Pincode Service
- Lookup address by pincode (success)
- Lookup address by pincode (not found)
- Empty pincode validation
- Pincode exists check

### Auth Service Client
- Successful user retrieval
- User not found
- gRPC errors

### Controllers
- All CRUD operations
- Request validation
- Error handling
- Response formatting

## Dependencies

### Test Dependencies
- **JUnit 5** - Test framework
- **Mockito** - Mocking framework
- **AssertJ** - Assertions
- **Spring Boot Test** - Spring testing support
- **H2 Database** - In-memory database for tests
- **Testcontainers** (optional) - For PostgreSQL integration tests

## Notes

- Tests use H2 in-memory database by default for fast execution
- External services (Auth Service) are mocked in unit and integration tests
- Integration tests use `@DataJpaTest` for repository layer testing
- Controller tests use `@WebMvcTest` for web layer testing
- Integration tests use `@SpringBootTest` for full context testing

## Future Improvements

- [ ] Add end-to-end tests with Testcontainers and PostgreSQL
- [ ] Add performance tests
- [ ] Add contract tests for gRPC communication
- [ ] Add load tests for high-volume scenarios

