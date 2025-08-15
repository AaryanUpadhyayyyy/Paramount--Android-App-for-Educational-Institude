class CloudinaryConfig {
  // Cloudinary account configuration
  static const String cloudName = 'drco787o5'; // Your actual Cloud Name
  static const String apiKey = 'wQb0vqQr_1YNJH-KQD7qP75maQM'; // Your actual API key
  static const String apiSecret = 'YOUR_CLOUDINARY_API_SECRET'; // Optional for client-side operations
  static const String uploadPreset = 'paramount_profile_images'; // Your existing upload preset
  
  // Base URL for Cloudinary
  static const String baseUrl = 'https://res.cloudinary.com';
  static const String apiUrl = 'https://api.cloudinary.com/v1_1';
  
  // Folder structure for organizing uploads
  static const String profileImagesFolder = 'paramount/profile_images';
  static const String documentsFolder = 'paramount/documents';
  static const String attendanceSheetsFolder = 'paramount/attendance_sheets';
  static const String studentDocumentsFolder = 'paramount/student_documents';
  static const String facultyDocumentsFolder = 'paramount/faculty_documents';
  
  // Upload presets for different types of content
  static const String profileImagePreset = 'paramount_profile_images';
  static const String documentPreset = 'paramount_documents';
  static const String attendanceSheetPreset = 'paramount_attendance_sheets';
  
  // Image transformation settings
  static const Map<String, String> profileImageTransformations = {
    'width': '300',
    'height': '300',
    'crop': 'fill',
    'gravity': 'face',
    'quality': 'auto',
    'format': 'auto',
  };
  
  static const Map<String, String> thumbnailTransformations = {
    'width': '150',
    'height': '150',
    'crop': 'fill',
    'gravity': 'face',
    'quality': 'auto',
    'format': 'auto',
  };
  
  // File size limits (in bytes)
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxDocumentSize = 25 * 1024 * 1024; // 25MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  
  // Allowed file types
  static const List<String> allowedImageTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'tiff'
  ];
  
  static const List<String> allowedDocumentTypes = [
    'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'
  ];
  
  static const List<String> allowedVideoTypes = [
    'mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'
  ];
  
  // Quality settings
  static const String defaultImageQuality = 'auto:good';
  static const String highQualityImage = 'auto:best';
  static const String lowQualityImage = 'auto:eco';
  
  // Format optimization
  static const bool autoFormat = true;
  static const bool progressiveJpeg = true;
  static const bool stripMetadata = true;
  
  // Security settings
  static const bool useSignedUploads = false; // Set to true for secure uploads
  static const int uploadExpiration = 3600; // 1 hour in seconds
  
  // CDN settings
  static const bool useCDN = true;
  static const String cdnDomain = 'res.cloudinary.com';
  
  // Backup and versioning
  static const bool enableVersioning = true;
  static const bool keepOriginal = true;
  
  // Analytics and monitoring
  static const bool enableAnalytics = true;
  static const bool enableUsageTracking = true;
  
  // Rate limiting
  static const int maxUploadsPerHour = 1000;
  static const int maxUploadsPerDay = 10000;
  
  // Error handling
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // milliseconds
  
  // Cache settings
  static const int cacheExpiration = 31536000; // 1 year in seconds
  static const bool enableCache = true;
  
  // Watermark settings (optional)
  static const bool enableWatermark = false;
  static const String watermarkText = 'Paramount Classes';
  static const Map<String, dynamic> watermarkSettings = {
    'text': 'Paramount Classes',
    'font_family': 'Arial',
    'font_size': 20,
    'font_weight': 'bold',
    'color': 'white',
    'opacity': 0.7,
    'position': 'bottom_right',
  };
  
  // Get upload URL for specific folder
  static String getUploadUrl(String folder) {
    return '$apiUrl/$cloudName/$folder';
  }
  
  // Get resource URL
  static String getResourceUrl(String publicId, {Map<String, String>? transformations}) {
    String baseResourceUrl = '$baseUrl/$cloudName/image/upload';
    
    if (transformations != null && transformations.isNotEmpty) {
      String transformationString = transformations.entries
          .map((e) => '${e.key}_${e.value}')
          .join(',');
      return '$baseResourceUrl/$transformationString/$publicId';
    }
    
    return '$baseResourceUrl/$publicId';
  }
  
  // Get thumbnail URL
  static String getThumbnailUrl(String publicId) {
    String transformationString = thumbnailTransformations.entries
        .map((e) => '${e.key}_${e.value}')
        .join(',');
    return '$baseUrl/$cloudName/image/upload/$transformationString/$publicId';
  }
  
  // Get profile image URL
  static String getProfileImageUrl(String publicId) {
    String transformationString = profileImageTransformations.entries
        .map((e) => '${e.key}_${e.value}')
        .join(',');
    return '$baseUrl/$cloudName/image/upload/$transformationString/$publicId';
  }
  
  // Validate file type
  static bool isValidFileType(String fileName, List<String> allowedTypes) {
    String extension = fileName.split('.').last.toLowerCase();
    return allowedTypes.contains(extension);
  }
  
  // Validate file size
  static bool isValidFileSize(int fileSize, int maxSize) {
    return fileSize <= maxSize;
  }
  
  // Generate unique file name
  static String generateFileName(String originalName, String folder) {
    String extension = originalName.split('.').last;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String randomId = (1000 + DateTime.now().millisecond).toString();
    return '$folder/$timestamp$randomId.$extension';
  }
  
  // Get folder path for different content types
  static String getFolderPath(String contentType, {String? userId, String? additionalPath}) {
    switch (contentType.toLowerCase()) {
      case 'profile_image':
        return userId != null ? '$profileImagesFolder/$userId' : profileImagesFolder;
      case 'document':
        return userId != null ? '$documentsFolder/$userId' : documentsFolder;
      case 'attendance_sheet':
        return attendanceSheetsFolder;
      case 'student_document':
        return userId != null ? '$studentDocumentsFolder/$userId' : studentDocumentsFolder;
      case 'faculty_document':
        return userId != null ? '$facultyDocumentsFolder/$userId' : facultyDocumentsFolder;
      default:
        return additionalPath ?? 'paramount/misc';
    }
  }
}
