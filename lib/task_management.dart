import 'package:crmapp/add_property_fromDoc.dart';
import 'package:crmapp/task_add.dart';
import 'package:crmapp/task_edit.dart';
import 'package:crmapp/task_view.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:circular_menu/circular_menu.dart';
import 'add_contact.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TaskManagementPage(),
    );
  }
}

class TaskManagementPage extends StatefulWidget {
  @override
  _TaskManagementPageState createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage> {
  void initState() {
    super.initState();
    _fetchtasksFromFirestore();
    _applyFilters(); // Call this to initialize the filteredTasks list
  }

  List<Task> tasks = [
    // Add more tasks as needed
  ];

  List<String> filteredTasks1 = [];

  final List<ValueItem> myOptions = [
    ValueItem(label: 'MEETING SCHEDULED', value: 'MEETING SCHEDULED'),
    ValueItem(label: 'EVENT', value: 'EVENT'),
    ValueItem(label: 'APPROVALS', value: 'APPROVALS'),
    ValueItem(label: 'VERIFICATION', value: 'VERIFICATION'),
    ValueItem(label: 'REPORT MANAGEMENT', value: 'REPORT MANAGEMENT'),
    ValueItem(label: 'MARKETING', value: 'MARKETING'),
    ValueItem(label: 'DEAL MANAGEMENT', value: 'DEAL MANAGEMENT'),
    ValueItem(label: 'FOLLOW UP', value: 'FOLLOW UP'),
    ValueItem(label: 'INSPECTION', value: 'INSPECTION'),
    ValueItem(label: 'OTHER OPPORTUNITIES', value: 'OTHER OPPORTUNITIES'),
    ValueItem(label: 'TO-DO', value: 'TO-DO'),

    // Add more task types as needed
  ];

  final List<ValueItem> priorityOptions = [
    ValueItem(label: 'HIGH', value: 'HIGH'),
    ValueItem(label: 'MEDIUM', value: 'MEDIUM'),
    ValueItem(label: 'LOW', value: 'LOW'),
  ];

  List<Task> filteredTasks = [];
  List<String> _selectedTaskTypes = [];
  List<String> _selectedPriorities = [];

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircularMenu(
        alignment: Alignment.bottomRight,
        toggleButtonColor: Color.fromARGB(255, 141, 195, 243),
        toggleButtonSize: 36,
        items: [
          CircularMenuItem(
            icon: Icons.add,
            onTap: () {
              // Implement the action for the first button
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TaskAddPage()));
              print('First button pressed');
            },
          ),
          CircularMenuItem(
            icon: Icons.camera_alt,
            onTap: () async {
              final cameras = await availableCameras();
              // Get a specific camera from the list of available cameras.
              final firstCamera = cameras.first;
              // Implement the action for the second button
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TakePictureScreen1(
                            camera: firstCamera,
                          )));
              print('Second button pressed');
            },
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Task Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFilterForm(),
            const SizedBox(height: 20),
            _buildTaskList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterForm() {
    return Column(
      children: [
        MultiSelectDropDown(
          options: myOptions,
          onOptionSelected: (selectedItems) {
            setState(() {
              _selectedTaskTypes = selectedItems
                  .map((item) => item.value)
                  .cast<String>()
                  .toList();
              _applyFilters();
            });
          },
          hint: 'Select Task Types',
        ),
        const SizedBox(height: 10),
        MultiSelectDropDown(
          options: priorityOptions,
          onOptionSelected: (selectedItems) {
            setState(() {
              _selectedPriorities = selectedItems
                  .map((item) => item.value)
                  .cast<String>()
                  .toList();
              _applyFilters();
            });
          },
          hint: 'Select Priorities',
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _searchController,
          onChanged: _searchTasks,
          decoration: InputDecoration(
            labelText: 'Search by Task Title',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          Task task = filteredTasks[index];
          int timeDifference = task.endDate.difference(DateTime.now()).inDays;
          return ListTile(
            title: Text(task.taskName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${task.taskTypes}'),
                Text('Priority: ${task.priorityLevels}'),
                if (timeDifference == 1) Text('${timeDifference} day left'),
                if (timeDifference != 1)
                  Text('${timeDifference.abs()} days left'),
              ],
            ),
            onTap: () {
              _viewTaskDetails(task);
            },
          );
        },
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      filteredTasks = tasks.where((task) {
        bool typeFilter = _selectedTaskTypes.isEmpty ||
            _selectedTaskTypes.contains(task.taskTypes.toString());
        bool priorityFilter = _selectedPriorities.isEmpty ||
            _selectedPriorities.contains(task.priorityLevels);

        return typeFilter && priorityFilter;
      }).toList();
    });
  }

  void _searchTasks(String query) {
    setState(() {
      filteredTasks = tasks
          .where((task) =>
              task.taskName.toLowerCase().contains(query.toLowerCase()) ||
              task.assignedTo
                  .join(',')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              task.taskWithWhom
                  .join(',')
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _fetchtasksFromFirestore() async {
    try {
      var user_id = FirebaseAuth.instance.currentUser!.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .collection('tasks')
          .get();

      setState(() {
        tasks.clear();
        tasks.addAll(snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Task(
            taskId: data['taskId'],
            // contactId: data['contactId'],
            taskName: data['taskName'],
            // taskDetails: data['taskDetails'],
            taskStatus: data['taskStatus'],
            taskTypes: data['taskTypes'],
            priorityLevels: data['priorityLevels'],
            assignedTo: data['assignedTo'],
            taskWithWhom: data['taskWithWhom'],
            budgetAllocated: data['budgetAllocated'],
            startDate: data['startDate'].toDate(),
            endDate: data['endDate'].toDate(),
            reminderDate: data['reminderDate'].toDate(),
            repeats: data['repeats'],
            otherDependentTask: data['otherDependentTask'],
            taskDescription: data['taskDescription'],
          );
        }));
        filteredTasks = tasks;
        // filteredTasks1
        // filteredTasks1 = filteredTasks
        //     .map((e) =>
        //         '${e..toString()} || ${e.category} || ${e.company.toString()}|| ${e.phoneNumber.toString()}')
        //     .toList();
      });
    } catch (error) {
      print('Error fetching contacts: $error');
    }
  }

  void _viewTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.taskName),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Type: ${task.taskTypes}'),
              Divider(),
              Text('Priority: ${task.priorityLevels}'),
              Divider(),
              SizedBox(height: 10),
              Text('Due Date: ${task.endDate.toLocal()}'),
              Divider(),
              // IconButton(
              //   icon: Icon(Icons.person),
              //   tooltip: 'View Profile',
              //   onPressed: () {},
              // ),
              Text('Assigned To: ${task.assignedTo.join(', ')}'),
              Divider(),
              Text('With: ${task.taskWithWhom.join(', ')}'),
              Divider(),
              Text('Budget Allocated: ${task.budgetAllocated}'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TaskEditPage(
                              task: task,
                            )));
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TaskViewPage(
                              task: task,
                            )));
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Task {
  final String taskId;
  final String taskName;
  final String taskDescription;
  final String taskStatus;
  final String taskTypes;
  final String priorityLevels;
  final List<dynamic> assignedTo;
  final List<dynamic> taskWithWhom;
  final String budgetAllocated;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime reminderDate;
  final String repeats;
  final String otherDependentTask;

  Task({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.taskStatus,
    required this.taskTypes,
    required this.priorityLevels,
    required this.assignedTo,
    required this.taskWithWhom,
    required this.budgetAllocated,
    required this.startDate,
    required this.endDate,
    required this.reminderDate,
    required this.repeats,
    required this.otherDependentTask,
  });
}
