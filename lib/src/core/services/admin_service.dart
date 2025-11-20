import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service for admin operations
class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _unitsCollection = 'units';

  /// Upload global units to Firestore
  Future<void> uploadGlobalUnits() async {
    try {
      final unitsJson = <Map<String, dynamic>>[
        {
          "id": "unit_fruits",
          "name": "Fruits",
          "icon": "🍎",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_vegetables",
          "name": "Vegetables",
          "icon": "🥕",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_animals",
          "name": "Animals",
          "icon": "🐶",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_colors",
          "name": "Colors",
          "icon": "🎨",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_jobs",
          "name": "Jobs",
          "icon": "👨‍🏫",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_transport",
          "name": "Transport",
          "icon": "🚗",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_clothes",
          "name": "Clothes",
          "icon": "👕",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_food",
          "name": "Food",
          "icon": "🍔",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_drinks",
          "name": "Drinks",
          "icon": "🥤",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_body_parts",
          "name": "Body Parts",
          "icon": "🧠",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_house_items",
          "name": "House Items",
          "icon": "🏠",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_weather",
          "name": "Weather",
          "icon": "⛅",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_school",
          "name": "School",
          "icon": "📚",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
        {
          "id": "unit_technology",
          "name": "Technology",
          "icon": "💻",
          "usersId": [],
          "isGlobal": true,
          "wordCount": 0
        },
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
        print(
            'Upload complete! Success: $successCount, Errors: $errorCount');
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
}
