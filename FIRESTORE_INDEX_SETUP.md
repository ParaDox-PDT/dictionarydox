# Firestore Index Setup Guide

Firestore query'lari uchun composite indexlar kerak. Quyidagi qadamlarni bajaring:

## Tez yechim

### 1-usul: Firebase Console orqali (Eng oson)

1. Xatolik xabaridagi linkni oching (browser'da):
   ```
   https://console.firebase.google.com/v1/r/project/dictionarydox/firestore/indexes?create_composite=...
   ```

2. Yoki Firebase Console'ga kiring:
   - https://console.firebase.google.com/
   - Project: `dictionarydox` ni tanlang
   - Firestore Database → Indexes bo'limiga o'ting
   - "Create Index" tugmasini bosing

3. Index yaratilguncha kutish (bir necha daqiqa)

### 2-usul: Firebase CLI orqali (Tavsiya etiladi)

1. Firebase CLI o'rnatilganligini tekshiring:
   ```bash
   firebase --version
   ```

2. Agar o'rnatilmagan bo'lsa:
   ```bash
   npm install -g firebase-tools
   ```

3. Firebase'ga login qiling:
   ```bash
   firebase login
   ```

4. Indexlarni deploy qiling:
   ```bash
   firebase deploy --only firestore:indexes
   ```

5. Indexlar yaratilguncha kutish (bir necha daqiqa)

## Indexlar

`firestore.indexes.json` faylida quyidagi indexlar belgilangan:

### 1. Units Collection Index
- **Collection**: `units`
- **Fields**:
  - `userId` (ASCENDING)
  - `isGlobal` (ASCENDING)
  - `createdAt` (DESCENDING)

**Query uchun**: `where('userId').where('isGlobal').orderBy('createdAt')`

### 2. Words Collection Index (unitId bilan)
- **Collection**: `words`
- **Fields**:
  - `unitId` (ASCENDING)
  - `userId` (ASCENDING)
  - `isGlobal` (ASCENDING)
  - `createdAt` (DESCENDING)

**Query uchun**: `where('unitId').where('userId').where('isGlobal').orderBy('createdAt')`

### 3. Words Collection Index (faqat userId bilan)
- **Collection**: `words`
- **Fields**:
  - `userId` (ASCENDING)
  - `isGlobal` (ASCENDING)
  - `createdAt` (DESCENDING)

**Query uchun**: `where('userId').where('isGlobal').orderBy('createdAt')`

## Index holatini tekshirish

Firebase Console'da:
1. Firestore Database → Indexes
2. Indexlar yaratilayotganini ko'rasiz
3. Status "Enabled" bo'lguncha kutish

## Muammo hal qilish

### Index yaratilmayapti
- Firebase Console'da xatolarni tekshiring
- `firestore.indexes.json` faylini to'g'ri ekanligini tekshiring
- Firebase CLI versiyasini yangilang: `npm update -g firebase-tools`

### Query hali ham ishlamayapti
- Index yaratilguncha bir necha daqiqa kutish kerak
- Ilovani qayta ishga tushiring
- Firebase Console'da index status'ini tekshiring

## Keyingi qadamlar

Indexlar yaratilgandan keyin:
1. Ilovani qayta ishga tushiring
2. Unit yaratishni sinab ko'ring
3. Unitlarni olishni sinab ko'ring

Endi barcha query'lar ishlashi kerak!

