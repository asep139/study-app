import 'package:flutter/material.dart';
import 'package:lern/core/services/tutor_api_service.dart';

class TeacherHomeTab extends StatefulWidget {
  const TeacherHomeTab({super.key});

  @override
  State<TeacherHomeTab> createState() => _TeacherHomeTabState();
}

class _TeacherHomeTabState extends State<TeacherHomeTab> {
  bool _isLoading = true;
  List<dynamic> _incomingBookings = [];
  List<dynamic> _upcomingBookings = [];
  String _tutorName = "Pak Asep";

  static const _stats = [
    {
      'title': 'Total Students',
      'value': '1,234',
      'icon': Icons.people_rounded,
      'color': Color(0xFF3B82F6)
    },
    {
      'title': 'Active Courses',
      'value': '12',
      'icon': Icons.menu_book_rounded,
      'color': Color(0xFF10B981)
    },
    {
      'title': 'Monthly Earnings',
      'value': 'Rp 5.4M',
      'icon': Icons.account_balance_wallet_rounded,
      'color': Color(0xFF6366F1)
    },
    {
      'title': 'Average Rating',
      'value': '4.9',
      'icon': Icons.star_rounded,
      'color': Color(0xFFF59E0B)
    },
  ];

  static const _activities = [
    {
      'type': 'enrollment',
      'message': 'John Doe enrolled in Advanced Math',
      'time': '2 hours ago'
    },
    {
      'type': 'review',
      'message': 'New 5-star review on Physics Course',
      'time': '5 hours ago'
    },
    {
      'type': 'message',
      'message': 'New message from Alice Smith',
      'time': '1 day ago'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    final result = await TutorApiService.instance.getTutorBookings();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result['success'] && result['data'] != null) {
        final allBookings = result['data'] as List;
        _incomingBookings =
            allBookings.where((b) => b['status'] == 'pending').toList();
        _upcomingBookings =
            allBookings.where((b) => b['status'] == 'confirmed').toList();
      }
    });
  }

  Future<void> _respondBooking(String bookingId, bool isAccept) async {
    final result = isAccept
        ? await TutorApiService.instance.acceptBooking(bookingId)
        : await TutorApiService.instance.declineBooking(bookingId);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(isAccept ? 'Booking accepted! 🎉' : 'Booking declined! ❌'),
          backgroundColor: isAccept ? Colors.green : Colors.red,
        ),
      );
      _loadDashboardData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _completeSession(String bookingId) async {
    setState(() => _isLoading = true);
    final result = await TutorApiService.instance.completeBooking(bookingId);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Session completed! Coins received. 💰'),
            backgroundColor: Colors.green),
      );
      _loadDashboardData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
      setState(() => _isLoading = false);
    }
  }

  // Fungsi Format Waktu yang baru (sudah aman di dalam class)
  String _formatDateTime(String? isoString) {
    if (isoString == null) return 'Unknown time';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      final day = dt.day.toString().padLeft(2, '0');
      final month = months[dt.month - 1];
      final year = dt.year;
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');

      return '$day $month $year, $hour:$minute';
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3B82F6), Color(0xFF93C5FD), Color(0xFFFFFFFF)],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildQuickStats(),
                      const SizedBox(height: 32),
                      _buildUpcomingSessions(),
                      const SizedBox(height: 32),
                      _buildRecentActivity(),
                      const SizedBox(height: 32),
                      _buildQuickActions(context),
                      const SizedBox(height: 40),
                      _buildIncomingRequests(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning! 👋',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _tutorName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 32),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444), // Red notification dot
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFF3B82F6),
                        width: 2), // Blue border to blend with background
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: 16), // Slight inset so cards peek from the edge
        itemCount: _stats.length,
        itemBuilder: (context, index) {
          final s = _stats[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (s['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(s['icon'] as IconData,
                      color: s['color'] as Color, size: 20),
                ),
                const Spacer(),
                Text(
                  s['value'] as String,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s['title'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Sessions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B)),
              ),
              Text(
                '${_upcomingBookings.length} Sessions',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_upcomingBookings.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text("No upcoming sessions.",
                style: TextStyle(color: Colors.grey)),
          )
        else
          ..._upcomingBookings.map((booking) => _buildSessionCard(booking)),
      ],
    );
  }

  Widget _buildSessionCard(dynamic booking) {
    final studentName = booking['student'] != null
        ? booking['student']['full_name']
        : 'Student';

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.videocam_rounded,
                    color: Color(0xFF4F46E5)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Session with $studentName",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatDateTime(booking['start_at']),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _completeSession(booking['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Complete Session',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._activities.map((a) => _buildActivityCard(a)),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    IconData icon;
    Color color;

    switch (activity['type']) {
      case 'enrollment':
        icon = Icons.person_add_rounded;
        color = const Color(0xFF10B981); // Green
        break;
      case 'review':
        icon = Icons.star_rounded;
        color = const Color(0xFFF59E0B); // Amber
        break;
      case 'message':
      default:
        icon = Icons.chat_bubble_rounded;
        color = const Color(0xFF3B82F6); // Blue
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['message'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.add_circle_rounded,
        'label': 'Create',
        'color': const Color(0xFF3B82F6)
      },
      {
        'icon': Icons.schedule_rounded,
        'label': 'Schedule',
        'color': const Color(0xFF10B981)
      },
      {
        'icon': Icons.analytics_rounded,
        'label': 'Analytics',
        'color': const Color(0xFF6366F1)
      },
      {
        'icon': Icons.help_rounded,
        'label': 'Support',
        'color': Colors.grey.shade600
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actions
                .map<Widget>((action) => _buildActionButton(context, action))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, Map<String, dynamic> action) {
    return GestureDetector(
      onTap: () {
        if (action['label'] == 'Schedule') {
          _showScheduleDialog(context);
        }
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
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
            child: Icon(
              action['icon'] as IconData,
              color: action['color'] as Color,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action['label'] as String,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    String selectedDay = 'Monday';
    final startTimeController = TextEditingController(text: '09:00');
    final endTimeController = TextEditingController(text: '12:00');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Set Availability',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedDay,
                decoration: InputDecoration(
                  labelText: 'Day of Week',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday'
                ]
                    .map(
                        (day) => DropdownMenuItem(value: day, child: Text(day)))
                    .toList(),
                onChanged: (val) => setDialogState(() => selectedDay = val!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startTimeController,
                      decoration: InputDecoration(
                        labelText: 'Start (HH:MM)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: endTimeController,
                      decoration: InputDecoration(
                        labelText: 'End (HH:MM)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.pop(context); // Tutup dialog sebelum tembak API

                final result = await TutorApiService.instance.addAvailability(
                  dayOfWeek: selectedDay,
                  startTime: startTimeController.text,
                  endTime: endTimeController.text,
                );

                if (!context.mounted) return;

                if (result['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Schedule added successfully!'),
                        backgroundColor: Colors.green),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(result['message']),
                        backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Save',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Incoming Booking Requests',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(12)),
                child: Text('${_incomingBookings.length}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_incomingBookings.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text("No incoming booking requests yet.",
                style: TextStyle(color: Colors.grey)),
          )
        else
          ..._incomingBookings.map((booking) => _buildBookingCard(booking)),
      ],
    );
  }

  Widget _buildBookingCard(dynamic booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.class_rounded, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(
                      "New Request: ${booking['duration_minutes']} Mins",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
            ],
          ),
          const SizedBox(height: 8),
          Text("Time: ${_formatDateTime(booking['start_at'])}",
              style: const TextStyle(color: Colors.grey)),
          if (booking['description'] != null) ...[
            const SizedBox(height: 8),
            Text("Notes: ${booking['description']}",
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _respondBooking(booking['id'], false),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red)),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _respondBooking(booking['id'], true),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Accept',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
