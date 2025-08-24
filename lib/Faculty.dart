import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // url_launcher ko UI interaction ke liye use karein

// Ek function jo URLs launch karta hai
Future<void> _launchUrl(BuildContext context, String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch $urlString')),
    );
    debugPrint('Could not launch $urlString');
  }
}

// Faculty page jo faculty members ki list dikhata hai
class Faculty extends StatelessWidget {
  const Faculty({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for multiple faculty members
    final List<Map<String, String>> facultyMembers = [
      {
        "name": "Dr. Sunil Upadhyay",
        "subject": "English",
        "imageUrl": "assets/images/sunil.jpg",
        "description": "Dr. Sunil Upadhyay has over 20 years of experience in teaching English for CBSE exams. His unique teaching style simplifies complex grammar rules, writing techniques, and literature lessons, making them easy to understand for students. He is known for his dedication and result-oriented approach.",
        "contactNo": "+91 9837712159",
        "email": "sunil.upadhyay@example.com",
        "facebookProfileUrl": "https://www.facebook.com/your_sunil_profile",
      },
      {
        "name": "Prof. Anjali Mehta",
        "subject": "Mathematics",
        "imageUrl": "assets/images/girl.png",
        "description": "Prof. Mehta is a distinguished mathematician with a passion for teaching. She specializes in advanced calculus and linear algebra, and her classes are known for their clarity and problem-solving focus. She has helped numerous students excel in competitive exams.",
        "contactNo": "+91 9876543210",
        "email": "anjali.mehta@example.com",
        "facebookProfileUrl": "https://www.facebook.com/anjali_mehta_profile",
      },
      // Aap yahan aur faculty members add kar sakte hain
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Our Esteemed Faculty",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Oswald-VariableFont_wght',
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Meet Our Experts",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald-VariableFont_wght',
                  color: Colors.indigo,
                ),
              ),
              const Text(
                "Guiding you towards a brighter future with their vast knowledge and experience.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Divider(color: Colors.blue, thickness: 3, indent: 0, endIndent: 80),
              const SizedBox(height: 30),

              // Har faculty member ke liye ek card generate karein
              ...facultyMembers.map((faculty) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FacultyCard(
                  name: faculty["name"]!,
                  subject: faculty["subject"]!,
                  imageUrl: faculty["imageUrl"]!,
                  description: faculty["description"]!,
                  contactNo: faculty["contactNo"]!,
                  email: faculty["email"]!,
                  onTap: () {
                    // Jab card par tap ho to Facebook profile open karein
                    if (faculty["facebookProfileUrl"]!.isNotEmpty) {
                      _launchUrl(context, faculty["facebookProfileUrl"]!);
                    }
                  },
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

// FacultyCard widget jo individual faculty member ke details dikhata hai
class FacultyCard extends StatelessWidget {
  final String name;
  final String subject;
  final String imageUrl;
  final String description;
  final String contactNo;
  final String email;
  final VoidCallback onTap;

  const FacultyCard({
    super.key,
    required this.name,
    required this.subject,
    required this.imageUrl,
    required this.description,
    required this.contactNo,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell( // For tap effect
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and Name/Subject Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: AssetImage(imageUrl),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade300),
                          ),
                          child: Text(
                            subject,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 1, color: Colors.blueGrey),

              // Description
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),

              // Contact Information
              _buildContactRow(Icons.phone, contactNo),
              const SizedBox(height: 8),
              _buildContactRow(Icons.email, email),
              const SizedBox(height: 15),

              // View Profile Button
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  label: const Text("View Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for contact details row
  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }
}
