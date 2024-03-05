import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:crmapp/task_management.dart';

class TaskViewPage extends StatelessWidget {
  final Task task;

  const TaskViewPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Task',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroIconText(
                'Task Name', Icons.assignment, task?.taskName ?? ''),
            _buildHeroIconText('Task With Whom', Icons.people,
                _formatList(task?.taskWithWhom).toString()),
            _buildHeroIconText('Assigned To', Icons.person,
                _formatList(task?.assignedTo).toString()),
            const SizedBox(height: 20),
            _buildHeroIconText(
                'Task Types', Icons.category, task?.taskTypes ?? ''),
            _buildHeroIconText('Start Date', Icons.calendar_today,
                _formatDate(task?.startDate).toString()),
            _buildHeroIconText('End Date', Icons.calendar_today,
                _formatDate(task?.endDate).toString()),
            _buildHeroIconText(
                'Priority', Icons.warning, task?.priorityLevels ?? ''),
            _buildHeroIconText(
                'Status', Icons.check_circle, task?.taskStatus ?? ''),
            _buildHeroIconText('Budget Allocated', Icons.currency_rupee,
                task?.budgetAllocated ?? ''),
            _buildHeroIconText('Other Dependent Task', Icons.link,
                task?.otherDependentTask ?? ''),
            _buildHeroIconText('Reminder Date', Icons.notifications_active,
                _formatDate(task?.reminderDate).toString()),
            _buildHeroIconText('Repeats', Icons.repeat, task?.repeats ?? ''),
            _buildHeroIconText('Task Description', Icons.description,
                task?.taskDescription ?? ''),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String? _formatDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd').format(date) : null;
  }

  String? _formatList(List<dynamic>? list) {
    return list?.join(', ') ?? '';
  }

  Widget _buildHeroIconText(String label, IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Hero(
                tag: label, // Ensure this tag is unique for each Hero widget
                child: AnimatedContainer(
                  height: 30,
                  width: 30,
                  duration: Duration(seconds: 1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ],
          ),
          SizedBox(height: 8),
          FadeInWidget(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
      ),
    );
  }
}

class FadeInWidget extends StatefulWidget {
  final Widget child;

  FadeInWidget({required this.child});

  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
