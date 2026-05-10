import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/feedback_service.dart';
import '../models/feedback.dart' as fb;
import '../l10n/app_localizations.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _contactController = TextEditingController();
  String _selectedType = 'suggestion';
  bool _isSubmitting = false;
  bool _showSuccess = false;

  final List<FeedbackType> _feedbackTypes = [
    FeedbackType(
      id: 'suggestion',
      icon: Icons.lightbulb_outline,
      label: 'suggestion',
      color: Colors.amber,
      description: 'improvement',
    ),
    FeedbackType(
      id: 'bug',
      icon: Icons.bug_report,
      label: 'bugReport',
      color: Colors.red,
      description: 'issueFound',
    ),
    FeedbackType(
      id: 'feature',
      icon: Icons.add_box,
      label: 'featureRequest',
      color: Colors.blue,
      description: 'newFeature',
    ),
    FeedbackType(
      id: 'praise',
      icon: Icons.thumb_up,
      label: 'praise',
      color: Colors.green,
      description: 'positiveFeedback',
    ),
    FeedbackType(
      id: 'other',
      icon: Icons.more_horiz,
      label: 'other',
      color: Colors.grey,
      description: 'otherFeedback',
    ),
  ];

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      await Future.delayed(Duration(milliseconds: 500));

      fb.Feedback feedback = fb.Feedback(
        type: _selectedType,
        content: _contentController.text,
        contact: _contactController.text.isNotEmpty ? _contactController.text : null,
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      );

      await FeedbackService().submitFeedback(feedback);

      setState(() {
        _isSubmitting = false;
        _showSuccess = true;
      });

      await Future.delayed(Duration(milliseconds: 2000));

      setState(() {
        _showSuccess = false;
        _contentController.clear();
        _contactController.clear();
        _selectedType = 'suggestion';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.feedback),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeaderSection(l10n),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFeedbackTypeSection(l10n),
                      const SizedBox(height: 24),
                      _buildContentSection(l10n),
                      const SizedBox(height: 20),
                      _buildContactSection(l10n),
                      const SizedBox(height: 24),
                      _buildSubmitButton(l10n),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showSuccess) _buildSuccessOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.message_outlined, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text(
            l10n.yourVoiceMatters,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.feedbackDescription,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackTypeSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.feedbackType,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          children: _feedbackTypes.map((type) {
            bool isSelected = _selectedType == type.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedType = type.id),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected ? type.color.withOpacity(0.2) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? type.color : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(type.icon, color: isSelected ? type.color : Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getLocalizedLabel(type.label, l10n),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? type.color : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContentSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.feedbackContent,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: _contentController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: l10n.feedbackHint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterContent;
              }
              if (value.length < 10) {
                return l10n.minLengthWarning;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.contactInfo,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _contactController,
          decoration: InputDecoration(
            hintText: l10n.contactHint,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.contactOptional,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: _submitFeedback,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7E57C2),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      child: _isSubmitting
          ? const CircularProgressIndicator(color: Colors.white)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send),
                const SizedBox(width: 8),
                Text(l10n.submitFeedback, style: const TextStyle(fontSize: 16)),
              ],
            ),
    );
  }

  Widget _buildSuccessOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 16),
              Text(
                'Thank you!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Your feedback has been received',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedLabel(String label, AppLocalizations l10n) {
    switch (label) {
      case 'suggestion':
        return l10n.suggestion;
      case 'bugReport':
        return l10n.bugReport;
      case 'featureRequest':
        return l10n.featureRequest;
      case 'praise':
        return l10n.praise;
      case 'other':
        return l10n.other;
      default:
        return label;
    }
  }
}

class FeedbackType {
  final String id;
  final IconData icon;
  final String label;
  final Color color;
  final String description;

  FeedbackType({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
    required this.description,
  });
}