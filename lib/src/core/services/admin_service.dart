import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dictionarydox/src/data/datasources/remote/pexels_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

/// Service for admin operations
class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _unitsCollection = 'units';
  final String _wordsCollection = 'words';
  final PexelsRemoteDataSource _pexelsDataSource =
      PexelsRemoteDataSourceImpl(Dio());

  // Words list - can be modified manually
  List<Map<String, dynamic>> wordsList = [
    /* ---------------------------------------------------------
      HOUSE ITEMS (20+)
  --------------------------------------------------------- */
    {
      "id": "house_chair",
      "english": "Chair",
      "uzbek": "Stul",
      "phonetic": "/tʃeər/",
      "example": "He sat on the chair.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A seat for one person."
    },
    {
      "id": "house_table",
      "english": "Table",
      "uzbek": "Stol",
      "phonetic": "/ˈteɪ.bəl/",
      "example": "The keys are on the table.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A flat surface with legs."
    },
    {
      "id": "house_bed",
      "english": "Bed",
      "uzbek": "Yotoq",
      "phonetic": "/bed/",
      "example": "The bed is soft.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "Furniture used for sleeping."
    },
    {
      "id": "house_sofa",
      "english": "Sofa",
      "uzbek": "Divan",
      "phonetic": "/ˈsəʊ.fə/",
      "example": "They bought a new sofa.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A long soft seat."
    },
    {
      "id": "house_armchair",
      "english": "Armchair",
      "uzbek": "Kreslo",
      "phonetic": "/ˈɑːm.tʃeər/",
      "example": "He relaxed in the armchair.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A large comfortable chair."
    },
    {
      "id": "house_shelf",
      "english": "Shelf",
      "uzbek": "Raf",
      "phonetic": "/ʃelf/",
      "example": "Books are on the shelf.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A flat board for storage."
    },
    {
      "id": "house_cabinet",
      "english": "Cabinet",
      "uzbek": "Shkaf",
      "phonetic": "/ˈkæb.ɪ.nət/",
      "example": "The dishes are in the cabinet.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A storage unit with doors."
    },
    {
      "id": "house_fridge",
      "english": "Refrigerator",
      "uzbek": "Muzlatkich",
      "phonetic": "/rɪˈfrɪdʒ.ə.reɪ.tər/",
      "example": "Milk is in the refrigerator.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A device that keeps food cold."
    },
    {
      "id": "house_freezer",
      "english": "Freezer",
      "uzbek": "Muzlatkich bo‘limi",
      "phonetic": "/ˈfriː.zər/",
      "example": "Ice cream is in the freezer.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A compartment for freezing food."
    },
    {
      "id": "house_oven",
      "english": "Oven",
      "uzbek": "Duxovka",
      "phonetic": "/ˈʌv.ən/",
      "example": "The cake is baking in the oven.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A chamber for baking food."
    },
    {
      "id": "house_stove",
      "english": "Stove",
      "uzbek": "Pechka",
      "phonetic": "/stəʊv/",
      "example": "She cooked pasta on the stove.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A kitchen appliance for cooking."
    },
    {
      "id": "house_microwave",
      "english": "Microwave",
      "uzbek": "Mikroto‘lqinli pech",
      "phonetic": "/ˈmaɪ.krə.weɪv/",
      "example": "He warmed food in the microwave.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A device that heats food quickly."
    },
    {
      "id": "house_tv",
      "english": "Television",
      "uzbek": "Televizor",
      "phonetic": "/ˈtel.ɪ.vɪʒ.ən/",
      "example": "She watched a movie on the TV.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "An electronic screen for viewing media."
    },
    {
      "id": "house_remote",
      "english": "Remote Control",
      "uzbek": "Pult",
      "phonetic": "/rɪˌməʊt kənˈtrəʊl/",
      "example": "The remote control is missing.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A handheld device for operating electronics."
    },
    {
      "id": "house_fan",
      "english": "Fan",
      "uzbek": "Ventilyator",
      "phonetic": "/fæn/",
      "example": "The fan keeps the room cool.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A device that moves air."
    },
    {
      "id": "house_air_conditioner",
      "english": "Air Conditioner",
      "uzbek": "Konditsioner",
      "phonetic": "/ˈeə kənˌdɪʃ.ən.ər/",
      "example": "The air conditioner is on.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A device that cools the air."
    },
    {
      "id": "house_washing_machine",
      "english": "Washing Machine",
      "uzbek": "Kir yuvish mashinasi",
      "phonetic": "/ˈwɒʃ.ɪŋ məˌʃiːn/",
      "example": "The washing machine is running.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A machine that washes clothes."
    },
    {
      "id": "house_dryer",
      "english": "Dryer",
      "uzbek": "Kiyim quritgich",
      "phonetic": "/ˈdraɪ.ər/",
      "example": "The dryer finished its cycle.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A machine that dries clothes."
    },
    {
      "id": "house_light",
      "english": "Light",
      "uzbek": "Chiroq",
      "phonetic": "/laɪt/",
      "example": "She turned on the light.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A device that produces illumination."
    },
    {
      "id": "house_trash",
      "english": "Trash Can",
      "uzbek": "Axlat qutisi",
      "phonetic": "/træʃ kæn/",
      "example": "He threw it in the trash can.",
      "imageUrl": "",
      "unitId": "unit_house_items",
      "description": "A container for disposing waste."
    },

    /* ---------------------------------------------------------
      WEATHER (20+)
  --------------------------------------------------------- */

    {
      "id": "weather_sunny",
      "english": "Sunny",
      "uzbek": "Quyoshli",
      "phonetic": "/ˈsʌn.i/",
      "example": "It was sunny today.",
      "imageUrl": "",
      "unitId": "unit_weather",
      "description": "Bright with sunlight."
    },
    {
      "id": "weather_rainy",
      "english": "Rainy",
      "uzbek": "Yomg‘irli",
      "phonetic": "/ˈreɪ.ni/",
      "example": "It became rainy in the afternoon.",
      "imageUrl": "",
      "unitId": "unit_weather",
      "description": "Characterized by rain."
    },
    {
      "id": "weather_cloudy",
      "english": "Cloudy",
      "uzbek": "Bulutli",
      "phonetic": "/ˈklaʊ.di/",
      "example": "The sky is cloudy.",
      "imageUrl": "",
      "unitId": "unit_weather",
      "description": "Covered with clouds."
    },
    {
      "id": "weather_snowy",
      "english": "Snowy",
      "uzbek": "Qorli",
      "phonetic": "/ˈsnəʊ.i/",
      "example": "It was snowy all morning.",
      "imageUrl": "",
      "unitId": "unit_weather",
      "description": "With falling snow."
    },
    {
      "id": "weather_windy",
      "english": "Windy",
      "uzbek": "Shamolli",
      "phonetic": "/ˈwɪn.di/",
      "example": "It’s too windy outside.",
      "imageUrl": "",
      "unitId": "unit_weather",
      "description": "Full of wind."
    },
    {
      "id": "weather_foggy",
      "english": "Foggy",
      "uzbek": "Tumanli",
      "phonetic": "/ˈfɒɡ.i/",
      "example": "The road is foggy.",
      "imageUrl": "",
      "unitId": "unit_weather",
      "description": "Full of thick mist."
    },
    {
      "id": "weather_hot",
      "english": "Hot",
      "uzbek": "Issiq",
      "phonetic": "/hɒt/",
      "example": "It’s too hot in summer.",
      "imageUrl": "",
      "unitId": "unit_weather",
      "description": "High temperature."
    },
    {
      "id": "weather_cold",
      "english": "Cold",
      "uzbek": "Sovuq",
      "phonetic": "/kəʊld/",
      "example": "It is very cold in winter.",
      "imageUrl": "",
      "unitId": "unit_weather",
      "description": "Low temperature."
    },
    {
      "id": "weather_stormy",
      "english": "Stormy",
      "uzbek": "Bo‘ronli",
      "phonetic": "/ˈstɔː.mi/",
      "example": "The weather turned stormy.",
      "imageUrl": "",
      "unitId": "unit_weather",
      "description": "With strong wind and rain."
    },
    {
      "id": "weather_humid",
      "english": "Humid",
      "uzbek": "Namgarchilik",
      "phonetic": "/ˈhjuː.mɪd/",
      "example": "It feels very humid today.",
      "imageUrl": "",
      "unitId": "unit_weather",
      "description": "Warm and damp air."
    },

    /* ---------------------------------------------------------
      SCHOOL (20+)
  --------------------------------------------------------- */

    {
      "id": "school_pen",
      "english": "Pen",
      "uzbek": "Ruchka",
      "phonetic": "/pen/",
      "example": "She wrote with a pen.",
      "imageUrl": "",
      "unitId": "unit_school",
      "description": "A writing tool containing ink."
    },
    {
      "id": "school_pencil",
      "english": "Pencil",
      "uzbek": "Qalam",
      "phonetic": "/ˈpen.səl/",
      "example": "He sharpened his pencil.",
      "imageUrl": "",
      "unitId": "unit_school",
      "description": "A writing tool with lead."
    },
    {
      "id": "school_notebook",
      "english": "Notebook",
      "uzbek": "Daftar",
      "phonetic": "/ˈnəʊt.bʊk/",
      "example": "The notes are in my notebook.",
      "imageUrl": "",
      "unitId": "unit_school",
      "description": "A book for writing."
    },
    {
      "id": "school_book",
      "english": "Book",
      "uzbek": "Kitob",
      "phonetic": "/bʊk/",
      "example": "She borrowed a book.",
      "imageUrl": "",
      "unitId": "unit_school",
      "description": "A written work."
    },
    {
      "id": "school_marker",
      "english": "Marker",
      "uzbek": "Marker",
      "phonetic": "/ˈmɑː.kər/",
      "example": "The marker is dry.",
      "imageUrl": "",
      "unitId": "unit_school",
      "description": "A thick pen."
    },
    {
      "id": "school_bag",
      "english": "School Bag",
      "uzbek": "Maktab sumkasi",
      "phonetic": "/skuːl bæɡ/",
      "example": "He carried his bag to school.",
      "imageUrl": "",
      "unitId": "unit_school",
      "description": "A bag for school items."
    },
    {
      "id": "school_desk",
      "english": "Desk",
      "uzbek": "Parta",
      "phonetic": "/desk/",
      "example": "Students sat at their desks.",
      "imageUrl": "",
      "unitId": "unit_school",
      "description": "A table used for study."
    },
    {
      "id": "school_board",
      "english": "Board",
      "uzbek": "Doska",
      "phonetic": "/bɔːd/",
      "example": "She wrote on the board.",
      "imageUrl": "",
      "unitId": "unit_school",
      "description": "A large writing surface."
    },
    {
      "id": "school_teacher",
      "english": "Teacher",
      "uzbek": "O‘qituvchi",
      "phonetic": "/ˈtiː.tʃər/",
      "example": "The teacher explained the lesson.",
      "imageUrl": "",
      "unitId": "unit_school",
      "description": "A person who teaches students."
    },

    /* ---------------------------------------------------------
      TECHNOLOGY (25+)
  --------------------------------------------------------- */

    {
      "id": "tech_phone",
      "english": "Phone",
      "uzbek": "Telefon",
      "phonetic": "/fəʊn/",
      "example": "He answered the phone.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A device for communication."
    },
    {
      "id": "tech_smartphone",
      "english": "Smartphone",
      "uzbek": "Smartfon",
      "phonetic": "/ˈsmɑːt.fəʊn/",
      "example": "Her smartphone battery died.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "An advanced mobile phone."
    },
    {
      "id": "tech_laptop",
      "english": "Laptop",
      "uzbek": "Noutbuk",
      "phonetic": "/ˈlæp.tɒp/",
      "example": "He used his laptop for work.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A portable computer."
    },
    {
      "id": "tech_mouse",
      "english": "Mouse",
      "uzbek": "Sichqoncha",
      "phonetic": "/maʊs/",
      "example": "He clicked the mouse.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A device for cursor control."
    },
    {
      "id": "tech_keyboard",
      "english": "Keyboard",
      "uzbek": "Klaviatura",
      "phonetic": "/ˈkiː.bɔːd/",
      "example": "The keyboard is wireless.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A device for typing."
    },
    {
      "id": "tech_monitor",
      "english": "Monitor",
      "uzbek": "Monitor",
      "phonetic": "/ˈmɒn.ɪ.tər/",
      "example": "The monitor display is clear.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A screen for displaying data."
    },
    {
      "id": "tech_headphones",
      "english": "Headphones",
      "uzbek": "Naushnik",
      "phonetic": "/ˈhed.fəʊnz/",
      "example": "She listened with headphones.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A device for listening to audio."
    },
    {
      "id": "tech_speaker",
      "english": "Speaker",
      "uzbek": "Karnay",
      "phonetic": "/ˈspiː.kər/",
      "example": "The speaker is loud.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A device for sound output."
    },
    {
      "id": "tech_camera",
      "english": "Camera",
      "uzbek": "Kamera",
      "phonetic": "/ˈkæm.rə/",
      "example": "He bought a new camera.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A device for taking photos or videos."
    },
    {
      "id": "tech_printer",
      "english": "Printer",
      "uzbek": "Printer",
      "phonetic": "/ˈprɪn.tər/",
      "example": "The printer ran out of ink.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A machine that prints documents."
    },
    {
      "id": "tech_router",
      "english": "Router",
      "uzbek": "Router",
      "phonetic": "/ˈruː.tər/",
      "example": "The router stopped working.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A device that provides Wi-Fi."
    },
    {
      "id": "tech_powerbank",
      "english": "Power Bank",
      "uzbek": "Pauerbank",
      "phonetic": "/ˈpaʊər bæŋk/",
      "example": "He charged his phone with a power bank.",
      "imageUrl": "",
      "unitId": "unit_technology",
      "description": "A portable charger for electronic devices."
    }
  ];

  /// Upload global units to Firestore
  Future<void> uploadGlobalUnits() async {
    try {
      final unitsJson = <Map<String, dynamic>>[
        {
          "id": "unit_daily_routine",
          "name": "Daily Routine",
          "icon": "⏰",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_family",
          "name": "Family",
          "icon": "👨‍👩‍👧‍👦",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_numbers",
          "name": "Numbers",
          "icon": "🔢",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_time_date",
          "name": "Time & Date",
          "icon": "🕒",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_emotions",
          "name": "Emotions",
          "icon": "😊",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_sports",
          "name": "Sports",
          "icon": "⚽",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_hobbies",
          "name": "Hobbies",
          "icon": "🎮",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_places_in_town",
          "name": "Places in Town",
          "icon": "🏙️",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_countries_nationalities",
          "name": "Countries & Nationalities",
          "icon": "🌍",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_health",
          "name": "Health",
          "icon": "🩺",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_shopping",
          "name": "Shopping",
          "icon": "🛍️",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_travel",
          "name": "Travel",
          "icon": "✈️",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_nature",
          "name": "Nature",
          "icon": "🌳",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_basic_adjectives",
          "name": "Basic Adjectives",
          "icon": "⭐",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_common_phrases",
          "name": "Common Phrases",
          "icon": "💬",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_prepositions",
          "name": "Prepositions",
          "icon": "📍",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        }
      ];
      if (kDebugMode) {
        print('Starting to upload ${unitsJson.length} global units...');
      }

      int successCount = 0;
      int errorCount = 0;

      for (final unit in unitsJson) {
        try {
          await _firestore
              .collection(_unitsCollection)
              .doc(unit["id"] as String)
              .set(unit);

          successCount++;

          if (kDebugMode) {
            print('✓ Uploaded: ${unit["name"]} (${unit["id"]})');
          }
        } catch (e) {
          errorCount++;
          if (kDebugMode) {
            print('✗ Failed to upload ${unit["name"]}: $e');
          }
        }
      }

      if (kDebugMode) {
        print('Upload complete! Success: $successCount, Errors: $errorCount');
      }

      if (errorCount > 0) {
        throw Exception('Failed to upload $errorCount unit(s)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading global units: $e');
      }
      rethrow;
    }
  }

  /// Upload words to Firestore
  Future<void> uploadWords(List<Map<String, dynamic>> words) async {
    try {
      if (kDebugMode) {
        print('Starting to upload ${words.length} words...');
      }

      int successCount = 0;
      int errorCount = 0;

      for (final word in words) {
        try {
          final docId = word["id"] as String;

          await _firestore.collection(_wordsCollection).doc(docId).set({
            "id": word["id"],
            "english": word["english"],
            "uzbek": word["uzbek"],
            "phonetic": word["phonetic"],
            "example": word["example"],
            "imageUrl": word["imageUrl"] ?? "",
            "unitId": word["unitId"],
            "description": word["description"],
            "createdAt": FieldValue.serverTimestamp(),
          });

          successCount++;

          if (kDebugMode) {
            print('✓ Uploaded word: $docId');
          }
        } catch (e) {
          errorCount++;
          if (kDebugMode) {
            print('✗ Failed to upload word ${word["id"]}: $e');
          }
        }
      }

      if (kDebugMode) {
        print(
            'Words upload complete! Success: $successCount, Errors: $errorCount');
      }

      if (errorCount > 0) {
        throw Exception('Failed to upload $errorCount word(s)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading words: $e');
      }
      rethrow;
    }
  }

  /// Update word counts for all global units based on actual words in Firebase
  Future<void> updateGlobalUnitsWordCounts() async {
    try {
      if (kDebugMode) {
        print('Starting to update word counts for all global units...');
      }

      // Get all global units
      final unitsQuery = await _firestore
          .collection(_unitsCollection)
          .where('isGlobal', isEqualTo: true)
          .get();

      int successCount = 0;
      int errorCount = 0;

      for (final unitDoc in unitsQuery.docs) {
        try {
          final unitId = unitDoc.id;

          // Count words for this unit
          final wordsQuery = await _firestore
              .collection(_wordsCollection)
              .where('unitId', isEqualTo: unitId)
              .get();

          final wordCount = wordsQuery.docs.length;

          // Update unit's wordCount in Firebase
          await _firestore.collection(_unitsCollection).doc(unitId).update({
            'wordCount': wordCount,
          });

          successCount++;

          if (kDebugMode) {
            print(
                '✓ Updated wordCount for ${unitDoc.data()['name']} (${unitDoc.id}): $wordCount words');
          }
        } catch (e) {
          errorCount++;
          if (kDebugMode) {
            print('✗ Failed to update wordCount for unit ${unitDoc.id}: $e');
          }
        }
      }

      if (kDebugMode) {
        print(
            'Word count update complete! Success: $successCount, Errors: $errorCount');
      }

      if (errorCount > 0) {
        throw Exception('Failed to update word counts for $errorCount unit(s)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating word counts: $e');
      }
      rethrow;
    }
  }

  /// Update images for all words in a unit
  /// Fetches 5 images from Pexels for each word and randomly selects one
  Future<void> updateUnitWordsImages(String unitId) async {
    try {
      if (kDebugMode) {
        print('Starting to update images for unit: $unitId');
      }

      // Get all words for this unit from Firebase
      final wordsQuery = await _firestore
          .collection(_wordsCollection)
          .where('unitId', isEqualTo: unitId)
          .get();

      if (wordsQuery.docs.isEmpty) {
        if (kDebugMode) {
          print('No words found for unit: $unitId');
        }
        return;
      }

      int successCount = 0;
      int errorCount = 0;
      final random = Random();

      // Process each word
      for (final wordDoc in wordsQuery.docs) {
        try {
          final wordData = wordDoc.data();
          final englishWord = wordData['english'] as String?;

          if (englishWord == null || englishWord.isEmpty) {
            if (kDebugMode) {
              print('Skipping word ${wordDoc.id}: no English word found');
            }
            continue;
          }

          // Fetch images from Pexels
          if (kDebugMode) {
            print('Fetching images for word: $englishWord');
          }

          final images = await _pexelsDataSource.searchImages(englishWord);

          if (images.isEmpty) {
            if (kDebugMode) {
              print('No images found for word: $englishWord');
            }
            errorCount++;
            continue;
          }

          // Take first 5 images (or all if less than 5)
          final imagesToChoose = images.take(5).toList();

          // Randomly select one image
          final selectedImageUrl =
              imagesToChoose[random.nextInt(imagesToChoose.length)];

          // Update word in Firebase
          await _firestore.collection(_wordsCollection).doc(wordDoc.id).update({
            'imageUrl': selectedImageUrl,
          });

          successCount++;

          if (kDebugMode) {
            print(
                '✓ Updated image for word: $englishWord -> $selectedImageUrl');
          }

          // Add a small delay to avoid rate limiting
          await Future.delayed(const Duration(milliseconds: 200));
        } catch (e) {
          errorCount++;
          if (kDebugMode) {
            print('✗ Failed to update image for word ${wordDoc.id}: $e');
          }
        }
      }

      if (kDebugMode) {
        print(
            'Image update complete for unit $unitId! Success: $successCount, Errors: $errorCount');
      }

      if (errorCount > 0 && successCount == 0) {
        throw Exception('Failed to update images for all words');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating unit words images: $e');
      }
      rethrow;
    }
  }
}
