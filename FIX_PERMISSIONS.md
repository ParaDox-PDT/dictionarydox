# Firestore Permissions Fix

## Muammo

1. **Global units o'qilmayapti**: `[cloud_firestore/permission-denied] Missing or insufficient permissions.`
2. **User units ko'rinmayapti**: "Fetched 0 user units"

## Yechim

### 1. Firestore Rules yangilandi

Global units uchun read permission qo'shildi:

```javascript
allow read: if isAuthenticated() && (
   // Global units: anyone can read
   resource.data.isGlobal == true ||
   // User-specific units: must be in usersId array
   (resource.data.isGlobal == false &&
    (request.auth.uid in resource.data.get('usersId', []) ||
     resource.data.get('userId', '') == request.auth.uid))
);
```

### 2. Index deploy qilish

`usersId` arrayContains query uchun index yaratilishi kerak:

```bash
firebase deploy --only firestore:indexes
```

Yoki Firebase Console orqali:
1. Firebase Console → Firestore Database → Indexes
2. Yangi index yaratilguncha kutish (2-5 daqiqa)

### 3. Rules deploy qilish

```bash
firebase deploy --only firestore:rules
```

## Test qilish

1. **Rules deploy qiling**:
   ```bash
   firebase deploy --only firestore:rules
   ```

2. **Index deploy qiling**:
   ```bash
   firebase deploy --only firestore:indexes
   ```

3. **Ilovani qayta ishga tushiring**

4. **Tekshiring**:
   - Global units ko'rinishi kerak
   - User units ko'rinishi kerak (agar mavjud bo'lsa)

## Muammo hal qilinmagan bo'lsa

1. Firebase Console'da Firestore Database → Rules'ni tekshiring
2. Indexlar yaratilganligini tekshiring (Status: "Enabled")
3. Browser console'da boshqa xatolarni tekshiring

