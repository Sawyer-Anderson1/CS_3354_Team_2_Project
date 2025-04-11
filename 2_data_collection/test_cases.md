# Test Cases – Real-Time Aid Request Posting

## Test Case 1 – Submit a valid medical aid request

**Preconditions**:

- Backend is running
- User has Flutter environment installed and can run the mobile app

**Steps**:

1. Launch the mobile app using `flutter run`
2. Select "Medical" from the aid type dropdown
3. Enter the description: “Need medical supplies for injured individuals”
4. Tap “Get My Location”
5. Tap “Submit Request”

**Expected Outcome**:

- A snackbar appears: "Request submitted successfully!"
- The request appears in the backend (Firebase/DB logs or GET /requests)

---

## Test Case 2 – Submit without location

**Steps**:

1. Select aid type and enter a valid description
2. Do **not** tap “Get My Location”
3. Tap “Submit Request”

**Expected Outcome**:

- A snackbar appears indicating an error (e.g., “Error: Location is null”)
- No request is sent to the backend

---

## Test Case 3 – Submit without a description

**Steps**:

1. Select "Shelter" as the aid type
2. Leave the description blank
3. Tap “Get My Location”
4. Tap “Submit Request”

**Expected Outcome**:

- Request is submitted successfully
- Backend receives the request with an empty `description` field

---

## Test Case 4 – Select different aid types

**Steps**:

1. Open the dropdown and switch between "Medical", "Food", and "Shelter"
2. Confirm each selection updates the internal aid type

**Expected Outcome**:

- The selected aid type is properly shown and stored in the final request payload

---

## Test Case 5 – Emergency Alert Banner Display

**Steps**:

1. Launch the app
2. Check for the static red alert banner at the top of the screen

**Expected Outcome**:

- Text contains emergency alert
