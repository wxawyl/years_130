import 'package:flutter/material.dart';
import '../models/user_settings.dart';
import '../services/database_service_unified.dart';

class HealthProfileScreen extends StatefulWidget {
  const HealthProfileScreen({super.key});

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseServiceUnified _dbService = DatabaseServiceUnified();
  UserSettings? _settings;
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String? _selectedGender;
  String? _selectedHealthGoal;
  final List<String> _selectedHealthIssues = [];

  static const List<String> _genders = ['男', '女', '其他'];
  static const List<String> _healthGoals = ['减脂', '增肌', '改善睡眠', '调节情绪', '保持健康', '其他'];
  static const List<String> _availableHealthIssues = [
    '胃病', '失眠', '高血压', '糖尿病', '关节问题', 
    '过敏', '消化问题', '情绪问题', '其他'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final settings = await _dbService.getUserSettings();
      if (settings != null) {
        setState(() {
          _settings = settings;
          _nameController.text = settings.name ?? '';
          _ageController.text = settings.age?.toString() ?? '';
          _heightController.text = settings.height?.toString() ?? '';
          _weightController.text = settings.weight?.toString() ?? '';
          _selectedGender = settings.gender;
          _selectedHealthGoal = settings.healthGoal;
          _selectedHealthIssues.clear();
          _selectedHealthIssues.addAll(settings.healthIssuesList);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载数据失败: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final settings = _settings ?? UserSettings();
      settings.name = _nameController.text.isEmpty ? null : _nameController.text;
      settings.age = _ageController.text.isEmpty ? null : int.tryParse(_ageController.text);
      settings.height = _heightController.text.isEmpty ? null : double.tryParse(_heightController.text);
      settings.weight = _weightController.text.isEmpty ? null : double.tryParse(_weightController.text);
      settings.gender = _selectedGender;
      settings.healthGoal = _selectedHealthGoal;
      settings.healthIssuesList = _selectedHealthIssues;

      await _dbService.updateUserSettings(settings);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存成功！')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人健康档案'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('基本信息'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nameController,
                      label: '姓名',
                      icon: Icons.person,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _ageController,
                            label: '年龄',
                            icon: Icons.cake,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGenderDropdown(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _heightController,
                            label: '身高 (cm)',
                            icon: Icons.height,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _weightController,
                            label: '体重 (kg)',
                            icon: Icons.monitor_weight,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('健康目标'),
                    const SizedBox(height: 16),
                    _buildGoalDropdown(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('健康情况'),
                    const SizedBox(height: 16),
                    _buildHealthIssuesChecklist(),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveSettings,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '保存设置',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedGender,
      decoration: InputDecoration(
        labelText: '性别',
        prefixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
      items: _genders.map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
    );
  }

  Widget _buildGoalDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedHealthGoal,
      decoration: InputDecoration(
        labelText: '我的健康目标',
        prefixIcon: const Icon(Icons.flag),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
      items: _healthGoals.map((goal) {
        return DropdownMenuItem(
          value: goal,
          child: Text(goal),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedHealthGoal = value;
        });
      },
    );
  }

  Widget _buildHealthIssuesChecklist() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableHealthIssues.map((issue) {
        final isSelected = _selectedHealthIssues.contains(issue);
        return FilterChip(
          label: Text(issue),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedHealthIssues.add(issue);
              } else {
                _selectedHealthIssues.remove(issue);
              }
            });
          },
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.primary,
        );
      }).toList(),
    );
  }
}
