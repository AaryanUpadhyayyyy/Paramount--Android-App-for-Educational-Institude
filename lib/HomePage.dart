import 'package:flutter/material.dart';
import 'package:paramount/Attendance.dart';
import 'package:paramount/Faculty.dart'; // Attendance page ko import karein

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upadhyay Paramount Classes",
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo.shade700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    'Upadhyay Paramount Classes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oswald-VariableFont_wght',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Excellence in Education',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.indigo),
              title: const Text('Home', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups, color: Colors.black),
              title: const Text('Attendance', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (content)=>const Attendance())); // Navigate to Attendance page
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.blue),
              title: const Text('Courses', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Courses Page Under Development')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.green),
              title: const Text('Faculty', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (content)=>const Faculty())); // Navigate to Attendance page
              },
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.orange),
              title: const Text('Admissions', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Admissions Page Under Development')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event, color: Colors.purple),
              title: const Text('Events', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Events Page Under Development')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books, color: Colors.teal),
              title: const Text('Resources', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Resources Page Under Development')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.redAccent),
              title: const Text('Contact Us', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact Us Page Under Development')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.grey),
              title: const Text('About App', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('About App Page Under Development')),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.asset("assets/images/homepage.jpg", // Placeholder image URL
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome to Upadhyay Paramount Classes!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oswald-VariableFont_wght',
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Your journey to excellence begins here. We are dedicated to providing high-quality education and fostering a nurturing learning environment for all our students. Join our community for a brighter future!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald-VariableFont_wght',
                color: Colors.indigo,
              ),
            ),
            const Divider(color: Colors.blue, thickness: 2, endIndent: 150),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildQuickActionCard(
                  context,
                  icon: Icons.calendar_today,
                  title: "Exam Schedule",
                  color: Colors.purple.shade400,
                  onPressed: () { // Corrected syntax
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exam Schedule Page Under Development')),
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.assignment,
                  title: "Assignments",
                  color: Colors.red.shade400,
                  onPressed: () { // Corrected syntax
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Assignments Page Under Development')),
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.people,
                  title: "Attendance",
                  color: Colors.orange.shade400,
                  onPressed: () { // Added missing onPressed parameter
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Attendance()));
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.receipt_long,
                  title: "Fee Payment",
                  color: Colors.green.shade400,
                  onPressed: () { // Corrected syntax
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fee Payment Page Under Development')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 25),

            const Text(
              "Our Highlights",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald-VariableFont_wght',
                color: Colors.indigo,
              ),
            ),
            const Divider(color: Colors.blue, thickness: 2, endIndent: 150),
            const SizedBox(height: 15),
            _buildFeatureCard(
              icon: Icons.lightbulb_outline,
              title: "Expert Faculty",
              description: "Learn from highly experienced and dedicated educators.",
            ),
            _buildFeatureCard(
              icon: Icons.book_online,
              title: "Comprehensive Courses",
              description: "Well-structured courses designed for holistic learning and skill development.",
            ),
            _buildFeatureCard(
              icon: Icons.leaderboard,
              title: "Result-Oriented Approach",
              description: "Focused strategies, regular assessments, and performance tracking.",
            ),
            _buildFeatureCard(
              icon: Icons.support,
              title: "Personalized Guidance",
              description: "Individual attention and dedicated doubt-clearing sessions for every student.",
            ),
            const SizedBox(height: 25),

            const Text(
              "Success Stories",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald-VariableFont_wght',
                color: Colors.indigo,
              ),
            ),
            const Divider(color: Colors.blue, thickness: 2, endIndent: 150),
            const SizedBox(height: 15),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildTestimonialCard(
                    'Priya Sharma',
                    'Upadhyay Paramount Classes ne meri life badal di! Yahan ke teachers aur study material ne mujhe IIT JEE clear karne mein bahut help ki. Highly recommended!',
                  ),
                  _buildTestimonialCard(
                    'Rahul Kumar',
                    'The best coaching institute for competitive exams. Unki personalized guidance aur regular mock tests ne mere confidence ko boost kiya.',
                  ),
                  _buildTestimonialCard(
                    'Anjali Singh',
                    'Maine yahan se NEET ki coaching ki. Doubt-clearing sessions aur exhaustive practice ne mujhe top rank achieve karne mein madad ki.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              "About Us",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald-VariableFont_wght',
                color: Colors.indigo,
              ),
            ),
            const Divider(color: Colors.blue, thickness: 2, endIndent: 200),
            const SizedBox(height: 15),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Upadhyay Paramount Classes has been a pioneer in quality education for over two decades. We believe in nurturing talent and building strong foundations for a brighter future. Join us to experience a difference in your learning journey and achieve your academic dreams.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build feature cards
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue.shade700, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build quick action cards
  Widget _buildQuickActionCard(BuildContext context, { // Return type changed from Future<Widget> to Widget
    required IconData icon,
    required String title,
    required Color color,
    required Function() onPressed,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onPressed, // Yahan 'onPressed' callback ko call kiya ja raha hai
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build testimonial cards
  Widget _buildTestimonialCard(String name, String quote) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 15),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '“$quote”',
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade800,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '- $name',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
