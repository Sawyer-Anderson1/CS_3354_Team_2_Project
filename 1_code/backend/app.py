# attempt at backend integration for donations screen
# not done and implemented yet 
# can be deleted, just a raw, small sample example 

from flask import Flask, request, jsonify
import json

app = Flask(__name__)

# In-memory storage for donations
donations = []

# Route to get donations
@app.route('/donations', methods=['GET'])
def get_donations():
    return jsonify(donations)

# Route to post a new donation
@app.route('/donations', methods=['POST'])
def create_donation():
    new_donation = request.get_json()
    donations.append(new_donation)
    return jsonify(new_donation), 201

if __name__ == '__main__':
    app.run(debug=True)
