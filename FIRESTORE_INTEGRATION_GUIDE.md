# Firestore Integration Guide - Unit Creation

Bu qo'llanma Unit qo'shish funksiyasining Firestore bilan qanday integratsiya qilinganini tushuntiradi.

## O'zgarishlar

### 1. UnitRepositoryImpl yangilandi

`lib/src/data/repositories/unit_repository_impl.dart` fayli yangilandi va endi:
- **Firestore bilan ishlaydi** - Agar foydalanuvchi autentifikatsiya qilingan bo'lsa, unitlar Firestore'ga saqlanadi
- **Local storage fallback** - Agar Firestore ishlamasa yoki foydalanuvchi autentifikatsiya qilinmagan bo'lsa, local storage ishlatiladi
- **Ikki tomonlama konvertatsiya** - Domain entity (`name`) va Firestore model (`title`) o'rtasida avtomatik konvertatsiya

### 2. Injector Container yangilandi

`lib/src/injector_container.dart` fayliga qo'shildi:
- `UnitFirestoreRepository` - Firestore repository
- `AuthService` - Autentifikatsiya xizmati

### 3. Qanday ishlaydi?

#### Unit yaratish jarayoni:

1. **Foydalanuvchi unit yaratadi** (CreateUnitPage orqali)
2. **UnitBloc** `CreateUnitEvent` ni qayta ishlaydi
3. **CreateUnit use case** `UnitRepository.createUnit()` ni chaqiradi
4. **UnitRepositoryImpl** quyidagilarni tekshiradi:
   - Agar foydalanuvchi autentifikatsiya qilingan bo'lsa:
     - Firestore'ga saqlashga harakat qiladi
     - Muvaffaqiyatli bo'lsa, Firestore'ga saqlanadi
     - Xatolik bo'lsa, local storage'ga saqlanadi (fallback)
   - Agar autentifikatsiya qilinmagan bo'lsa:
     - Faqat local storage'ga saqlanadi

#### Unitlarni olish jarayoni:

1. **UnitBloc** `LoadUnitsEvent` ni qayta ishlaydi
2. **GetAllUnits use case** `UnitRepository.getAllUnits()` ni chaqiradi
3. **UnitRepositoryImpl**:
   - Agar foydalanuvchi autentifikatsiya qilingan bo'lsa:
     - Firestore'dan foydalanuvchining unitlarini oladi
     - Local storage'dan ham oladi (offline support uchun)
   - Agar autentifikatsiya qilinmagan bo'lsa:
     - Faqat local storage'dan oladi

## Field Mapping

| Domain Entity | Firestore Model | Izoh |
|--------------|-----------------|------|
| `name` | `title` | Avtomatik konvertatsiya |
| `id` | `id` | Bir xil |
| `isGlobal` | `isGlobal` | Bir xil (default: false) |
| `icon` | - | Firestore modelida yo'q, null qilinadi |
| `wordCount` | - | Hisoblanadi (local storage yoki Firestore'dan) |

## Xatoliklar bilan ishlash

- **Firestore xatosi**: Avtomatik ravishda local storage'ga fallback qiladi
- **Autentifikatsiya yo'q**: Local storage'ga saqlanadi
- **Network xatosi**: Local storage'dan o'qiladi

## Test qilish

1. **Foydalanuvchi sifatida kirish** (Google Sign-In)
2. **Unit yaratish** - Create Unit tugmasini bosing
3. **Unit nomini kiriting** va yarating
4. **Firebase Console'da tekshiring**:
   - Firestore Database → `units` collection
   - Yangi unit yaratilgan bo'lishi kerak
   - `userId` joriy foydalanuvchi ID'siga teng bo'lishi kerak
   - `isGlobal` = false bo'lishi kerak

## Muhim eslatmalar

1. **Autentifikatsiya talab qilinadi** - Firestore'ga saqlash uchun foydalanuvchi autentifikatsiya qilingan bo'lishi kerak
2. **Icon maydoni** - Firestore modelida icon maydoni yo'q, shuning uchun Firestore unitlarida icon null bo'ladi
3. **Offline support** - Local storage fallback tufayli offline rejimda ham ishlaydi
4. **Security Rules** - `firestore.rules` faylida xavfsizlik qoidalari sozlangan

## Keyingi qadamlar

Agar muammo bo'lsa:
1. Firebase Console'da Firestore Database'ni tekshiring
2. Browser console'da xatolarni ko'ring
3. `firestore.rules` faylini deploy qiling: `firebase deploy --only firestore:rules`

