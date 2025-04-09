Casey Nguyen - Resource Inventory (Flutter Web)

This feature shows a real-time list of resources available during disasters.

HOW TO RUN (for Web):
-----------------------

1. Make sure Flutter is installed and enabled for web:
   flutter channel stable
   flutter upgrade
   flutter config --enable-web

2. Install dependencies:
   flutter pub get

3. Place the resources.json file in the assets folder.

4. Run on Chrome:
   flutter run -d chrome

DATA EXAMPLE (in `resources.json`):
-----------------------------------
[
  {
    "name": "Blankets",
    "quantity": 50,
    "location": "Plano, TX"
  },
  {
    "name": "Water Bottles",
    "quantity": 200,
    "location": "Dallas, TX"
  }
]

DEPENDENCIES:
-------------
- flutter
- flutter_localizations
- http

NOTES:
------
- App displays real-time resource data from local JSON file.
- Runs entirely in Chrome (no Android/iOS needed).

