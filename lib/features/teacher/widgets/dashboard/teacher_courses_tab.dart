import 'package:flutter/material.dart';
import '../../../../core/services/teacher_services.dart';

class TeacherCoursesTab extends StatefulWidget {
  const TeacherCoursesTab({super.key});

  @override
  State<TeacherCoursesTab> createState() => _TeacherCoursesTabState();
}

class _TeacherCoursesTabState extends State<TeacherCoursesTab> {
  List<dynamic> _offerList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyOffers();
  }

  Future<void> _loadMyOffers() async {
    setState(() => _isLoading = true);

    final result = await TutorApiService.instance.getMyOffers();

    if (!mounted) return;

    if (result['success']) {
      setState((){
        _offerList = result['data'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateCourseDialog(context),
        backgroundColor: const Color(0xFF4F46E5),
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        // icon: const Icon(Icons.add_rounded, color: Colors.white),
        // label: const Text('Add New Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        // The unified 3-color background gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3B82F6), // Vivid blue
              Color(0xFF93C5FD), // Light blue
              Color(0xFFFFFFFF), // White
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'My Courses',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Custom Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 24),
              
              // Course List
              Expanded(
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Colors.white)) 
                  : _offerList.isEmpty 
                    ? const Center (
                        child: Text('No offers found', style: TextStyle(color: Colors.white70)),
                      ) 
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 24.0, 
                          right: 24.0, 
                          bottom: 40.0, 
                        ),
                        itemCount: _offerList.length,
                        itemBuilder: (context, index) => _buildCourseItem(_offerList[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search courses...',
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade400,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCourseItem(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF), // Very light indigo background
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.menu_book_rounded, 
              color: Color(0xFF4F46E5), // Indigo icon
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          // Course Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['title'] ?? 'Untitled Course',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B), // Dark slate
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      '${course['duration_minutes'] ?? 60} minutes',
                      style: TextStyle(
                        fontSize: 12, 
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.monetization_on_rounded, size: 16, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 4),
                    Text(
                      '${course['coins_per_hour'] ?? 0} coins/hour',
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: FontWeight.w600, 
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Popup Menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.grey.shade400),
            onSelected: (value) {
              // Action handlers go here later
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'analytics', child: Text('Analytics')),
              PopupMenuItem(
                value: 'delete', 
                child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _showCreateCourseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final durationController = TextEditingController(text: '60');
    final coinsController = TextEditingController(text: '15');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Create New Course', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController, 
                decoration: InputDecoration(
                  labelText: 'Course Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                )
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController, 
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                )
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: durationController, 
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Duration (mins)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ), 
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: coinsController, 
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price (Coins)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ), 
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);

              final result = await TutorApiService.instance.createOffer(
                title: titleController.text,
                description: descController.text,
                durationMinutes: int.tryParse(durationController.text) ?? 60,
                coinsPerHour: int.tryParse(coinsController.text) ?? 15,
              );

              if (!mounted) return;

              if (result['success']) {
                _loadMyOffers();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Course created successfully!'), backgroundColor: Colors.green),
                );
              } else {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}