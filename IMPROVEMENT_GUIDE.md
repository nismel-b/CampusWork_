# CampusWork - Improvement Implementation Guide

This guide provides step-by-step instructions to implement critical improvements.

---

## 1. SECURITY IMPROVEMENTS

### 1.1 Fix Password Hashing (CRITICAL)

**Current Issue**: Using SHA-256 without salt

**Step 1: Add bcrypt dependency**
```yaml
# pubspec.yaml
dependencies:
  bcrypt: ^1.1.1
```

**Step 2: Update SecurityHelper**
```dart
// lib/utils/security_helper.dart
import 'package:bcrypt/bcrypt.dart';

class SecurityHelper {
  /// Hash password using bcrypt
  static String hashPassword(String password) {
    // Validate password strength first
    if (!isStrongPassword(password)) {
      throw ArgumentError('Password does not meet strength requirements');
    }
    return BCrypt.hashpw(password, BCrypt.gensal