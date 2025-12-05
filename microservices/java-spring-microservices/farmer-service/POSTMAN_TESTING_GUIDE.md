# Farmer Service - Postman Testing Guide

This guide provides step-by-step instructions to test all Farmer Service endpoints using Postman.

## 📋 Prerequisites

Before testing, ensure the following services are running:

1. **Farmer Service** - Port `4000`
2. **Auth Service** - Port `4005` (REST) and `9090` (gRPC)
3. **API Gateway** - Port `4004` (optional, for protected endpoints)
4. **PostgreSQL Database** - Port `5450` (for farmer_db)
5. **Redis** - Port `6379` (for Auth Service OTP)

### Check Services Status

```bash
# Check if services are running
Get-NetTCPConnection -LocalPort 4000,4004,4005,9090 -ErrorAction SilentlyContinue | Select-Object LocalPort, State
```

---

## 🚀 Testing Setup

### Option 1: Testing via API Gateway (Recommended for Protected Endpoints)

**Base URL:** `http://localhost:4004`

### Option 2: Testing Directly on Farmer Service

**Base URL:** `http://localhost:4000`

> **Note:** Protected endpoints require `X-User-Id` header. For direct testing, you'll need to manually set this header.

---

## 📝 Step-by-Step Testing Guide

### **STEP 1: Health Check (No Authentication Required)**

Test if the Farmer Service is running.

#### Request

- **Method:** `GET`
- **URL (Direct):** `http://localhost:4000/farmer/health`
- **URL (Via Gateway):** `http://localhost:4004/farmer/health`
- **Headers:** None required

#### Expected Response

```
Status: 200 OK
Body: "Farmer Service is running"
```

---

### **STEP 2: Import Pincode Data (One-Time Setup)**

> **Important:** This must be done before testing address lookup endpoints.

#### Request

- **Method:** `POST`
- **URL:** `http://localhost:4000/farmer/admin/pincode/import`
- **Headers:** None required (or `Content-Type: application/x-www-form-urlencoded`)

#### Step-by-Step Instructions in Postman:

1. **Set Method:** Select `POST` from the method dropdown
2. **Enter URL:** `http://localhost:4000/farmer/admin/pincode/import`
3. **Go to Params Tab:**
   - Click on the **"Params"** tab (below the URL bar)
   - You'll see a table with columns: Key, Value, Description
   - In the **Key** column, enter: `filePath`
   - In the **Value** column, enter your file path:
     ```
     D:\Thynk Tech\Krushi_Kranti\Copy of List of Pin Codes of Maharashtra.xlsx
     ```
   - ✅ **Make sure the checkbox next to the key is CHECKED** (this enables the parameter)
   - Postman will automatically URL-encode spaces and special characters

4. **Alternative: Manual URL Encoding**
   If you want to type it directly in the URL bar, use URL-encoded format:
   ```
   http://localhost:4000/farmer/admin/pincode/import?filePath=D%3A%5CThynk%20Tech%5CKrushi_Kranti%5CCopy%20of%20List%20of%20Pin%20Codes%20of%20Maharashtra.xlsx
   ```
   
   **Encoding Rules:**
   - `\` (backslash) → `%5C`
   - Space → `%20` or `+`
   - `:` → `%3A`

5. **Send Request:** Click the **"Send"** button

#### Important Notes:

- ⚠️ **Do NOT put the file path directly in the URL bar without encoding** - this will cause a 400 error
- ✅ **Use the Params tab** - Postman will handle encoding automatically
- ✅ **Make sure the checkbox is checked** in the Params tab
- ✅ **Use forward slashes `/` instead of backslashes `\`** if you have issues:
  ```
  D:/Thynk Tech/Krushi_Kranti/Copy of List of Pin Codes of Maharashtra.xlsx
  ```

#### Example Request (Using Params Tab)

```
POST http://localhost:4000/farmer/admin/pincode/import

Params Tab:
Key: filePath
Value: D:\Thynk Tech\Krushi_Kranti\Copy of List of Pin Codes of Maharashtra.xlsx
✓ Checkbox: CHECKED
```

#### Expected Response

```json
{
    "message": "Pincode import completed successfully",
    "data": 1656
}
```

#### Troubleshooting 400 Bad Request Error:

If you're still getting a 400 error:

1. **Check the Params Tab:**
   - Make sure the checkbox next to `filePath` is **CHECKED** ✓
   - Verify the value doesn't have extra quotes or characters

2. **Try with Forward Slashes:**
   ```
   D:/Thynk Tech/Krushi_Kranti/Copy of List of Pin Codes of Maharashtra.xlsx
   ```

3. **Check File Path:**
   - Verify the file actually exists at that path
   - Copy the exact path from Windows Explorer (Shift + Right-click → Copy as path)

4. **Verify URL Encoding:**
   - Look at the URL bar in Postman - spaces should be shown as `%20`
   - If you see raw spaces, Postman isn't encoding properly

5. **Check Service Logs:**
   - Check Farmer Service logs for more detailed error messages


> **Note:** The `data` field contains the number of pincode records imported.

---

### **STEP 3: Get Pincode Count**

Check how many pincode records are in the database.

#### Request

- **Method:** `GET`
- **URL:** `http://localhost:4000/farmer/admin/pincode/count`
- **Headers:** None required

#### Expected Response

```json
{
    "message": "Pincode count retrieved",
    "data": 1656
}
```

---

### **STEP 4: Login to Get JWT Token (For Protected Endpoints)**

Before testing protected endpoints, you need to login via Auth Service to get a JWT token.

#### Request

- **Method:** `POST`
- **URL:** `http://localhost:4004/auth/login`
- **Headers:**
  ```
  Content-Type: application/json
  ```
- **Body (Email/Password):**
  ```json
  {
      "email": "farmer@example.com",
      "password": "your-password"
  }
  ```

- **Body (Phone/OTP):**
  ```json
  {
      "phoneNumber": "9876543210",
      "otp": "123456"
  }
  ```

#### Expected Response

```json
{
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "tokenType": "Bearer",
    "expiresIn": 86400,
    "user": {
        "id": 1,
        "username": "farmer1",
        "email": "farmer@example.com",
        "phoneNumber": "9876543210",
        "role": "FARMER",
        "isVerified": true
    }
}
```

> **Save the `accessToken` for subsequent requests!**

---

### **STEP 5: Address Lookup by Pincode**

Lookup address details (district, taluka, state, villages) for a given pincode.

#### Request

- **Method:** `GET`
- **URL:** `http://localhost:4004/farmer/profile/address/lookup`
- **Headers:**
  ```
  Authorization: Bearer {your-access-token}
  ```
- **Params (Query Parameters):**
  - `pincode`: 6-digit pincode
  - Example: `411001`

#### Example Request

```
GET http://localhost:4004/farmer/profile/address/lookup?pincode=411001
Headers:
  Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Expected Response

```json
{
    "message": "Address lookup successful",
    "data": {
        "pincode": "411001",
        "district": "Pune",
        "taluka": "Pune",
        "state": "Maharashtra",
        "villages": [
            "Village1",
            "Village2",
            "Village3"
        ]
    }
}
```

---

### **STEP 6: Get My Details (Farmer Profile)**

Get the current farmer's profile details.

#### Request

- **Method:** `GET`
- **URL:** `http://localhost:4004/farmer/profile/my-details`
- **Headers:**
  ```
  Authorization: Bearer {your-access-token}
  ```

> **Note:** The `X-User-Id` header is automatically added by API Gateway after JWT validation.

#### Expected Response (Profile Exists)

```json
{
    "message": "Farmer profile retrieved successfully",
    "data": {
        "id": 1,
        "userId": 1,
        "firstName": "John",
        "lastName": "Doe",
        "dateOfBirth": "1990-01-01",
        "gender": "MALE",
        "email": "farmer@example.com",
        "phoneNumber": "9876543210",
        "alternatePhone": "9876543211",
        "pincode": "411001",
        "village": "Village1",
        "district": "Pune",
        "taluka": "Pune",
        "state": "Maharashtra"
    }
}
```

#### Expected Response (Profile Not Created Yet)

```json
{
    "message": "Farmer profile retrieved successfully",
    "data": {
        "userId": 1,
        "email": "farmer@example.com",
        "phoneNumber": "9876543210"
    }
}
```

---

### **STEP 7: Create/Update My Details**

Create or update the farmer's profile details.

#### Request

- **Method:** `PUT`
- **URL:** `http://localhost:4004/farmer/profile/my-details`
- **Headers:**
  ```
  Content-Type: application/json
  Authorization: Bearer {your-access-token}
  ```
- **Body:**
  ```json
  {
      "firstName": "John",
      "lastName": "Doe",
      "dateOfBirth": "1990-01-01",
      "gender": "MALE",
      "alternatePhone": "9876543211",
      "pincode": "411001",
      "village": "Village1"
  }
  ```

#### Gender Values

- `MALE`
- `FEMALE`
- `OTHER`

#### Date Format

- Format: `YYYY-MM-DD`
- Example: `1990-01-01`

#### Example Request

```
PUT http://localhost:4004/farmer/profile/my-details
Headers:
  Content-Type: application/json
  Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...

Body:
{
    "firstName": "John",
    "lastName": "Doe",
    "dateOfBirth": "1990-01-01",
    "gender": "MALE",
    "alternatePhone": "9876543211",
    "pincode": "411001",
    "village": "Village1"
}
```

#### Expected Response

```json
{
    "message": "Farmer profile saved successfully",
    "data": {
        "id": 1,
        "userId": 1,
        "firstName": "John",
        "lastName": "Doe",
        "dateOfBirth": "1990-01-01",
        "gender": "MALE",
        "email": "farmer@example.com",
        "phoneNumber": "9876543210",
        "alternatePhone": "9876543211",
        "pincode": "411001",
        "village": "Village1",
        "district": "Pune",
        "taluka": "Pune",
        "state": "Maharashtra"
    }
}
```

---

## 🧪 Testing Directly on Farmer Service (Bypass API Gateway)

For testing admin endpoints or bypassing JWT validation, you can call the Farmer Service directly:

### Direct URL Format

```
http://localhost:4000/farmer/{endpoint}
```

### For Protected Endpoints (Direct Testing)

You need to manually add the `X-User-Id` header:

```
Headers:
  X-User-Id: 1
  Content-Type: application/json
```

---

## ✅ Validation Rules

### MyDetailsRequest Validation

| Field | Rules |
|-------|-------|
| `firstName` | Required, Not blank |
| `lastName` | Required, Not blank |
| `dateOfBirth` | Required, Must be in past (YYYY-MM-DD) |
| `gender` | Required, One of: MALE, FEMALE, OTHER |
| `alternatePhone` | Optional, Must be exactly 10 digits if provided |
| `pincode` | Required, Must be exactly 6 digits |
| `village` | Required, Must exist for the given pincode |

---

## 🔍 Error Scenarios to Test

### 1. Invalid Pincode

**Request:**
```
GET http://localhost:4004/farmer/profile/address/lookup?pincode=999999
```

**Expected Response:**
```json
{
    "message": "Pincode not found: 999999",
    "data": null
}
```

### 2. Invalid Village for Pincode

**Request:**
```
PUT http://localhost:4004/farmer/profile/my-details
Body:
{
    "firstName": "John",
    "lastName": "Doe",
    "dateOfBirth": "1990-01-01",
    "gender": "MALE",
    "pincode": "411001",
    "village": "InvalidVillage"
}
```

**Expected Response:**
```json
{
    "message": "Selected village does not exist for the given pincode",
    "data": null
}
```

### 3. Validation Errors

**Request:**
```
PUT http://localhost:4004/farmer/profile/my-details
Body:
{
    "firstName": "",
    "lastName": "Doe",
    "dateOfBirth": "1990-01-01",
    "gender": "MALE",
    "pincode": "123",
    "village": "Village1"
}
```

**Expected Response:**
```json
{
    "message": "Validation failed: firstName: First name is required, pincode: Pincode must be 6 digits",
    "data": null
}
```

### 4. Invalid Date of Birth (Future Date)

**Request:**
```
PUT http://localhost:4004/farmer/profile/my-details
Body:
{
    "firstName": "John",
    "lastName": "Doe",
    "dateOfBirth": "2025-12-31",
    "gender": "MALE",
    "pincode": "411001",
    "village": "Village1"
}
```

**Expected Response:**
```json
{
    "message": "Validation failed: dateOfBirth: Date of birth must be in the past",
    "data": null
}
```

### 5. Missing JWT Token

**Request:**
```
GET http://localhost:4004/farmer/profile/my-details
(No Authorization header)
```

**Expected Response:**
```
Status: 401 Unauthorized
```

---

## 📦 Postman Collection Setup

### Environment Variables

Create a Postman environment with these variables:

| Variable | Initial Value | Current Value |
|----------|---------------|---------------|
| `base_url_gateway` | `http://localhost:4004` | `http://localhost:4004` |
| `base_url_direct` | `http://localhost:4000` | `http://localhost:4000` |
| `auth_token` | (empty) | (will be set after login) |
| `user_id` | `1` | `1` |
| `excel_file_path` | `D:\Thynk Tech\Krushi_Kranti\Copy of List of Pin Codes of Maharashtra.xlsx` | (your path) |

### Collection Structure

```
Farmer Service Tests
├── 1. Health Check
│   └── GET /farmer/health
├── 2. Admin Endpoints
│   ├── POST /farmer/admin/pincode/import
│   └── GET /farmer/admin/pincode/count
├── 3. Authentication
│   └── POST /auth/login
├── 4. Address Lookup
│   └── GET /farmer/profile/address/lookup?pincode={pincode}
└── 5. Profile Management
    ├── GET /farmer/profile/my-details
    └── PUT /farmer/profile/my-details
```

---

## 🎯 Complete Testing Flow

### Recommended Test Order:

1. ✅ **Health Check** - Verify service is running
2. ✅ **Login** - Get JWT token and save it
3. ✅ **Import Pincode Data** - One-time setup (if not done)
4. ✅ **Check Pincode Count** - Verify import was successful
5. ✅ **Address Lookup** - Test with valid pincode
6. ✅ **Get My Details** - Should return empty profile initially
7. ✅ **Create Profile** - PUT with complete data
8. ✅ **Get My Details Again** - Verify profile was saved
9. ✅ **Update Profile** - Modify and save again
10. ✅ **Test Error Scenarios** - Invalid data, missing fields, etc.

---

## 💡 Tips

1. **Save JWT Token:** After login, save the token in Postman environment variables for reuse.
2. **Use Environment Variables:** Create Postman environments for different setups (local, docker, etc.)
3. **Test Error Cases:** Always test validation errors and edge cases.
4. **Check Logs:** Monitor Farmer Service logs for debugging.
5. **Database State:** Clear database if you want to test fresh profile creation.

---

## 📚 Additional Resources

- **Service Documentation:** See `README.md`
- **Test Documentation:** See `TEST_README.md`
- **API Gateway Routes:** `/farmer/**` routes to `http://localhost:4000`

---

## 🐛 Troubleshooting

### Issue: 401 Unauthorized

**Solution:** 
- Make sure you have a valid JWT token
- Token might be expired (default: 24 hours)
- Login again to get a new token

### Issue: Connection Refused

**Solution:**
- Verify Farmer Service is running on port 4000
- Check if API Gateway is running on port 4004 (if using gateway)

### Issue: Pincode Not Found

**Solution:**
- Make sure you've imported pincode data (Step 2)
- Verify the pincode exists in your Excel file
- Check pincode count endpoint to see if data was imported

### Issue: gRPC Connection Error

**Solution:**
- Verify Auth Service is running on port 9090 (gRPC)
- Check Auth Service logs for connection issues

---

**Happy Testing! 🚀**

