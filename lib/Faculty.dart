import 'package:flutter/material.dart';
import 'dart:async'; // Timer ke liye
import 'package:url_launcher/url_launcher.dart'; // url_launcher import kiya

// Top-level function to launch URLs
Future<void> _launchUrl(BuildContext context, String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url)) {
    // Fallback for when the URL cannot be launched
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch $urlString')),
    );
    debugPrint('Could not launch $urlString');
  }
}

// Faculty ab ek StatelessWidget hai kyunki page-level animation FacultyCard handle karega
class Faculty extends StatelessWidget {
  const Faculty({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Our Esteemed Faculty", // Title update kiya
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Oswald-VariableFont_wght',
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        centerTitle: true, // Title ko center mein kiya
        elevation: 4.0,
      ),
      body: Container( // Body ko Container mein wrap kiya
        color: Colors.white, // White background
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title with Slogan
              const Text(
                "Meet Our Expert", // Title updated for single faculty
                style: TextStyle(
                  fontSize: 28, // Thoda bada font
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald-VariableFont_wght',
                  color: Colors.indigo, // Darker indigo
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
              const Divider(color: Colors.blue, thickness: 3, indent: 0, endIndent: 80), // Thoda chhota divider
              const SizedBox(height: 30),

              // Faculty Card for Dr. Sunil Upadhyay (Only this card remains)
              FacultyCard( // Ab FacultyCard widget use kar rahe hain
                name: "Dr. Sunil Upadhyay",
                subject: "English", // Subject updated
                imageUrl: "assets/images/sunil.jpg", // Asset path
                description: "Dr. Sunil Upadhyay has over 20 years of experience in teaching English for CBSE exams. His unique teaching style simplifies complex grammar rules, writing techniques, and literature lessons, making them easy to understand for students. He is known for his dedication and result-oriented approach.",
                contactNo: "+91 9837712159", // Contact Number
                email: "sunil.upadhyay@example.com", // Email ID
                facebookProfileUrl: "https://www.facebook.com/your_sunil_profile", // Facebook Profile URL
                onTap: () {
                  // Ab yahan _launchUrl ko call karenge
                  _launchUrl(context, "https://www.facebook.com/your_sunil_profile"); // Facebook profile open karega
                },
              ),
              const SizedBox(height: 20), // Reduced spacing if only one card
            ],
          ),
        ),
      ),
    );
  }
}

// FacultyCard widget to encapsulate individual faculty member's details and tap effect
class FacultyCard extends StatefulWidget {
  final String name;
  final String subject;
  final String imageUrl;
  final String description;
  final String contactNo; // New: Contact Number
  final String email;     // New: Email ID
  final String facebookProfileUrl; // New: Facebook Profile URL
  final VoidCallback onTap;

  const FacultyCard({
    super.key,
    required this.name,
    required this.subject,
    required this.imageUrl,
    required this.description,
    required this.contactNo, // Required parameter
    required this.email,     // Required parameter
    required this.facebookProfileUrl, // Required parameter
    required this.onTap,
  });

  @override
  State<FacultyCard> createState() => _FacultyCardState();
}

class _FacultyCardState extends State<FacultyCard> with TickerProviderStateMixin {
  late AnimationController _tapController; // For tap animation
  late Animation<double> _scaleAnimation;

  late AnimationController _openingController; // For opening animation of this card
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _imageOpacityAnimation;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _contactOpacityAnimation;
  late Animation<Offset> _contactSlideAnimation;
  late Animation<double> _buttonOpacityAnimation;
  late Animation<Offset> _buttonSlideAnimation;


  @override
  void initState() {
    super.initState();

    // Tap Animation Controller
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Animation duration
      lowerBound: 0.90, // Minimum scale when pressed
      upperBound: 1.0, // Maximum scale (original size)
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
    _tapController.value = 1.0; // Initially set to original size

    // Opening Animation Controller for individual card elements
    _openingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Increased duration for detailed opening animation
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _openingController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn), // Card fades in first 60% of animation
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _openingController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut), // Card slides up slightly
      ),
    );

    // Image/Avatar Animation (fades in slightly later)
    _imageOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _openingController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeIn),
      ),
    );
    _imageSlideAnimation = Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _openingController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    // Name & Subject Animation
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _openingController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeIn),
      ),
    );
    _textSlideAnimation = Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _openingController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
      ),
    );

    // Description, Contact Info, Button Animation
    _contactOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _openingController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );
    _contactSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _openingController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );
    _buttonOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _openingController,
        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
      ),
    );
    _buttonSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _openingController,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    _openingController.forward(); // Start the complex opening animation
  }

  @override
  void dispose() {
    _tapController.dispose();
    _openingController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _tapController.reverse(); // Scale down for tap
  }

  void _handleTapUp(TapUpDetails details) {
    Timer(const Duration(milliseconds: 100), () {
      _tapController.forward(); // Scale back up for tap
    });
    widget.onTap(); // Call the original onTap callback
  }

  void _handleTapCancel() {
    _tapController.forward(); // Scale back up if tap is cancelled
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition( // Slide effect for the whole card
      position: _slideAnimation,
      child: FadeTransition( // Fade effect for the whole card
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector( // GestureDetector for tap events
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image and Name/Subject Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image/Avatar with its own animation
                            SlideTransition(
                              position: _imageSlideAnimation,
                              child: FadeTransition(
                                opacity: _imageOpacityAnimation,
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: widget.imageUrl.startsWith('http')
                                      ? NetworkImage(widget.imageUrl) as ImageProvider<Object>
                                      : AssetImage(widget.imageUrl) as ImageProvider<Object>,
                                  onBackgroundImageError: (exception, stackTrace) {
                                    debugPrint('Image failed to load: ${widget.imageUrl}');
                                  },
                                  child: (widget.imageUrl.isEmpty || (widget.imageUrl.startsWith('http') && !Uri.parse(widget.imageUrl).isAbsolute))
                                      ? Icon(Icons.person, size: 50, color: Colors.grey.shade600)
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Name & Subject with its own animation
                            Expanded(
                              child: SlideTransition(
                                position: _textSlideAnimation,
                                child: FadeTransition(
                                  opacity: _textOpacityAnimation,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.name,
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
                                          widget.subject,
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
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 30, thickness: 1, color: Colors.blueGrey),

                        // Description with its own animation
                        SlideTransition(
                          position: _contactSlideAnimation, // Reusing slide for description for now
                          child: FadeTransition(
                            opacity: _contactOpacityAnimation, // Reusing fade for description for now
                            child: Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Colors.grey.shade800,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Contact Information with its own animation
                        SlideTransition(
                          position: _contactSlideAnimation,
                          child: FadeTransition(
                            opacity: _contactOpacityAnimation,
                            child: Row(
                              children: [
                                Icon(Icons.phone, size: 18, color: Colors.grey.shade600),
                                const SizedBox(width: 8),
                                Text(
                                  widget.contactNo,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SlideTransition(
                          position: _contactSlideAnimation,
                          child: FadeTransition(
                            opacity: _contactOpacityAnimation,
                            child: Row(
                              children: [
                                Icon(Icons.email, size: 18, color: Colors.grey.shade600),
                                const SizedBox(width: 8),
                                Text(
                                  widget.email,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // View Profile Button with its own animation
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SlideTransition(
                            position: _buttonSlideAnimation,
                            child: FadeTransition(
                              opacity: _buttonOpacityAnimation,
                              child: ElevatedButton.icon(
                                onPressed: widget.onTap,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
