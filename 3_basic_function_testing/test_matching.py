# test_matching.py

# this script tests the /match/{request_id} endpoint by sending sample requests
import requests

def test_matching(request_id):
    # makes a get request to the backend using the provided request id
    url = f"http://localhost:8000/match/{request_id}"
    response = requests.get(url)
    
    if response.status_code == 200:
        # prints success message and json data if status is 200
        print(f"✅ Request ID {request_id} - Success:")
        print(response.json())
    else:
        # prints error message if request fails
        print(f"❌ Request ID {request_id} - Failed:")
        print(f"Status: {response.status_code}, Error: {response.json()}")

if __name__ == "__main__":
    # iterates over predefined request ids and calls test_matching
    # predefined IDs matching your test data
    test_request_ids = [101, 102, 103, 104, 999]  # 999 intentionally tests error handling

    for request_id in test_request_ids:
        test_matching(request_id)
        print("-" * 60)
