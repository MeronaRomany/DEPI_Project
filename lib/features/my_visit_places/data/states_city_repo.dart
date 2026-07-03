class StateCityRepo {
  static Map<String, dynamic> data = {
    "states": [
      {
        "id": "egypt",
        "name": "Egypt",
        "image": "https://images.unsplash.com/photo-1503177119275-0aa32b3a9368",
        "details": {
          "about":
              "Egypt is a country in North Africa known for the pyramids and Nile River.",
          "howToReach": "Cairo International Airport",
          "emergencyNumber": "122",
          "images": [
            "https://images.unsplash.com/photo-1539650116574-75c0c6d4d4e8",
            "https://images.unsplash.com/photo-1548013146-72479768bada",
          ],
          "reviews": [
            {"user": "Ali", "rating": 4.7, "comment": "Amazing history"},
            {"user": "Sara", "rating": 4.5, "comment": "Beautiful places"},
          ],
        },
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
            "https://images.unsplash.com/photo-1502602898657-3e91760cbb34",
          ],
          "reviews": [
            {"user": "John", "rating": 4.8, "comment": "Romantic place"},
          ],
        },
      },
      {
        "id": "italy",
        "name": "Italy",
        "image":
            "https://images.unsplash.com/photo-1529260830199-42c24126f198?auto=format&fit=crop&w=800&q=80",
        "details": {
          "about": "Italy is known for history, food, and architecture.",
          "howToReach": "Rome Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1529260830199-42c24126f198?auto=format&fit=crop&w=800&q=80",
            "https://images.unsplash.com/photo-1526481280695-3c687fd5432c?auto=format&fit=crop&w=800&q=80",
          ],
          "reviews": [
            {"user": "Marco", "rating": 4.9, "comment": "Best food ever"},
          ],
        },
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
            "https://images.unsplash.com/photo-1501594907352-04cda38ebc29",
          ],
          "reviews": [
            {"user": "Mike", "rating": 4.7, "comment": "Huge and exciting"},
          ],
        },
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
            "https://images.unsplash.com/photo-1524231757912-21f4fe3a7200",
          ],
          "reviews": [
            {"user": "Ahmed", "rating": 4.6, "comment": "Great vibes"},
          ],
        },
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
            "https://images.unsplash.com/photo-1509840841025-9088ba78a826",
          ],
          "reviews": [
            {"user": "Luis", "rating": 4.5, "comment": "Fun country"},
          ],
        },
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
            "https://images.unsplash.com/photo-1467269204594-9661b134dd2b",
          ],
          "reviews": [
            {"user": "Anna", "rating": 4.4, "comment": "Nice places"},
          ],
        },
      },
      {
        "id": "japan",
        "name": "Japan",
        "image": "https://images.unsplash.com/photo-1491884662610-dfcd28f30cfb",
        "details": {
          "about": "Modern and traditional culture combined.",
          "howToReach": "Tokyo Airport",
          "emergencyNumber": "110",
          "images": [
            "https://images.unsplash.com/photo-1503899036084-c55cdd92da26",
            "https://images.unsplash.com/photo-1526481280695-3c687fd5432c",
          ],
          "reviews": [
            {
              "user": "Ken",
              "rating": 4.9,
              "comment": "Amazing tech and culture",
            },
          ],
        },
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
            "https://images.unsplash.com/photo-1539650116574-75c0c6d4d4e8",
          ],
          "reviews": [
            {"user": "Omar", "rating": 4.8, "comment": "Luxury life"},
          ],
        },
      },
      {
        "id": "brazil",
        "name": "Brazil",
        "image": "https://images.unsplash.com/photo-1518638150340-f706e86654de",
        "details": {
          "about": "Famous for carnival, beaches, and vibrant culture.",
          "howToReach": "Rio de Janeiro Airport",
          "emergencyNumber": "190",
          "images": [
            "https://images.unsplash.com/photo-1518638150340-f706e86654de",
            "https://images.unsplash.com/photo-1500375592092-40eb2168fd21",
          ],
          "reviews": [
            {
              "user": "Leo",
              "rating": 4.6,
              "comment": "Fun vibes and amazing beaches",
            },
          ],
        },
      },

      {
        "id": "uk",
        "name": "United Kingdom",
        "image": "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad",
        "details": {
          "about": "UK is famous for history, museums, and London landmarks.",
          "howToReach": "Heathrow Airport",
          "emergencyNumber": "999",
          "images": [
            "https://images.unsplash.com/photo-1526129318478-62ed807ebdf9",
            "https://images.unsplash.com/photo-1499092346589-b9b6be3e94b2",
          ],
          "reviews": [
            {"user": "Sam", "rating": 4.7, "comment": "Iconic places"},
          ],
        },
      },

      {
        "id": "greece",
        "name": "Greece",
        "image": "https://images.unsplash.com/photo-1505761671935-60b3a7427bad",
        "details": {
          "about": "Greece is known for ancient ruins and islands.",
          "howToReach": "Athens Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
            "https://images.unsplash.com/photo-1518638150340-f706e86654de",
          ],
          "reviews": [
            {"user": "Nikos", "rating": 4.8, "comment": "Beautiful islands"},
          ],
        },
      },

      {
        "id": "china",
        "name": "China",
        "image": "https://images.unsplash.com/photo-1508804185872-d7badad00f7d",
        "details": {
          "about": "China has ancient history and modern cities.",
          "howToReach": "Beijing Airport",
          "emergencyNumber": "110",
          "images": [
            "https://images.unsplash.com/photo-1528181304800-259b08848526",
            "https://images.unsplash.com/photo-1507371341162-763b5e419408",
          ],
          "reviews": [
            {"user": "Li", "rating": 4.7, "comment": "Huge and historic"},
          ],
        },
      },

      {
        "id": "india",
        "name": "India",
        "image": "https://images.unsplash.com/photo-1524492412937-b28074a5d7da",
        "details": {
          "about": "India is rich in culture, temples, and food.",
          "howToReach": "Delhi Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1506976785307-8732e854ad03",
            "https://images.unsplash.com/photo-1524492449090-1c3b5b1b1f3c",
          ],
          "reviews": [
            {
              "user": "Rahul",
              "rating": 4.6,
              "comment": "Very colorful country",
            },
          ],
        },
      },

      {
        "id": "thailand",
        "name": "Thailand",
        "image": "https://images.unsplash.com/photo-1508009603885-50cf7c579365",
        "details": {
          "about": "Thailand is famous for beaches and temples.",
          "howToReach": "Bangkok Airport",
          "emergencyNumber": "191",
          "images": [
            "https://images.unsplash.com/photo-1528181304800-259b08848526",
            "https://images.unsplash.com/photo-1500673922987-e212871fec22",
          ],
          "reviews": [
            {
              "user": "Tom",
              "rating": 4.7,
              "comment": "Amazing food and beaches",
            },
          ],
        },
      },

      {
        "id": "south_korea",
        "name": "South Korea",
        "image": "https://images.unsplash.com/photo-1528150177508-7cc0c36cda5c",
        "details": {
          "about": "South Korea is modern with strong culture and tech.",
          "howToReach": "Seoul Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1538485399081-7b0c0a0b3c17",
            "https://images.unsplash.com/photo-1506377585622-bedcbb027afc",
          ],
          "reviews": [
            {"user": "Min", "rating": 4.8, "comment": "Very advanced country"},
          ],
        },
      },

      {
        "id": "canada",
        "name": "Canada",
        "image": "https://images.unsplash.com/photo-1503614472-8c93d56e92ce",
        "details": {
          "about": "Canada is known for nature, lakes, and mountains.",
          "howToReach": "Toronto Airport",
          "emergencyNumber": "911",
          "images": [
            "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
            "https://images.unsplash.com/photo-1504198453319-5ce911bafcde",
          ],
          "reviews": [
            {"user": "James", "rating": 4.9, "comment": "Beautiful nature"},
          ],
        },
      },

      {
        "id": "mexico",
        "name": "Mexico",
        "image": "https://images.unsplash.com/photo-1500916434205-0c77489c6cf7",
        "details": {
          "about": "Mexico is rich in culture, food, and beaches.",
          "howToReach": "Mexico City Airport",
          "emergencyNumber": "911",
          "images": [
            "https://images.unsplash.com/photo-1526401485004-2aa6b7f9b8d0",
            "https://images.unsplash.com/photo-1500916434205-0c77489c6cf7",
          ],
          "reviews": [
            {"user": "Carlos", "rating": 4.7, "comment": "Very lively country"},
          ],
        },
      },

      {
        "id": "switzerland",
        "name": "Switzerland",
        "image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
        "details": {
          "about": "Switzerland is famous for mountains and lakes.",
          "howToReach": "Zurich Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
            "https://images.unsplash.com/photo-1500375592092-40eb2168fd21",
          ],
          "reviews": [
            {
              "user": "Hans",
              "rating": 4.9,
              "comment": "Very clean and peaceful",
            },
          ],
        },
      },
    ],

    "cities": [
      {
        "id": "cairo",
        "stateId": "egypt",
        "name": "Cairo",
        "image": "https://images.unsplash.com/photo-1572252009286-268acec5ca0a",
        "details": {
          "about": "Capital of Egypt",
          "howToReach": "Airport",
          "emergencyNumber": "122",
          "images": [
            "https://images.unsplash.com/photo-1568322445389-f64ac2515020",
            "https://images.unsplash.com/photo-1583422409516-2895a77efded",
          ],
          "reviews": [
            {"user": "Ali", "rating": 5, "comment": "Great"},
          ],
        },
      },

      {
        "id": "alex",
        "stateId": "egypt",
        "name": "Alexandria",
        "image": "https://images.unsplash.com/photo-1548013146-72479768bada",
        "details": {
          "about": "Coastal city",
          "howToReach": "Train",
          "emergencyNumber": "122",
          "images": [
            "https://images.unsplash.com/photo-1518638150340-f706e86654de",
            "https://images.unsplash.com/photo-1500375592092-40eb2168fd21",
          ],
          "reviews": [
            {"user": "Sara", "rating": 4.5, "comment": "Nice"},
          ],
        },
      },

      {
        "id": "paris",
        "stateId": "france",
        "name": "Paris",
        "image": "https://images.unsplash.com/photo-1502602898657-3e91760cbb34",
        "details": {
          "about": "City of lights",
          "howToReach": "CDG Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1502602898657-3e91760cbb34",
            "https://images.unsplash.com/photo-1522093007474-d86e9bf7ba6f",
          ],
          "reviews": [
            {"user": "John", "rating": 5, "comment": "Amazing"},
          ],
        },
      },
      {
        "id": "lyon",
        "stateId": "france",
        "name": "Lyon",
        "image": "https://images.unsplash.com/photo-1521295121783-8a321d551ad2",
        "details": {
          "about": "Food capital",
          "howToReach": "Train",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1500673922987-e212871fec22",
            "https://images.unsplash.com/photo-1506806732259-39c2d0268443",
          ],
          "reviews": [
            {"user": "Anna", "rating": 4.5, "comment": "Yummy"},
          ],
        },
      },

      {
        "id": "rome",
        "stateId": "italy",
        "name": "Rome",
        "image": "https://images.unsplash.com/photo-1552832230-c0197dd311b5",
        "details": {
          "about": "Historic city",
          "howToReach": "Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1526481280695-3c687fd5432c",
            "https://images.unsplash.com/photo-1555992336-03a23c4b4c2c",
          ],
          "reviews": [
            {"user": "Marco", "rating": 5, "comment": "History"},
          ],
        },
      },
      {
        "id": "venice",
        "stateId": "italy",
        "name": "Venice",
        "image": "https://images.unsplash.com/photo-1514890547357-a9ee288728e0",
        "details": {
          "about": "Canals",
          "howToReach": "Boat",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1523906834658-6e24ef2386f9",
            "https://images.unsplash.com/photo-1505761671935-60b3a7427bad",
          ],
          "reviews": [
            {"user": "Luca", "rating": 4.9, "comment": "Romantic"},
          ],
        },
      },

      {
        "id": "istanbul",
        "stateId": "turkey",
        "name": "Istanbul",
        "image": "https://images.unsplash.com/photo-1527838832700-5059252407fa",
        "details": {
          "about": "Historic city",
          "howToReach": "Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1524231757912-21f4fe3a7200",
            "https://images.unsplash.com/photo-1580834341580-8c17a3a6309c",
          ],
          "reviews": [
            {"user": "Ali", "rating": 4.7, "comment": "Nice"},
          ],
        },
      },

      {
        "id": "ny",
        "stateId": "usa",
        "name": "New York",
        "image": "https://images.unsplash.com/photo-1499092346589-b9b6be3e94b2",
        "details": {
          "about": "Big city",
          "howToReach": "JFK",
          "emergencyNumber": "911",
          "images": [
            "https://images.unsplash.com/photo-1546436836-07a91091f160",
            "https://images.unsplash.com/photo-1522083165195-3424ed129620",
          ],
          "reviews": [
            {"user": "Mike", "rating": 5, "comment": "Amazing"},
          ],
        },
      },
      {
        "id": "la",
        "stateId": "usa",
        "name": "Los Angeles",
        "image": "https://images.unsplash.com/photo-1534190760961-74e8c1c5c3da",
        "details": {
          "about": "Hollywood",
          "howToReach": "LAX",
          "emergencyNumber": "911",
          "images": [
            "https://images.unsplash.com/photo-1500916434205-0c77489c6cf7",
            "https://images.unsplash.com/photo-1526401485004-2aa6b7f9b8d0",
          ],
          "reviews": [
            {"user": "Sara", "rating": 4.6, "comment": "Cool"},
          ],
        },
      },

      {
        "id": "tokyo",
        "stateId": "japan",
        "name": "Tokyo",
        "image": "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf",
        "details": {
          "about": "Tokyo is a modern city blending technology and tradition.",
          "howToReach": "Narita International Airport",
          "emergencyNumber": "110",
          "images": [
            "https://images.unsplash.com/photo-1503899036084-c55cdd92da26",
            "https://images.unsplash.com/photo-1491884662610-dfcd28f30cfb",
          ],
          "reviews": [
            {"user": "Ken", "rating": 4.9, "comment": "Amazing city life"},
          ],
        },
      },

      {
        "id": "barcelona",
        "stateId": "spain",
        "name": "Barcelona",
        "image": "https://images.unsplash.com/photo-1583422409516-2895a77efded",
        "details": {
          "about": "Barcelona is famous for architecture and beaches.",
          "howToReach": "Barcelona El Prat Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1526481280695-3c687fd5432c",
            "https://images.unsplash.com/photo-1509840841025-9088ba78a826",
          ],
          "reviews": [
            {"user": "Luis", "rating": 4.8, "comment": "Beautiful city"},
          ],
        },
      },

      {
        "id": "amsterdam",
        "stateId": "netherlands",
        "name": "Amsterdam",
        "image": "https://images.unsplash.com/photo-1512470876302-972faa2aa9a4",
        "details": {
          "about": "Amsterdam is known for canals and bikes.",
          "howToReach": "Schiphol Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1502602898657-3e91760cbb34",
            "https://images.unsplash.com/photo-1522093007474-d86e9bf7ba6f",
          ],
          "reviews": [
            {"user": "Anna", "rating": 4.7, "comment": "Very peaceful city"},
          ],
        },
      },

      {
        "id": "prague",
        "stateId": "czech",
        "name": "Prague",
        "image": "https://images.unsplash.com/photo-1541849546-216549ae216d",
        "details": {
          "about": "Prague is a historic European city full of castles.",
          "howToReach": "Prague Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1519677100203-a0e668c92439",
            "https://images.unsplash.com/photo-1526481280695-3c687fd5432c",
          ],
          "reviews": [
            {"user": "David", "rating": 4.8, "comment": "Old town is magical"},
          ],
        },
      },

      {
        "id": "vienna",
        "stateId": "austria",
        "name": "Vienna",
        "image": "https://images.unsplash.com/photo-1516550893923-42d28e5677af",
        "details": {
          "about": "Vienna is known for classical music and palaces.",
          "howToReach": "Vienna International Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1523906834658-6e24ef2386f9",
            "https://images.unsplash.com/photo-1505761671935-60b3a7427bad",
          ],
          "reviews": [
            {"user": "Mark", "rating": 4.6, "comment": "Elegant city"},
          ],
        },
      },

      {
        "id": "bangkok",
        "stateId": "thailand",
        "name": "Bangkok",
        "image": "https://images.unsplash.com/photo-1508009603885-50cf7c579365",
        "details": {
          "about": "Bangkok is famous for temples and street food.",
          "howToReach": "Suvarnabhumi Airport",
          "emergencyNumber": "191",
          "images": [
            "https://images.unsplash.com/photo-1528181304800-259b08848526",
            "https://images.unsplash.com/photo-1500673922987-e212871fec22",
          ],
          "reviews": [
            {"user": "Tom", "rating": 4.5, "comment": "Great food and culture"},
          ],
        },
      },

      {
        "id": "london",
        "stateId": "uk",
        "name": "London",
        "image": "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad",
        "details": {
          "about": "London is rich in history and landmarks.",
          "howToReach": "Heathrow Airport",
          "emergencyNumber": "999",
          "images": [
            "https://images.unsplash.com/photo-1526129318478-62ed807ebdf9",
            "https://images.unsplash.com/photo-1499092346589-b9b6be3e94b2",
          ],
          "reviews": [
            {"user": "Sam", "rating": 4.7, "comment": "Iconic city"},
          ],
        },
      },

      {
        "id": "dubai",
        "stateId": "uae",
        "name": "Dubai",
        "image": "https://images.unsplash.com/photo-1512453979798-5ea266f8880c",
        "details": {
          "about": "Dubai is a modern luxury city with skyscrapers.",
          "howToReach": "Dubai International Airport",
          "emergencyNumber": "999",
          "images": [
            "https://images.unsplash.com/photo-1518684079-3c830dcef090",
            "https://images.unsplash.com/photo-1500375592092-40eb2168fd21",
          ],
          "reviews": [
            {"user": "Omar", "rating": 4.8, "comment": "Luxury everywhere"},
          ],
        },
      },

      {
        "id": "athens",
        "stateId": "greece",
        "name": "Athens",
        "image": "https://images.unsplash.com/photo-1555993539-1732b0258235",
        "details": {
          "about": "Historic city known for ancient Greek civilization.",
          "howToReach": "Athens Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1603565816030-6b389eeb23cb",
          ],
          "reviews": [
            {
              "user": "Mina",
              "rating": 4.7,
              "comment": "Great historical places",
            },
          ],
        },
      },
      {
        "id": "madrid",
        "stateId": "spain",
        "name": "Madrid",
        "image": "https://images.unsplash.com/photo-1539037116277-4db20889f2d4",
        "details": {
          "about": "Capital of Spain with art museums and plazas.",
          "howToReach": "Madrid Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1543783207-ec64e4d95325",
          ],
          "reviews": [
            {
              "user": "Luis",
              "rating": 4.5,
              "comment": "Beautiful architecture",
            },
          ],
        },
      },

      {
        "id": "singapore",
        "stateId": "singapore",
        "name": "Singapore",
        "image": "https://images.unsplash.com/photo-1525625293386-3f8f99389edd",
        "details": {
          "about":
              "Singapore is a modern city known for cleanliness, skyscrapers, and Marina Bay.",
          "howToReach": "Changi Airport",
          "emergencyNumber": "999",
          "images": [
            "https://images.unsplash.com/photo-1508964942454-1a56651d54ac",
            "https://images.unsplash.com/photo-1525625293386-3f8f99389edd",
          ],
          "reviews": [
            {
              "user": "Alex",
              "rating": 4.9,
              "comment": "Super clean and futuristic city",
            },
          ],
        },
      },

      {
        "id": "marrakech",
        "stateId": "morocco",
        "name": "Marrakech",
        "image": "https://images.unsplash.com/photo-1548013146-72479768bada",
        "details": {
          "about":
              "Marrakech is famous for markets, colors, and traditional Moroccan culture.",
          "howToReach": "Marrakech Menara Airport",
          "emergencyNumber": "190",
          "images": [
            "https://images.unsplash.com/photo-1528127269322-539801943592",
            "https://images.unsplash.com/photo-1548013146-72479768bada",
          ],
          "reviews": [
            {
              "user": "Sara",
              "rating": 4.7,
              "comment": "Very cultural and lively",
            },
          ],
        },
      },

      {
        "id": "istanbul",
        "stateId": "turkey",
        "name": "Istanbul",
        "image": "https://images.unsplash.com/photo-1527838832700-5059252407fa",
        "details": {
          "about":
              "Istanbul connects Europe and Asia with rich history and mosques.",
          "howToReach": "Istanbul Airport",
          "emergencyNumber": "112",
          "images": [
            "https://images.unsplash.com/photo-1542051841857-5f90071e7989",
            "https://images.unsplash.com/photo-1527838832700-5059252407fa",
          ],
          "reviews": [
            {
              "user": "Ali",
              "rating": 4.8,
              "comment": "Beautiful mix of cultures",
            },
          ],
        },
      },

      {
        "id": "cape_town",
        "stateId": "south_africa",
        "name": "Cape Town",
        "image": "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad",
        "details": {
          "about": "Cape Town is famous for Table Mountain and ocean views.",
          "howToReach": "Cape Town International Airport",
          "emergencyNumber": "10111",
          "images": [
            "https://images.unsplash.com/photo-1501594907352-04cda38ebc29",
            "https://images.unsplash.com/photo-1519817914152-22d216bb9170",
          ],
          "reviews": [
            {
              "user": "Mike",
              "rating": 4.9,
              "comment": "Nature is breathtaking",
            },
          ],
        },
      },

      {
        "id": "sydney",
        "stateId": "australia",
        "name": "Sydney",
        "image": "https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9",
        "details": {
          "about": "Sydney is known for Opera House and Harbour Bridge.",
          "howToReach": "Sydney Airport",
          "emergencyNumber": "000",
          "images": [
            "https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9",
            "https://images.unsplash.com/photo-1507608616759-54f48f0af0ee",
          ],
          "reviews": [
            {
              "user": "John",
              "rating": 4.8,
              "comment": "Amazing skyline and beaches",
            },
          ],
        },
      },

      {
        "id": "rio",
        "stateId": "brazil",
        "name": "Rio de Janeiro",
        "image": "https://images.unsplash.com/photo-1483721310020-03333e577078",
        "details": {
          "about":
              "Rio is famous for beaches, carnival, and Christ the Redeemer.",
          "howToReach": "Galeão International Airport",
          "emergencyNumber": "190",
          "images": [
            "https://images.unsplash.com/photo-1500916434205-0c77489c6cf7",
            "https://images.unsplash.com/photo-1526401485004-2aa6b7f9b8d0",
          ],
          "reviews": [
            {
              "user": "Carlos",
              "rating": 4.7,
              "comment": "Very fun and energetic city",
            },
          ],
        },
      },
    ],
  };
}
