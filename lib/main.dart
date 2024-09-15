import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/animation_text.dart';
import 'package:myapp/footer.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1E1E1E),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1E1E1E),
          secondary: Color(0xFF64FFDA),
        ),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatelessWidget {
  const PortfolioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(),
            const AboutSection(),
            const ExperienceSection(),
            WorkSection(),
            const ContactSection(),
            const Footer()
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        return SizedBox(
          height: isDesktop
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * 0.7,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1626&q=80',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FragileGatherTextAnimation(
                      text: 'Khoirul Fahmi',
                      textStyle:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isDesktop ? 48 : 36,
                              ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Flutter Developer & UI/UX Expert',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: isDesktop ? null : 18,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_downward),
                      label: const Text('View My Work'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        return Container(
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 100 : 30,
              horizontal: 20,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color:
                        Color(0xFF7FFFD4), // Warna mint yang sama dengan gambar
                  ),
                ),
                SizedBox(
                    height:
                        16), // Kurangi jarak ini, misalnya dari 24 menjadi 16
                Text(
                  "I'm a passionate Flutter developer and UI/UX expert with a keen eye for creating "
                  "beautiful, functional, and user-centered digital experiences. With a background in "
                  "both design and development, I bridge the gap between aesthetics and functionality.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12), // Tambahkan jarak kecil antara paragraf
                Text(
                  "My approach combines clean, efficient code with intuitive design principles to "
                  "deliver apps that not only work flawlessly but also delight users.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ));
      },
    );
  }



}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Experience',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: isDesktop ? null : 30,
                    ),
              ),
              const SizedBox(height: 50),
              _buildExperienceItem(
                context,
                'Senior Flutter Developer',
                'TechCorp Inc.',
                '2020 - Present',
                'Led the development of multiple high-profile mobile applications, implemented complex UI designs, and mentored junior developers.',
              ),
              const SizedBox(height: 30),
              _buildExperienceItem(
                context,
                'UI/UX Designer',
                'DesignHub Co.',
                '2018 - 2020',
                'Created user-centered designs for web and mobile applications, conducted user research, and developed interactive prototypes.',
              ),
              const SizedBox(height: 30),
              _buildExperienceItem(
                context,
                'Freelance Mobile Developer',
                'Self-employed',
                '2016 - 2018',
                'Developed custom mobile applications for various clients, focusing on clean code and intuitive user interfaces.',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExperienceItem(BuildContext context, String title,
      String company, String duration, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 5),
              Text(
                '$company | $duration',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[400],
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WorkSection extends StatelessWidget {
  final List<Project> projects = [
    Project(
      title: 'FitTrack',
      description: 'Fitness tracking app with personalized plans',
      technologies: ['Flutter', 'Firebase', 'BLoC'],
      imageUrl:
          'https://images.unsplash.com/photo-1613679074971-91fc27180061?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80',
      color: const Color(0xFF6C63FF),
    ),
    Project(
      title: 'EcoMarket',
      description: 'E-commerce platform for eco-friendly products',
      technologies: ['Flutter', 'AR Kit', 'Stripe'],
      imageUrl:
          'https://images.unsplash.com/photo-1535868463750-c78d9543614f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1476&q=80',
      color: const Color(0xFF00C853),
    ),
    Project(
      title: 'MindfulMoments',
      description: 'Meditation and mindfulness app',
      technologies: ['Flutter', 'Firebase', 'Provider'],
      imageUrl:
          'https://images.unsplash.com/photo-1535868463750-c78d9543614f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1476&q=80',
      color: const Color(0xFFFF5722),
    ),
    // Add more projects here
  ];

   WorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Work',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: isDesktop ? 48 : 36,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 30),
              ProjectCarousel(projects: projects, isDesktop: isDesktop),
            ],
          ),
        );
      },
    );
  }
}

class ProjectCarousel extends StatelessWidget {
  final List<Project> projects;
  final bool isDesktop;

  const ProjectCarousel(
      {super.key, required this.projects, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isDesktop ? 400 : 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ProjectCard(project: projects[index], isDesktop: isDesktop),
          );
        },
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final Project project;
  final bool isDesktop;

  const ProjectCard({super.key, required this.project, required this.isDesktop});

  @override
   createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 1.05).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform.scale(
          scale: _animation.value,
          child: child,
        ),
        child: SizedBox(
          width: widget.isDesktop ? 320 : 260,
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      widget.project.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            widget.project.color.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.isDesktop ? 24 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.project.description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: widget.isDesktop ? 16 : 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: widget.project.technologies
                                .map((tech) => Chip(
                                      label: Text(
                                        tech,
                                        style: TextStyle(
                                          fontSize: widget.isDesktop ? 12 : 10,
                                          color: widget.project.color,
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String imageUrl;
  final Color color;

  Project({
    required this.title,
    required this.description,
    required this.technologies,
    required this.imageUrl,
    required this.color,
  });
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Get In Touch',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: isDesktop ? null : 30,
                    ),
              ),
              const SizedBox(height: 30),
              Text(
                "I'm always open to new opportunities and collaborations. Whether you have a project in mind or just want to say hi, feel free to reach out!",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                      fontSize: isDesktop ? null : 16,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildContactMethod(context, FontAwesomeIcons.envelope,
                      'Email', 'mailto:your.email@example.com'),
                  _buildContactMethod(context, FontAwesomeIcons.linkedin,
                      'LinkedIn', 'https://www.linkedin.com/in/yourprofile'),
                  _buildContactMethod(context, FontAwesomeIcons.github,
                      'GitHub', 'https://github.com/yourusername'),
                  _buildContactMethod(context, FontAwesomeIcons.twitter,
                      'Twitter', 'https://twitter.com/yourusername'),
                ],
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // You can add functionality to open a contact form or modal here
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: isDesktop ? 18 : 16),
                ),
                child: const Text('Send a Message'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactMethod(
      BuildContext context, IconData icon, String label, String url) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon,
                color: Theme.of(context).colorScheme.secondary, size: 24),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
