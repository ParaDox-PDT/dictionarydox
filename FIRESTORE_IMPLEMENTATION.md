# Firestore Implementation for User-Specific Units and Words

This document describes the implementation of user-specific Units and Words in Firestore for the dictionary app.

## Overview

The implementation provides:
- **Firestore Models**: `UnitFirestoreModel` and `WordFirestoreModel` with all required fields
- **Repository Layer**: `UnitFirestoreRepository` and `WordFirestoreRepository` with full CRUD operations
- **Security Rules**: Firestore rules ensuring users can only access their own data
- **Example Usage**: Complete examples demonstrating how to use the repositories

## Models

### UnitFirestoreModel

Located at: `lib/src/data/models/unit_firestore_model.dart`

**Fields:**
- `id` (String) - Document ID
- `title` (String) - Unit title
- `createdAt` (Timestamp) - Creation timestamp (serverTimestamp)
- `isGlobal` (bool) - Default: false
- `userId` (String) - Owner's user ID

**Methods:**
- `fromFirestore()` - Create from Firestore document
- `fromJson()` - Create from JSON
- `toFirestore()` - Convert to Firestore document data
- `toJson()` - Convert to JSON
- `copyWith()` - Create a copy with updated fields

### WordFirestoreModel

Located at: `lib/src/data/models/word_firestore_model.dart`

**Fields:**
- `id` (String) - Document ID
- `english` (String) - English word
- `uzbek` (String) - Uzbek translation
- `phonetic` (String?) - Optional phonetic spelling
- `audioUrl` (String?) - Optional audio URL
- `example` (String?) - Optional example sentence
- `imageUrl` (String?) - Optional image URL
- `description` (String?) - Optional description
- `unitId` (String) - Parent unit ID
- `isGlobal` (bool) - Default: false
- `userId` (String) - Owner's user ID
- `createdAt` (Timestamp) - Creation timestamp (serverTimestamp)

**Methods:**
- `fromFirestore()` - Create from Firestore document
- `fromJson()` - Create from JSON
- `toFirestore()` - Convert to Firestore document data
- `toJson()` - Convert to JSON
- `copyWith()` - Create a copy with updated fields

## Repositories

### UnitFirestoreRepository

Located at: `lib/src/data/repositories/unit_firestore_repository.dart`

**Methods:**
- `createUnit({required String title, String? id})` - Create a new unit
- `updateUnit(UnitFirestoreModel unit)` - Update an existing unit
- `deleteUnit(String unitId)` - Delete a unit
- `getUnit(String unitId)` - Get a single unit by ID
- `getUserUnits()` - Get all units for the current user
- `getUserUnitsStream()` - Stream of user units (real-time updates)

**Features:**
- Automatically sets `userId` from current authenticated user
- Automatically sets `isGlobal = false`
- Uses `serverTimestamp` for `createdAt`
- Verifies ownership before update/delete operations

### WordFirestoreRepository

Located at: `lib/src/data/repositories/word_firestore_repository.dart`

**Methods:**
- `createWord({required String english, required String uzbek, required String unitId, ...})` - Create a new word
- `updateWord(WordFirestoreModel word)` - Update an existing word
- `deleteWord(String wordId)` - Delete a word
- `getWord(String wordId)` - Get a single word by ID
- `getWordsByUnit(String unitId)` - Get all words for a specific unit
- `getUserWords()` - Get all words for the current user
- `getWordsByUnitStream(String unitId)` - Stream of words for a unit (real-time updates)
- `getUserWordsStream()` - Stream of all user words (real-time updates)

**Features:**
- Automatically sets `userId` from current authenticated user
- Automatically sets `isGlobal = false`
- Uses `serverTimestamp` for `createdAt`
- Verifies ownership before update/delete operations

## Security Rules

Located at: `firestore.rules`

### Units Collection

**Read:**
- User can read if: `userId == request.auth.uid` AND `isGlobal == false`

**Create:**
- User can create if authenticated
- Must set `userId == request.auth.uid`
- Must set `isGlobal == false`
- Must include `title` (string) and `createdAt` (timestamp)

**Update:**
- User can update if they own it AND `isGlobal == false`
- Cannot change `userId` or `isGlobal` to different values

**Delete:**
- User can delete if they own it AND `isGlobal == false`

### Words Collection

**Read:**
- User can read if: `userId == request.auth.uid` AND `isGlobal == false`

**Create:**
- User can create if authenticated
- Must set `userId == request.auth.uid`
- Must set `isGlobal == false`
- Must include `english`, `uzbek`, `unitId` (strings) and `createdAt` (timestamp)

**Update:**
- User can update if they own it AND `isGlobal == false`
- Cannot change `userId` or `isGlobal` to different values

**Delete:**
- User can delete if they own it AND `isGlobal == false`

## Usage Examples

See `lib/src/data/repositories/firestore_usage_example.dart` for complete examples.

### Quick Start

```dart
import 'package:dictionarydox/src/data/repositories/unit_firestore_repository.dart';
import 'package:dictionarydox/src/data/repositories/word_firestore_repository.dart';

// Initialize repositories
final unitRepo = UnitFirestoreRepository();
final wordRepo = WordFirestoreRepository();

// Create a unit
final unit = await unitRepo.createUnit(title: 'My Unit');

// Create a word
final word = await wordRepo.createWord(
  english: 'Hello',
  uzbek: 'Salom',
  unitId: unit.id,
);

// Get user's units
final units = await unitRepo.getUserUnits();

// Get words in a unit
final words = await wordRepo.getWordsByUnit(unit.id);

// Use streams for real-time updates
unitRepo.getUserUnitsStream().listen((units) {
  print('Units updated: ${units.length}');
});
```

## Querying User-Specific Data

### Get Only Current User's Units

```dart
final units = await unitRepo.getUserUnits();
```

This automatically filters by:
- `userId == currentUser.uid`
- `isGlobal == false`

### Get Only Current User's Words

```dart
// All user's words
final words = await wordRepo.getUserWords();

// Words in a specific unit
final words = await wordRepo.getWordsByUnit(unitId);
```

Both queries automatically filter by:
- `userId == currentUser.uid`
- `isGlobal == false`

## Important Notes

1. **Authentication Required**: All operations require an authenticated user. The repositories check for authentication and throw exceptions if the user is not signed in.

2. **Automatic Field Setting**: When creating Units or Words:
   - `userId` is automatically set from `AuthService.currentUser.uid`
   - `isGlobal` is automatically set to `false`
   - `createdAt` is automatically set to `serverTimestamp`

3. **Ownership Verification**: Update and delete operations verify that the user owns the document before proceeding.

4. **Security Rules**: The Firestore security rules enforce the same restrictions at the database level, providing defense in depth.

5. **Real-time Updates**: Use the stream methods (`getUserUnitsStream()`, `getWordsByUnitStream()`, etc.) to get real-time updates when data changes.

## Deploying Security Rules

To deploy the Firestore security rules:

```bash
firebase deploy --only firestore:rules
```

Or if using Firebase CLI:

```bash
firebase deploy --only firestore
```

## Testing

Before deploying to production, test the security rules using the Firebase Emulator Suite or by testing with different user accounts.

## Collections Structure

### Units Collection (`units`)

```
units/
  {unitId}/
    - id: String
    - title: String
    - createdAt: Timestamp
    - isGlobal: Boolean (false)
    - userId: String
```

### Words Collection (`words`)

```
words/
  {wordId}/
    - id: String
    - english: String
    - uzbek: String
    - phonetic: String? (optional)
    - audioUrl: String? (optional)
    - example: String? (optional)
    - imageUrl: String? (optional)
    - description: String? (optional)
    - unitId: String
    - isGlobal: Boolean (false)
    - userId: String
    - createdAt: Timestamp
```

