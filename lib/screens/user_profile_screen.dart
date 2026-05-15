import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/database_service.dart';
import '../l10n/app_localizations.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();
  
  UserProfile _profile = UserProfile();
  bool _isLoading = true;
  
  final List<String> _availableGoals = [
    '减肥',
    '增肌',
    '改善睡眠',
    '缓解压力',
    '健康饮食',
    '规律运动',
    '保持健康',
    '改善心情'
  ];

  final List<String> _activityLevels = ['久坐', '轻度', '中度', '重度'];
  final List<String> _sleepGoals = ['6小时', '7小时', '8小时', '9小时'];
  final List<String> _stressLevels = ['低', '中', '高', '很高'];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _databaseService.getUserProfile();
    if (mounted) {
      setState(() {
        _profile = profile ?? UserProfile();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _databaseService.saveUserProfile(_profile);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存成功！')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('基本信息'),
                    const SizedBox(height: 12),
                    _buildTextField(
                      label: '姓名',
                      initialValue: _profile.name,
                      onSaved: (value) => _profile = _profile.copyWith(name: value ?? ''),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      label: '性别',
                      value: _profile.gender.isEmpty ? null : _profile.gender,
                      items: ['男', '女'],
                      onChanged: (value) => setState(() => _profile = _profile.copyWith(gender: value ?? '')),
                    ),
                    const SizedBox(height: 12),
                    _buildNumberField(
                      label: '年龄',
                      initialValue: _profile.age?.toString(),
                      onSaved: (value) => _profile = _profile.copyWith(age: int.tryParse(value ?? '')),
                    ),
                    const SizedBox(height: 12),
                    _buildNumberField(
                      label: '身高 (cm)',
                      initialValue: _profile.height?.toString(),
                      onSaved: (value) => _profile = _profile.copyWith(height: double.tryParse(value ?? '')),
                    ),
                    const SizedBox(height: 12),
                    _buildNumberField(
                      label: '体重 (kg)',
                      initialValue: _profile.weight?.toString(),
                      onSaved: (value) => _profile = _profile.copyWith(weight: double.tryParse(value ?? '')),
                    ),
                    if (_profile.bmi != null) ...[
                      const SizedBox(height: 12),
                      _buildBMICard(),
                    ],
                    const SizedBox(height: 24),
                    _buildSectionTitle('健康目标'),
                    const SizedBox(height: 12),
                    _buildMultiSelect(
                      title: '我的目标',
                      options: _availableGoals,
                      selectedOptions: _profile.goals,
                      onChanged: (selected) => setState(() => _profile = _profile.copyWith(goals: selected)),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('健康状况'),
                    const SizedBox(height: 12),
                    _buildTagsInput(
                      label: '病史',
                      hint: '添加病史...',
                      tags: _profile.medicalHistory,
                      onTagsChanged: (tags) => setState(() => _profile = _profile.copyWith(medicalHistory: tags)),
                    ),
                    const SizedBox(height: 12),
                    _buildTagsInput(
                      label: '饮食注意事项',
                      hint: '添加注意事项...',
                      tags: _profile.dietaryNotes,
                      onTagsChanged: (tags) => setState(() => _profile = _profile.copyWith(dietaryNotes: tags)),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('生活方式'),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      label: '活动水平',
                      value: _profile.activityLevel,
                      items: _activityLevels,
                      onChanged: (value) => setState(() => _profile = _profile.copyWith(activityLevel: value)),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      label: '睡眠目标',
                      value: _profile.sleepGoal,
                      items: _sleepGoals,
                      onChanged: (value) => setState(() => _profile = _profile.copyWith(sleepGoal: value)),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdownField(
                      label: '压力水平',
                      value: _profile.stressLevel,
                      items: _stressLevels,
                      onChanged: (value) => setState(() => _profile = _profile.copyWith(stressLevel: value)),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      label: '职业',
                      initialValue: _profile.occupation,
                      onSaved: (value) => _profile = _profile.copyWith(occupation: value),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF2E7D32),
                      ),
                      child: const Text('保存', style: TextStyle(fontSize: 16)),
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
        color: Color(0xFF2E7D32),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      initialValue: initialValue,
      onSaved: onSaved,
    );
  }

  Widget _buildNumberField({
    required String label,
    String? initialValue,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      onSaved: onSaved,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildMultiSelect({
    required String title,
    required List<String> options,
    required List<String> selectedOptions,
    required ValueChanged<List<String>> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                final newSelected = List<String>.from(selectedOptions);
                if (selected) {
                  newSelected.add(option);
                } else {
                  newSelected.remove(option);
                }
                onChanged(newSelected);
              },
              selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
              checkmarkColor: const Color(0xFF2E7D32),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTagsInput({
    required String label,
    required String hint,
    required List<String> tags,
    required ValueChanged<List<String>> onTagsChanged,
  }) {
    final TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        if (tags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Chip(
                label: Text(tag),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  final newTags = List<String>.from(tags)..remove(tag);
                  onTagsChanged(newTags);
                },
                backgroundColor: Colors.grey[100],
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    final newTags = List<String>.from(tags)..add(value.trim());
                    onTagsChanged(newTags);
                    controller.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFF2E7D32)),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  final newTags = List<String>.from(tags)..add(controller.text.trim());
                  onTagsChanged(newTags);
                  controller.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBMICard() {
    final bmi = _profile.bmi!;
    String category;
    Color color;
    
    if (bmi < 18.5) {
      category = '偏瘦';
      color = Colors.blue;
    } else if (bmi < 24) {
      category = '正常';
      color = Colors.green;
    } else if (bmi < 28) {
      category = '超重';
      color = Colors.orange;
    } else {
      category = '肥胖';
      color = Colors.red;
    }

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.monitor_weight, size: 32, color: Color(0xFF2E7D32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('BMI指数', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    '${bmi.toStringAsFixed(1)} - $category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
