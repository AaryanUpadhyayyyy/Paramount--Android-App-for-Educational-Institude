import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../config/cloudinary_config.dart';

class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  final ImagePicker _imagePicker = ImagePicker();
  final http.Client _httpClient = http.Client();

  // Upload file using unsigned upload (recommended for client-side)
  Future<Map<String, dynamic>> uploadFile(
    File file, {
    String? folder,
    String? publicId,
    Map<String, String>? transformations,
    Map<String, String>? tags,
  }) async {
    try {
      // Validate file
      if (!await _validateFile(file)) {
        throw Exception('Invalid file type or size');
      }

      // Prepare upload data
      String uploadPreset = CloudinaryConfig.uploadPreset;
      if (uploadPreset.isEmpty) {
        throw Exception('Upload preset not configured');
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${CloudinaryConfig.apiUrl}/${CloudinaryConfig.cloudName}/image/upload'),
      );

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      // Add upload preset
      request.fields['upload_preset'] = uploadPreset;

      // Add folder if specified
      if (folder != null && folder.isNotEmpty) {
        request.fields['folder'] = folder;
      }

      // Add public ID if specified
      if (publicId != null && publicId.isNotEmpty) {
        request.fields['public_id'] = publicId;
      }

      // Add transformations if specified
      if (transformations != null && transformations.isNotEmpty) {
        String transformationString = transformations.entries
            .map((e) => '${e.key}_${e.value}')
            .join(',');
        request.fields['transformation'] = transformationString;
      }

      // Add tags if specified
      if (tags != null && tags.isNotEmpty) {
        request.fields['tags'] = tags.values.join(',');
      }

      // Add other optimization parameters
      request.fields['quality'] = CloudinaryConfig.defaultImageQuality;
      request.fields['format'] = 'auto';
      request.fields['fetch_format'] = 'auto';

      // Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'public_id': jsonResponse['public_id'],
          'url': jsonResponse['secure_url'],
          'width': jsonResponse['width'],
          'height': jsonResponse['height'],
          'format': jsonResponse['format'],
          'bytes': jsonResponse['bytes'],
          'created_at': jsonResponse['created_at'],
        };
      } else {
        throw Exception('Upload failed: ${jsonResponse['error']?['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  // Upload image from gallery
  Future<Map<String, dynamic>?> pickAndUploadImage({
    String? folder,
    String? publicId,
    Map<String, String>? transformations,
    Map<String, String>? tags,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        File file = File(image.path);
        return await uploadFile(
          file,
          folder: folder,
          publicId: publicId,
          transformations: transformations,
          tags: tags,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Image pick and upload failed: $e');
    }
  }

  // Upload image from camera
  Future<Map<String, dynamic>?> captureAndUploadImage({
    String? folder,
    String? publicId,
    Map<String, String>? transformations,
    Map<String, String>? tags,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        File file = File(image.path);
        return await uploadFile(
          file,
          folder: folder,
          publicId: publicId,
          transformations: transformations,
          tags: tags,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Image capture and upload failed: $e');
    }
  }

  // Upload profile image
  Future<Map<String, dynamic>?> uploadProfileImage(
    String userId,
    File imageFile, {
    Map<String, String>? transformations,
  }) async {
    try {
      String folder = CloudinaryConfig.getFolderPath('profile_image', userId: userId);
      String publicId = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}';

      // Use profile image transformations
      Map<String, String> profileTransformations = 
          transformations ?? CloudinaryConfig.profileImageTransformations;

      return await uploadFile(
        imageFile,
        folder: folder,
        publicId: publicId,
        transformations: profileTransformations,
        tags: {'type': 'profile_image', 'user_id': userId},
      );
    } catch (e) {
      throw Exception('Profile image upload failed: $e');
    }
  }

  // Upload document
  Future<Map<String, dynamic>?> uploadDocument(
    String userId,
    File document,
    String documentType, {
    String? folder,
    Map<String, String>? tags,
  }) async {
    try {
      if (!CloudinaryConfig.isValidFileType(document.path, CloudinaryConfig.allowedDocumentTypes)) {
        throw Exception('Invalid document type');
      }

      String uploadFolder = folder ?? CloudinaryConfig.getFolderPath('document', userId: userId);
      String publicId = '${documentType}_${userId}_${DateTime.now().millisecondsSinceEpoch}';

      return await uploadFile(
        document,
        folder: uploadFolder,
        publicId: publicId,
        tags: {'type': 'document', 'document_type': documentType, 'user_id': userId},
      );
    } catch (e) {
      throw Exception('Document upload failed: $e');
    }
  }

  // Upload attendance sheet
  Future<Map<String, dynamic>?> uploadAttendanceSheet(
    String className,
    String date,
    File sheet, {
    String? facultyId,
    Map<String, String>? tags,
  }) async {
    try {
      if (!CloudinaryConfig.isValidFileType(sheet.path, CloudinaryConfig.allowedDocumentTypes)) {
        throw Exception('Invalid document type');
      }

      String folder = '${CloudinaryConfig.attendanceSheetsFolder}/$className/$date';
      String publicId = 'attendance_${className}_${date}_${DateTime.now().millisecondsSinceEpoch}';

      Map<String, String> sheetTags = {
        'type': 'attendance_sheet',
        'class': className,
        'date': date,
        if (facultyId != null) 'faculty_id': facultyId,
      };

      if (tags != null) {
        sheetTags.addAll(tags);
      }

      return await uploadFile(
        sheet,
        folder: folder,
        publicId: publicId,
        tags: sheetTags,
      );
    } catch (e) {
      throw Exception('Attendance sheet upload failed: $e');
    }
  }

  // Download file
  Future<Uint8List> downloadFile(String url) async {
    try {
      var response = await _httpClient.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Download failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('File download failed: $e');
    }
  }

  // Delete file
  Future<bool> deleteFile(String publicId) async {
    try {
      // Note: This requires server-side implementation with API key and secret
      // For security reasons, deletion should be handled server-side
      throw Exception('File deletion requires server-side implementation');
    } catch (e) {
      throw Exception('File deletion failed: $e');
    }
  }

  // Get file info
  Future<Map<String, dynamic>> getFileInfo(String publicId) async {
    try {
      var response = await _httpClient.get(
        Uri.parse('${CloudinaryConfig.apiUrl}/${CloudinaryConfig.cloudName}/image/upload/$publicId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get file info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get file info: $e');
    }
  }

  // Get optimized URL with transformations
  String getOptimizedUrl(String publicId, {Map<String, String>? transformations}) {
    return CloudinaryConfig.getResourceUrl(publicId, transformations: transformations);
  }

  // Get thumbnail URL
  String getThumbnailUrl(String publicId) {
    return CloudinaryConfig.getThumbnailUrl(publicId);
  }

  // Get profile image URL
  String getProfileImageUrl(String publicId) {
    return CloudinaryConfig.getProfileImageUrl(publicId);
  }

  // Search files by tag
  Future<List<Map<String, dynamic>>> searchFilesByTag(String tag) async {
    try {
      var response = await _httpClient.get(
        Uri.parse('${CloudinaryConfig.apiUrl}/${CloudinaryConfig.cloudName}/resources/image/tags/$tag'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['resources'] ?? []);
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  // Get usage statistics
  Future<Map<String, dynamic>> getUsageStatistics() async {
    try {
      // Note: This requires server-side implementation with API key and secret
      throw Exception('Usage statistics require server-side implementation');
    } catch (e) {
      throw Exception('Failed to get usage statistics: $e');
    }
  }

  // Validate file before upload
  Future<bool> _validateFile(File file) async {
    try {
      // Check file size
      int fileSize = await file.length();
      if (fileSize > CloudinaryConfig.maxImageSize) {
        throw Exception('File size exceeds limit');
      }

      // Check file type
      String fileName = file.path.split('/').last;
      if (!CloudinaryConfig.isValidFileType(fileName, CloudinaryConfig.allowedImageTypes)) {
        throw Exception('Invalid file type');
      }

      return true;
    } catch (e) {
      print('File validation failed: $e');
      return false;
    }
  }

  // Generate signed upload URL (for secure uploads)
  String generateSignedUploadUrl({
    required String folder,
    required String publicId,
    Map<String, String>? transformations,
    int expiration = 3600,
  }) {
    // Note: This requires server-side implementation for security
    // The signed URL should be generated server-side with your API secret
    throw Exception('Signed upload URLs require server-side implementation');
  }

  // Upload multiple files
  Future<List<Map<String, dynamic>>> uploadMultipleFiles(
    List<File> files, {
    String? folder,
    Map<String, String>? transformations,
    Map<String, String>? tags,
  }) async {
    try {
      List<Map<String, dynamic>> results = [];
      
      for (File file in files) {
        try {
          var result = await uploadFile(
            file,
            folder: folder,
            transformations: transformations,
            tags: tags,
          );
          results.add(result);
        } catch (e) {
          results.add({
            'success': false,
            'error': e.toString(),
            'file': file.path,
          });
        }
      }
      
      return results;
    } catch (e) {
      throw Exception('Multiple file upload failed: $e');
    }
  }

  // Get file metadata
  Future<Map<String, dynamic>> getFileMetadata(String publicId) async {
    try {
      var response = await _httpClient.get(
        Uri.parse('${CloudinaryConfig.apiUrl}/${CloudinaryConfig.cloudName}/image/upload/$publicId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get file metadata: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  // Update file metadata
  Future<bool> updateFileMetadata(
    String publicId,
    Map<String, String> metadata,
  ) async {
    try {
      // Note: This requires server-side implementation with API key and secret
      throw Exception('Metadata updates require server-side implementation');
    } catch (e) {
      throw Exception('Failed to update file metadata: $e');
    }
  }

  // Create folder structure
  Future<void> createFolder(String folderPath) async {
    // Cloudinary automatically creates folders when files are uploaded
    // This method is kept for consistency but doesn't perform any operation
    print('Folder structure will be created automatically when files are uploaded to: $folderPath');
  }

  // Move file (requires server-side implementation)
  Future<String> moveFile(String sourcePublicId, String destinationPublicId) async {
    try {
      // Note: This requires server-side implementation with API key and secret
      throw Exception('File moving requires server-side implementation');
    } catch (e) {
      throw Exception('File move failed: $e');
    }
  }

  // Copy file (requires server-side implementation)
  Future<String> copyFile(String sourcePublicId, String destinationPublicId) async {
    try {
      // Note: This requires server-side implementation with API key and secret
      throw Exception('File copying requires server-side implementation');
    } catch (e) {
      throw Exception('File copy failed: $e');
    }
  }

  // Dispose resources
  void dispose() {
    _httpClient.close();
  }
}
