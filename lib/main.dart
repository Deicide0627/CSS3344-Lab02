
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const StudentInfoApp());
}

// Main Application
class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

// Exercise 2.2 - Orientation and Adaptive Layout
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState
    extends State<StudentProfileScreen> {

  DateTime? _selectedDate;
  String _selectedRole = 'Student';

  final List<String> _roles = [
    'Student',
    'Developer',
    'Designer',
  ];

  // Material Date Picker
  Future<void> _selectMaterialDate(
      BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Cupertino Date Picker
  void _showCupertinoDatePicker(BuildContext context) {
    final DateTime now = DateTime.now();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground
              .resolveFrom(popupContext),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(popupContext).pop();
                    },
                    child: const Text('Done'),
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _selectedDate ?? now,
                    minimumDate: DateTime(1950),
                    maximumDate: now,
                    onDateTimeChanged: (DateTime date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Cupertino Role Wheel Picker
  void _showCupertinoRolePicker(BuildContext context) {
    final controller = FixedExtentScrollController(
      initialItem: _roles.indexOf(_selectedRole),
    );

    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground
              .resolveFrom(popupContext),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(popupContext).pop();
                    },
                    child: const Text('Done'),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: controller,
                    itemExtent: 36,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedRole = _roles[index];
                      });
                    },
                    children: _roles.map((role) {
                      return Center(
                        child: Text(role),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() => controller.dispose());
  }

  // Format selected date
  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Not selected';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CSS3344 Mobile App Dev - Lab 02',
        ),
        centerTitle: true,
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitView();
          } else {
            return _buildLandscapeView();
          }
        },
      ),
    );
  }

  // Portrait Mode
  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StudentDetailsSection(),
        const SizedBox(height: 16),
        const LocationDetailsSection(),
        const SizedBox(height: 16),
        _buildPickerSection(),
      ],
    );
  }

  // Landscape Mode
  Widget _buildLandscapeView() {
    return Row(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: const [
              StudentDetailsSection(),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const LocationDetailsSection(),
              const SizedBox(height: 16),
              _buildPickerSection(),
            ],
          ),
        ),
      ],
    );
  }

  // Exercise: Four Interactive Pickers
  Widget _buildPickerSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Pickers (Lab 2.2)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 24),

            Text(
              'Selected Date: ${_formatDate(_selectedDate)}',
            ),

            const SizedBox(height: 8),

            Text(
              'Selected Role: $_selectedRole',
            ),

            const SizedBox(height: 20),

            // Picker 1: Material Date Picker
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _selectMaterialDate(context);
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Material Date Picker'),
              ),
            ),

            const SizedBox(height: 8),

            // Picker 2: Cupertino Date Picker
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showCupertinoDatePicker(context);
                },
                icon: const Icon(Icons.date_range),
                label: const Text('Cupertino Date Picker'),
              ),
            ),

            const SizedBox(height: 16),

            // Picker 3: Material Dropdown
            const Text(
              'Material Dropdown:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            DropdownButton<String>(
              value: _selectedRole,
              isExpanded: true,
              items: _roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                }
              },
            ),

            const SizedBox(height: 12),

            // Picker 4: Cupertino Wheel Picker
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showCupertinoRolePicker(context);
                },
                icon: const Icon(Icons.view_list),
                label: const Text(
                  'Cupertino Role Wheel Picker',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Student Profile Section
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'ASMOND YONG LEONG KANG',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Student ID: BCS24020053',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const Divider(height: 32),

            const Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '"My goal is to become a skilled software '
                  'developer and create applications that help people."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Location Details Section
class LocationDetailsSection extends StatelessWidget {
  const LocationDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),

          Text(
            'Location Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          TitleSection(
            name:
            'Hogwarts School of Witchcraft and Wizardry',
            location: 'Hogsmeade, Scotland',
            starCount: 41,
          ),
        ],
      ),
    );
  }
}

// Exercise 2.1 - TitleSection
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}
