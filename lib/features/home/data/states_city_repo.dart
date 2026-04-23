class StateCityRepo {
 static Map<String,dynamic> data = {
    "states": [
      {
        "id": "egypt",
        "name": "Egypt",
        "image": "https://images.unsplash.com/photo-1503177119275-0aa32b3a9368",
        "details": {
          "about": "Egypt is a country in North Africa known for the pyramids and Nile River.",
          "howToReach": "Cairo International Airport",
          "emergencyNumber": "122",
          "images": [
            "https://images.unsplash.com/photo-1539650116574-75c0c6d4d4e8",
            "https://images.unsplash.com/photo-1548013146-72479768bada"
          ],
          "reviews": [
            {"user": "Ali", "rating": 4.7, "comment": "Amazing history"},
            {"user": "Sara", "rating": 4.5, "comment": "Beautiful places"}
          ]
        }
      },
      {
        "id": "france",
        "name": "France",
        "image": "https://images.unsplash.com/photo-1502602898657-3e91760cbb34",
        "details": {
          "about": "France is famous for art, fashion, and culture.",
          "howToReach": "Charles de Gaulle Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1499856871958-5b9627545d1a",
            "https://images.unsplash.com/photo-1502602898657-3e91760cbb34"
          ],
          "reviews": [
            {"user": "John", "rating": 4.8, "comment": "Romantic place"}
          ]
        }
      },
      {
        "id": "italy",
        "name": "Italy",
        "image": "https://images.unsplash.com/photo-1529260830199-42c24126f198?auto=format&fit=crop&w=800&q=80",
        "details": {
          "about": "Italy is known for history, food, and architecture.",
          "howToReach": "Rome Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1529260830199-42c24126f198?auto=format&fit=crop&w=800&q=80",
            "https://images.unsplash.com/photo-1526481280695-3c687fd5432c?auto=format&fit=crop&w=800&q=80"
          ],
          "reviews": [
            {"user": "Marco", "rating": 4.9, "comment": "Best food ever"}
          ]
        }
      },
      {
        "id": "usa",
        "name": "United States",
        "image": "https://images.unsplash.com/photo-1485738422979-f5c462d49f74",
        "details": {
          "about": "A large country with diverse culture and landscapes.",
          "howToReach": "JFK Airport",
          "emergencyNumber": "911",
          "images": [
            "https://images.unsplash.com/photo-1498936178812-4b2e558d2937",
            "https://images.unsplash.com/photo-1501594907352-04cda38ebc29"
          ],
          "reviews": [
            {"user": "Mike", "rating": 4.7, "comment": "Huge and exciting"}
          ]
        }
      },
      {
        "id": "turkey",
        "name": "Turkey",
        "image": "https://images.unsplash.com/photo-1524231757912-21f4fe3a7200",
        "details": {
          "about": "A mix of European and Asian culture.",
          "howToReach": "Istanbul Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1530903677198-7c4b1d7d8b3f",
            "https://images.unsplash.com/photo-1524231757912-21f4fe3a7200"
          ],
          "reviews": [
            {"user": "Ahmed", "rating": 4.6, "comment": "Great vibes"}
          ]
        }
      },
      {
        "id": "spain",
        "name": "Spain",
        "image": "https://images.unsplash.com/photo-1509840841025-9088ba78a826",
        "details": {
          "about": "Known for beaches and festivals.",
          "howToReach": "Madrid Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1505731132164-cca9c79d1d5a",
            "https://images.unsplash.com/photo-1509840841025-9088ba78a826"
          ],
          "reviews": [
            {"user": "Luis", "rating": 4.5, "comment": "Fun country"}
          ]
        }
      },
      {
        "id": "germany",
        "name": "Germany",
        "image": "https://images.unsplash.com/photo-1467269204594-9661b134dd2b",
        "details": {
          "about": "Known for engineering and history.",
          "howToReach": "Berlin Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1478720568477-152d9b164e26",
            "https://images.unsplash.com/photo-1467269204594-9661b134dd2b"
          ],
          "reviews": [
            {"user": "Anna", "rating": 4.4, "comment": "Nice places"}
          ]
        }
      },
      {
        "id": "japan",
        "name": "Japan",
        "image": "https://images.unsplash.com/photo-1505060892479-4b84f0c5c3d5",
        "details": {
          "about": "Modern and traditional culture combined.",
          "howToReach": "Tokyo Airport",
          "emergencyNumber": "110",
          "images": [
            "https://images.unsplash.com/photo-1491884662610-dfcd28f30cfb",
            "https://images.unsplash.com/photo-1505060892479-4b84f0c5c3d5"
          ],
          "reviews": [
            {"user": "Ken", "rating": 4.9, "comment": "Amazing tech"}
          ]
        }
      },
      {
        "id": "uae",
        "name": "UAE",
        "image": "https://images.unsplash.com/photo-1518684079-3c830dcef090",
        "details": {
          "about": "Modern luxury and skyscrapers.",
          "howToReach": "Dubai Airport",
          "emergencyNumber": "999",
          "images": [
            "https://images.unsplash.com/photo-1518684079-3c830dcef090",
            "https://images.unsplash.com/photo-1539650116574-75c0c6d4d4e8"
          ],
          "reviews": [
            {"user": "Omar", "rating": 4.8, "comment": "Luxury life"}
          ]
        }
      },
      {
        "id": "brazil",
        "name": "Brazil",
        "image": "https://images.unsplash.com/photo-1483721310020-03333e577078",
        "details": {
          "about": "Famous for carnival and beaches.",
          "howToReach": "Rio Airport",
          "emergencyNumber": "190",
          "images": [
            "https://images.unsplash.com/photo-1483721310020-03333e577078",
            "https://images.unsplash.com/photo-1501594907352-04cda38ebc29"
          ],
          "reviews": [
            {"user": "Leo", "rating": 4.6, "comment": "Fun vibes"}
          ]
        }
      }
    ],

    "cities": [
      {"id": "cairo",
        "stateId": "egypt",
        "name": "Cairo",
        "image": "https://source.unsplash.com/600x400/?cairo",
        "details":
        {"about": "Capital of Egypt",
          "howToReach": "Airport",
          "emergencyNumber": "122",
          "images": ["https://source.unsplash.com/600x400/?cairo,night"],
          "reviews": [
            {"user": "Ali",
              "rating": 5,
              "comment": "Great"}
          ]
        }
      },

      {
        "id": "alex",
        "stateId": "egypt",
        "name": "Alexandria",
        "image": "https://source.unsplash.com/600x400/?alexandria",
        "details": {
          "about": "Coastal city",
          "howToReach": "Train",
          "emergencyNumber": "122",
          "images": ["https://source.unsplash.com/600x400/?sea"],
          "reviews": [{"user": "Sara", "rating": 4.5, "comment": "Nice"}]
        }
      },

      {
        "id": "paris",
        "stateId": "france",
        "name": "Paris",
        "image": "https://source.unsplash.com/600x400/?paris",
        "details": {
          "about": "City of lights",
          "howToReach": "CDG Airport",
          "emergencyNumber": "112",
          "images": ["https://source.unsplash.com/600x400/?eiffel"],
          "reviews": [{"user": "John", "rating": 5, "comment": "Amazing"}]
        }
      },
      {
        "id": "lyon",
        "stateId": "france",
        "name": "Lyon",
        "image": "https://source.unsplash.com/600x400/?lyon",
        "details": {
          "about": "Food capital",
          "howToReach": "Train",
          "emergencyNumber": "112",
          "images": ["https://source.unsplash.com/600x400/?food"],
          "reviews": [{"user": "Anna", "rating": 4.5, "comment": "Yummy"}]
        }
      },

      {
        "id": "rome",
        "stateId": "italy",
        "name": "Rome",
        "image": "https://source.unsplash.com/600x400/?rome",
        "details": {
          "about": "Historic city",
          "howToReach": "Airport",
          "emergencyNumber": "112",
          "images": ["https://source.unsplash.com/600x400/?colosseum"],
          "reviews": [{"user": "Marco", "rating": 5, "comment": "History"}]
        }
      },
      {
        "id": "venice",
        "stateId": "italy",
        "name": "Venice",
        "image": "https://source.unsplash.com/600x400/?venice",
        "details": {
          "about": "Canals",
          "howToReach": "Boat",
          "emergencyNumber": "112",
          "images": ["https://source.unsplash.com/600x400/?canal"],
          "reviews": [{"user": "Luca", "rating": 4.9, "comment": "Romantic"}]
        }
      },

      {
        "id": "istanbul",
        "stateId": "turkey",
        "name": "Istanbul",
        "image": "https://source.unsplash.com/600x400/?istanbul",
        "details": {
          "about": "Historic city",
          "howToReach": "Airport",
          "emergencyNumber": "112",
          "images": ["https://source.unsplash.com/600x400/?mosque"],
          "reviews": [{"user": "Ali", "rating": 4.7, "comment": "Nice"}]
        }
      },

      {
        "id": "ny",
        "stateId": "usa",
        "name": "New York",
        "image": "https://source.unsplash.com/600x400/?newyork",
        "details": {
          "about": "Big city",
          "howToReach": "JFK",
          "emergencyNumber": "911",
          "images": ["https://source.unsplash.com/600x400/?times-square"],
          "reviews": [{"user": "Mike", "rating": 5, "comment": "Amazing"}]
        }
      },
      {
        "id": "la",
        "stateId": "usa",
        "name": "Los Angeles",
        "image": "https://source.unsplash.com/600x400/?losangeles",
        "details": {
          "about": "Hollywood",
          "howToReach": "LAX",
          "emergencyNumber": "911",
          "images": ["https://source.unsplash.com/600x400/?hollywood"],
          "reviews": [{"user": "Sara", "rating": 4.6, "comment": "Cool"}]
        }
      },

    ]
  };

}
