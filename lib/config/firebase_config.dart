class FirebaseConfig {
  // Firebase project configuration
  static const String projectId = 'YOUR-PROJECT-ID';
  static const String apiKey = 'YOUR-API-KEY';
  static const String messagingSenderId = 'YOUR-SENDER-ID';
  static const String appId = 'YOUR-APP-ID';
  
  // Web configuration
  static const String webApiKey = 'YOUR-WEB-API-KEY';
  static const String webAppId = 'YOUR-WEB-APP-ID';
  static const String webAuthDomain = 'YOUR-PROJECT-ID.firebaseapp.com';
  static const String webStorageBucket = 'YOUR-PROJECT-ID.appspot.com';
  static const String webMeasurementId = 'YOUR-MEASUREMENT-ID';
  
  // Android configuration
  static const String androidApiKey = 'YOUR-ANDROID-API-KEY';
  static const String androidAppId = 'YOUR-ANDROID-APP-ID';
  static const String androidStorageBucket = 'YOUR-PROJECT-ID.appspot.com';
  
  // iOS configuration
  static const String iosApiKey = 'YOUR-IOS-API-KEY';
  static const String iosAppId = 'YOUR-IOS-APP-ID';
  static const String iosStorageBucket = 'YOUR-PROJECT-ID.appspot.com';
  static const String iosBundleId = 'com.example.paramount';
  
  // macOS configuration
  static const String macosApiKey = 'YOUR-MACOS-API-KEY';
  static const String macosAppId = 'YOUR-MACOS-APP-ID';
  static const String macosStorageBucket = 'YOUR-PROJECT-ID.appspot.com';
  
  // Windows configuration
  static const String windowsApiKey = 'YOUR-WINDOWS-API-KEY';
  static const String windowsAppId = 'YOUR-WINDOWS-APP-ID';
  static const String windowsStorageBucket = 'YOUR-PROJECT-ID.appspot.com';
  
  // Firestore configuration
  static const String firestoreLocation = 'us-central1';
  static const bool firestoreEnabled = true;
  
  // Storage configuration - Now using Cloudinary instead of Firebase Storage
  static const bool storageEnabled = false; // Disabled - using Cloudinary
  static const String storageLocation = 'N/A'; // Not applicable with Cloudinary
  
  // Authentication configuration
  static const bool authEnabled = true;
  static const List<String> authProviders = ['password', 'google'];
  
  // Analytics configuration
  static const bool analyticsEnabled = true;
  static const String analyticsMeasurementId = 'YOUR-MEASUREMENT-ID';
  
  // Messaging configuration
  static const bool messagingEnabled = true;
  static const String messagingSenderIdValue = 'YOUR-SENDER-ID';
  
  // Security rules
  static const String firestoreRules = '''
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null && resource.data.role == 'admin';
    }
    
    // Students collection
    match /students/{studentId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (request.auth.token.role == 'teacher' || request.auth.token.role == 'admin');
    }
    
    // Faculty collection
    match /faculty/{facultyId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (request.auth.token.role == 'admin' || request.auth.uid == facultyId);
    }
    
    // Attendance collection
    match /attendance/{attendanceId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (request.auth.token.role == 'teacher' || request.auth.token.role == 'admin');
    }
    
    // Classes collection
    match /classes/{classId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (request.auth.token.role == 'teacher' || request.auth.token.role == 'admin');
    }
    
    // Subjects collection
    match /subjects/{subjectId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (request.auth.token.role == 'admin');
    }
  }
}
''';

  // Note: Storage rules are no longer needed as we're using Cloudinary
  // Cloudinary handles its own security and access control
  
  // Environment configuration
  static const String environment = 'development'; // 'development', 'staging', 'production'
  
  // Feature flags
  static const bool enablePushNotifications = true;
  static const bool enableEmailVerification = true;
  static const bool enablePasswordReset = true;
  static const bool enableGoogleSignIn = true;
  static const bool enableFileUpload = true; // Now using Cloudinary
  static const bool enableAnalytics = true;
  
  // Rate limiting
  static const int maxLoginAttempts = 5;
  static const int maxFileUploadSize = 10 * 1024 * 1024; // 10MB (Cloudinary limit)
  static const int maxConcurrentUploads = 3;
  
  // Cache configuration
  static const int cacheExpirationHours = 24;
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  
  // Logging configuration
  static const bool enableLogging = true;
  static const String logLevel = 'info'; // 'debug', 'info', 'warning', 'error'
  
  // Error reporting
  static const bool enableErrorReporting = true;
  static const bool enableCrashlytics = true;
  
  // Performance monitoring
  static const bool enablePerformanceMonitoring = true;
  static const bool enableNetworkMonitoring = true;
  
  // Security configuration
  static const bool enableSecurityRules = true;
  static const bool enableAppCheck = false;
  static const bool enableFirestorePersistence = true;
  
  // Backup configuration
  static const bool enableAutomaticBackup = true;
  static const String backupFrequency = 'daily'; // 'hourly', 'daily', 'weekly'
  static const int backupRetentionDays = 30;
  
  // Monitoring and alerts
  static const bool enableMonitoring = true;
  static const bool enableAlerts = true;
  static const List<String> alertEmails = ['admin@example.com'];
  
  // API limits
  static const int maxReadsPerSecond = 1000;
  static const int maxWritesPerSecond = 500;
  static const int maxDeletesPerSecond = 100;
  
  // Batch operation limits
  static const int maxBatchSize = 500;
  static const int maxTransactionSize = 500;
  
  // Query limits
  static const int maxQueryResults = 1000;
  static const int maxQueryComplexity = 100;
  
  // Index configuration
  static const List<Map<String, dynamic>> requiredIndexes = [
    {
      'collection': 'students',
      'fields': ['className', 'section', 'isActive'],
      'order': ['className', 'section', 'name']
    },
    {
      'collection': 'attendance',
      'fields': ['studentId', 'date'],
      'order': ['studentId', 'date']
    },
    {
      'collection': 'attendance',
      'fields': ['className', 'date'],
      'order': ['className', 'date']
    },
    {
      'collection': 'faculty',
      'fields': ['department', 'isActive'],
      'order': ['department', 'name']
    }
  ];
} 