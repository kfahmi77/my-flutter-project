import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/animation.dart';
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

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

final ScrollController _scrollController = ScrollController();
final GlobalKey _workSectionKey = GlobalKey();

void _scrollToWorkSection() {
  final RenderBox renderBox =
      _workSectionKey.currentContext!.findRenderObject() as RenderBox;
  final position = renderBox.localToGlobal(Offset.zero);
  _scrollController.animateTo(
    position.dy,
    duration: const Duration(seconds: 1),
    curve: Curves.easeInOut,
  );
}

class _PortfolioHomeState extends State<PortfolioHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const HeroSection(onViewWorkPressed: _scrollToWorkSection),
            const AnimatedAboutSection(),
            const AnimatedExperienceSection(),
            WorkSection(key: _workSectionKey),
            const ContactSection(),
            const Footer()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class HeroSection extends StatelessWidget {
  final VoidCallback onViewWorkPressed;

  const HeroSection({super.key, required this.onViewWorkPressed});

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
                      'Flutter Developer & Backend Enthusiast',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: isDesktop ? null : 18,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.arrowDown),
                      label: const Text('View My Work'),
                      onPressed: onViewWorkPressed,
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

class WorkSection extends StatelessWidget {
  WorkSection({super.key});

  final List<Project> projects = [
    Project(
      title: 'Mamanotes',
      description: 'Note App for record the child\'s growth and development',
      technologies: ['Flutter', 'Firebase', 'GetX'],
      imageUrl:
          'https://raw.githubusercontent.com/kfahmi77/my-flutter-project/portofolio/assets/Screenshot%202024-09-18%20at%2019.36.28.png',
      color: const Color.fromARGB(255, 255, 0, 98),
    ),
    Project(
      title: 'Hangman',
      description: 'Puzzle App for solving word before moving running out',
      technologies: [
        'Flutter',
        'SQlite',
      ],
      imageUrl:
          'https://raw.githubusercontent.com/kfahmi77/my-flutter-project/portofolio/assets/Screenshot%202024-09-18%20at%2019.36.48.png',
      color: const Color.fromARGB(255, 76, 0, 255),
    ),
    Project(
      title: 'GeoFace',
      description: 'Attendance App using TFlite for face identification',
      technologies: ['Flutter', 'Laravel', 'Bloc'],
      imageUrl:
          'https://raw.githubusercontent.com/kfahmi77/face_attendance/main/assets/screenshots/Homepage.png',
      color: const Color.fromARGB(255, 70, 142, 250),
    ),
    Project(
      title: 'A Dark Pathway',
      description:
          'It is a 2D action game with unique mechanics, in a dark place, players can only move if there is light. Guide the player to the next stage using the light. Avoid existing monsters, by choosing a safe route It is a 2D action game with unique mechanics, in a dark place, players can only move if there is light. Guide the player to the next stage using the light. Avoid existing monsters, by choosing a safe route',
      technologies: ['Unity', 'C#'],
      imageUrl:
          'https://raw.githubusercontent.com/kfahmi77/my-flutter-project/940e48ae6afd6c418c43231e0b95dad6b1fd1cec/assets/uJiwdr.jpeg',
      color: const Color.fromARGB(255, 181, 253, 47),
    ),
    Project(
      title: 'MyDaily',
      description:
          'Special Note App for students to record their academic activities',
      technologies: ['Kotlin', 'XML'],
      imageUrl:
          'https://play-lh.googleusercontent.com/9aAjYco6oHN4UDHewr4ZNr06UDXQTMaIzGgm0rRIZhPnOLgLxhGUjz9QzhxOGvduuaY=w480-h960',
      color: const Color.fromARGB(255, 0, 198, 248),
    ),
    // Add more projects here
  ];
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

  const ProjectCard(
      {super.key, required this.project, required this.isDesktop});

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
                      'Email', 'mailto:khoirulfahmi44@gmail.com'),
                  _buildContactMethod(context, FontAwesomeIcons.linkedin,
                      'LinkedIn', 'https://www.linkedin.com/in/khoirul-fahmi'),
                  _buildContactMethod(context, FontAwesomeIcons.github,
                      'GitHub', 'https://github.com/kfahmi77'),
                ],
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
