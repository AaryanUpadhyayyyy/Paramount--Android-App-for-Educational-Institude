# Cloudinary Setup Guide for Paramount Classes

This guide will help you set up Cloudinary for file storage in your Paramount Classes Flutter application, replacing Firebase Storage.

## 🚀 **Why Cloudinary Instead of Firebase Storage?**

### **Advantages of Cloudinary:**
- ✅ **Generous Free Tier**: 25 GB storage, 25 GB bandwidth/month
- ✅ **Advanced Image Optimization**: Automatic format conversion, compression
- ✅ **Real-time Transformations**: Resize, crop, filter images on-the-fly
- ✅ **CDN Global Delivery**: Faster image loading worldwide
- ✅ **Better Image Handling**: Face detection, auto-cropping, quality optimization
- ✅ **Cost Effective**: More affordable for image-heavy applications
- ✅ **No Firebase Storage Costs**: Eliminates Firebase Storage billing concerns

### **What We're Using:**
- **Firebase**: Authentication, Firestore Database, Analytics, Messaging
- **Cloudinary**: File storage, image optimization, document management

---

## 📋 **Prerequisites**

- Flutter SDK installed
- Cloudinary account (free tier available)
- Internet connection for file uploads

---

## 🎯 **Step 1: Create Cloudinary Account**

### **1.1 Sign Up**
1. Go to [Cloudinary Console](https://cloudinary.com/console)
2. Click **"Sign Up For Free"**
3. Fill in your details:
   - **Email**: Your email address
   - **Password**: Strong password
   - **Account Name**: Choose a unique name (e.g., `paramount-classes`)
   - **Cloud Name**: This will be your unique identifier

### **1.2 Verify Email**
1. Check your email for verification link
2. Click the verification link
3. Complete your account setup

---

## ⚙️ **Step 2: Get Cloudinary Credentials**

### **2.1 Access Dashboard**
1. Log in to [Cloudinary Console](https://cloudinary.com/console)
2. You'll see your **Dashboard** with account information

### **2.2 Get Required Information**
From your dashboard, note down:

- **Cloud Name**: Your unique cloud identifier
- **API Key**: For server-side operations (optional)
- **API Secret**: For server-side operations (optional)

**Example:**
```
Cloud Name: paramount_classes
API Key: 123456789012345
API Secret: abcdefghijklmnopqrstuvwxyz123456
```

---

## 🔧 **Step 3: Configure Upload Presets**

### **3.1 Create Upload Preset**
1. In Cloudinary Console, go to **Settings** → **Upload**
2. Scroll down to **Upload presets**
3. Click **"Add upload preset"**

### **3.2 Configure Preset Settings**
Create these presets for different content types:

#### **Profile Images Preset**
- **Preset name**: `paramount_profile_images`
- **Signing Mode**: `Unsigned`
- **Folder**: `paramount/profile_images`
- **Allowed formats**: `jpg, jpeg, png, gif, webp`
- **Max file size**: `10MB`
- **Transformation**: 
  - Width: `300`
  - Height: `300`
  - Crop: `fill`
  - Gravity: `face`
  - Quality: `auto:good`

#### **Documents Preset**
- **Preset name**: `paramount_documents`
- **Signing Mode**: `Unsigned`
- **Folder**: `paramount/documents`
- **Allowed formats**: `pdf, doc, docx, xls, xlsx, ppt, pptx, txt`
- **Max file size**: `25MB`

#### **Attendance Sheets Preset**
- **Preset name**: `paramount_attendance_sheets`
- **Signing Mode**: `Unsigned`
- **Folder**: `paramount/attendance_sheets`
- **Allowed formats**: `pdf, xls, xlsx`
- **Max file size**: `25MB`

### **3.3 Save Presets**
1. Click **"Save"** for each preset
2. Note down the preset names for configuration

---

## 📱 **Step 4: Update Flutter Configuration**

### **4.1 Update Dependencies**
Your `pubspec.yaml` should already have the required dependencies:

```yaml
dependencies:
  # Cloudinary for file storage
  cloudinary_public: ^0.21.0
  http: ^1.1.0
  # Image handling
  image_picker: ^1.0.7
```

### **4.2 Update Cloudinary Configuration**
Edit `lib/config/cloudinary_config.dart`:

```dart
class CloudinaryConfig {
  // Update these with your actual Cloudinary credentials
  static const String cloudName = 'your_actual_cloud_name';
  static const String apiKey = 'your_actual_api_key'; // Optional for client-side
  static const String apiSecret = 'your_actual_api_secret'; // Optional for client-side
  static const String uploadPreset = 'paramount_profile_images'; // Your preset name
  
  // Other settings remain the same...
}
```

**Important**: For client-side uploads, you only need:
- `cloudName`
- `uploadPreset`

The `apiKey` and `apiSecret` are only needed for server-side operations.

---

## 🧪 **Step 5: Test Your Setup**

### **5.1 Test Basic Upload**
Use the example in your app:

```dart
import '../services/cloudinary_service.dart';

final CloudinaryService cloudinary = CloudinaryService();

// Test upload
try {
  var result = await cloudinary.pickAndUploadImage(
    folder: 'paramount/test',
    tags: {'type': 'test', 'app': 'paramount'},
  );
  
  if (result != null) {
    print('✅ Upload successful!');
    print('URL: ${result['url']}');
    print('Public ID: ${result['public_id']}');
  }
} catch (e) {
  print('❌ Upload failed: $e');
}
```

### **5.2 Test Profile Image Upload**
```dart
// Upload profile image
var result = await cloudinary.uploadProfileImage(
  'user123',
  imageFile,
);

if (result != null && result['success'] == true) {
  // Update user profile with new image URL
  await updateUserProfile({
    'profileImageUrl': result['url'],
    'profileImagePublicId': result['public_id'],
  });
}
```

---

## 🔒 **Step 6: Security Considerations**

### **6.1 Upload Preset Security**
- **Use unsigned uploads** for client-side operations
- **Restrict file types** and sizes in presets
- **Set folder restrictions** to prevent unauthorized uploads

### **6.2 Access Control**
- **Public access**: Images are publicly accessible by default
- **Private uploads**: Use signed uploads for sensitive content
- **Folder organization**: Use structured folders for better organization

### **6.3 Rate Limiting**
- **Free tier limits**: 25 GB storage, 25 GB bandwidth/month
- **Upload limits**: Monitor usage in Cloudinary dashboard
- **Cost optimization**: Use image transformations to reduce file sizes

---

## 📊 **Step 7: Advanced Features**

### **7.1 Image Transformations**
Cloudinary provides powerful image transformations:

```dart
// Get optimized profile image
String optimizedUrl = cloudinary.getProfileImageUrl('public_id_here');

// Get thumbnail
String thumbnailUrl = cloudinary.getThumbnailUrl('public_id_here');

// Custom transformations
String customUrl = cloudinary.getOptimizedUrl('public_id_here', {
  'width': '800',
  'height': '600',
  'crop': 'fill',
  'quality': 'auto:best',
});
```

### **7.2 File Management**
```dart
// Get file information
var fileInfo = await cloudinary.getFileInfo('public_id_here');

// Search files by tag
var taggedFiles = await cloudinary.searchFilesByTag('profile_image');

// Download file
var fileBytes = await cloudinary.downloadFile('https://res.cloudinary.com/...');
```

### **7.3 Batch Operations**
```dart
// Upload multiple files
List<File> files = [file1, file2, file3];
var results = await cloudinary.uploadMultipleFiles(
  files,
  folder: 'paramount/batch_upload',
  tags: {'batch': 'true', 'date': DateTime.now().toString()},
);
```

---

## 🚨 **Troubleshooting Common Issues**

### **Issue 1: "Upload preset not configured" error**
**Solution:**
- Verify upload preset name in `cloudinary_config.dart`
- Check if preset exists in Cloudinary Console
- Ensure preset is set to "Unsigned" mode

### **Issue 2: "Invalid file type" error**
**Solution:**
- Check allowed file types in upload preset
- Verify file extension is supported
- Update preset settings if needed

### **Issue 3: "File size exceeds limit" error**
**Solution:**
- Check file size limit in upload preset
- Compress large images before upload
- Update preset size limits if needed

### **Issue 4: Upload fails with network error**
**Solution:**
- Check internet connection
- Verify Cloudinary service status
- Check if you've exceeded free tier limits

### **Issue 5: Images not displaying**
**Solution:**
- Verify the returned URL is correct
- Check if image is publicly accessible
- Use HTTPS URLs for secure connections

---

## 💰 **Cost Optimization**

### **Free Tier Limits**
- **Storage**: 25 GB
- **Bandwidth**: 25 GB/month
- **Transformations**: 25,000/month
- **Uploads**: 25,000/month

### **Optimization Strategies**
1. **Use image transformations** to reduce file sizes
2. **Implement lazy loading** for images
3. **Use appropriate quality settings** (`auto:good` vs `auto:best`)
4. **Monitor usage** in Cloudinary dashboard
5. **Clean up unused files** regularly

### **Upgrade Considerations**
- **Pro Plan**: $89/month for 225 GB storage, 225 GB bandwidth
- **Advanced Plan**: $224/month for 1,125 GB storage, 1,125 GB bandwidth
- **Custom Plan**: Contact sales for enterprise needs

---

## 📱 **Platform-Specific Setup**

### **Android Setup**
1. Ensure `INTERNET` permission in `android/app/src/main/AndroidManifest.xml`
2. Test on physical device for camera functionality
3. Handle runtime permissions for camera and storage

### **iOS Setup**
1. Add camera and photo library usage descriptions in `ios/Runner/Info.plist`
2. Test on physical device for camera functionality
3. Handle permissions properly

### **Web Setup**
1. Test file picker functionality in web browser
2. Ensure proper CORS settings if needed
3. Handle file size limits for web uploads

---

## 🔄 **Migration from Firebase Storage**

### **What Changes:**
1. **Service calls**: Replace `StorageService` with `CloudinaryService`
2. **URL storage**: Store Cloudinary URLs instead of Firebase Storage URLs
3. **File operations**: Use Cloudinary methods for upload/download
4. **Configuration**: Update config files with Cloudinary settings

### **What Stays the Same:**
1. **File picker**: Still use `image_picker` package
2. **UI components**: No changes needed in UI
3. **Error handling**: Similar error handling patterns
4. **File validation**: Similar validation logic

---

## 📚 **Best Practices**

### **File Organization**
```
paramount/
├── profile_images/
│   ├── user123/
│   └── user456/
├── documents/
│   ├── user123/
│   └── user456/
├── attendance_sheets/
│   ├── 10th/
│   └── 11th/
└── student_documents/
    ├── user123/
    └── user456/
```

### **Naming Conventions**
- **Profile images**: `profile_userId_timestamp`
- **Documents**: `documentType_userId_timestamp`
- **Attendance sheets**: `attendance_className_date_timestamp`

### **Tagging Strategy**
- **Type tags**: `profile_image`, `document`, `attendance_sheet`
- **User tags**: `user_id: 123`
- **Class tags**: `class: 10th`, `section: A`
- **Date tags**: `date: 2024-01-15`

---

## 📞 **Support Resources**

- [Cloudinary Documentation](https://cloudinary.com/documentation)
- [Cloudinary Flutter Package](https://pub.dev/packages/cloudinary_public)
- [Cloudinary Community](https://community.cloudinary.com/)
- [Cloudinary Support](https://support.cloudinary.com/)

---

## 🎉 **Next Steps**

After setting up Cloudinary:

1. **Test all upload scenarios** thoroughly
2. **Implement image optimization** in your UI
3. **Set up file cleanup** for unused uploads
4. **Monitor usage** and costs
5. **Implement advanced transformations** for better UX
6. **Set up backup strategies** for important files

---

## 📝 **Configuration Summary**

Your final configuration should look like this:

```dart
// lib/config/cloudinary_config.dart
class CloudinaryConfig {
  static const String cloudName = 'your_cloud_name';
  static const String uploadPreset = 'paramount_profile_images';
  
  // Folder structure
  static const String profileImagesFolder = 'paramount/profile_images';
  static const String documentsFolder = 'paramount/documents';
  static const String attendanceSheetsFolder = 'paramount/attendance_sheets';
  
  // File limits
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxDocumentSize = 25 * 1024 * 1024; // 25MB
}
```

This setup gives you a powerful, cost-effective file storage solution that integrates seamlessly with your Firebase backend while providing superior image handling capabilities.
