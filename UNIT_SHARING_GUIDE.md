# Unit Sharing Guide - usersId Array

Bu qo'llanma Unit'ni bir nechta foydalanuvchilar bilan share qilish funksiyasini tushuntiradi.

## O'zgarishlar

### 1. UnitFirestoreModel yangilandi

- `userId` (String) → `usersId` (List<String>) ga o'zgartirildi
- Unit yaratilganda joriy foydalanuvchi ID'si `usersId` array'iga qo'shiladi
- Kelajakda boshqa foydalanuvchilar ham qo'shilishi mumkin

### 2. Query yangilandi

**Eski query:**
```dart
.where('userId', isEqualTo: userId)
```

**Yangi query:**
```dart
.where('usersId', arrayContains: userId)
```

Bu query `usersId` array'ida joriy foydalanuvchi ID'si bo'lgan barcha unitlarni qaytaradi.

### 3. Firestore Rules yangilandi

- `usersId` array bilan ishlash uchun yangilandi
- Eski format (`userId`) ham qo'llab-quvvatlanadi (migration uchun)
- Foydalanuvchi `usersId` array'ida bo'lsa, unit'ga kirish huquqiga ega

### 4. Index yangilandi

- `usersId` uchun `arrayContains` index yaratildi
- Query tezroq ishlashi uchun

## Qanday ishlaydi?

### Unit yaratish

Unit yaratilganda:
- `usersId` array'iga joriy foydalanuvchi ID'si avtomatik qo'shiladi
- `isGlobal = false` bo'ladi
- `createdAt` serverTimestamp bilan belgilanadi

```dart
// Unit yaratish
final unit = await unitRepository.createUnit(
  title: 'My Unit',
  icon: '📚',
);
// usersId: [currentUserId] - avtomatik qo'shiladi
```

### Unit share qilish

Boshqa foydalanuvchilarni qo'shish:

```dart
// Unit'ni olish
final unit = await unitRepository.getUnit(unitId);

// Yangi foydalanuvchini qo'shish
final sharedUnit = unit.addUser(otherUserId);

// Yangilash
await unitRepository.updateUnit(sharedUnit);
```

### Unit'dan foydalanuvchini olib tashlash

```dart
// Foydalanuvchini olib tashlash
final updatedUnit = unit.removeUser(userIdToRemove);

// Yangilash
await unitRepository.updateUnit(updatedUnit);
```

### My Units'da ko'rinishi

Unit "My Units"da ko'rinadi agar:
- `usersId` array'ida joriy foydalanuvchi ID'si bo'lsa
- VA `isGlobal == false` bo'lsa

## Helper metodlar

`UnitFirestoreModel` da quyidagi helper metodlar mavjud:

- `addUser(String userId)` - Foydalanuvchini qo'shish
- `removeUser(String userId)` - Foydalanuvchini olib tashlash
- `hasUser(String userId)` - Foydalanuvchi bor-yo'qligini tekshirish

## Migration (Eski ma'lumotlar)

Eski `userId` (String) formatidagi unitlar avtomatik ravishda `usersId` (List) formatiga konvertatsiya qilinadi:

```dart
// Eski format
userId: "user123"

// Yangi format
usersId: ["user123"]
```

## Security Rules

Firestore rules'da:
- Read: `usersId` array'ida foydalanuvchi ID'si bo'lsa yoki `isGlobal == true` bo'lsa
- Create: `usersId` array'iga joriy foydalanuvchi ID'si qo'shilishi kerak
- Update: `usersId` array'ida foydalanuvchi ID'si bo'lishi kerak
- Delete: `usersId` array'ida foydalanuvchi ID'si bo'lishi kerak

## Index deploy qilish

Yangi index'ni deploy qilish:

```bash
firebase deploy --only firestore:indexes
```

Yoki Firebase Console orqali:
1. Firestore Database → Indexes
2. Yangi index yaratilguncha kutish

## Example kod

Batafsil misollar uchun `lib/src/data/repositories/unit_share_example.dart` faylini ko'ring.

## Muhim eslatmalar

1. **Index kerak** - `usersId` arrayContains query uchun index yaratilishi kerak
2. **Backward compatibility** - Eski `userId` format ham qo'llab-quvvatlanadi
3. **Share funksiyasi** - Kelajakda unit'ni boshqa foydalanuvchilar bilan share qilish mumkin

