import 'package:flutter/material.dart';
import '../config/ai_config.dart';
import '../services/model_router_service.dart';

class ModelSettingsScreen extends StatefulWidget {
  final UserModelConfig modelConfig;

  const ModelSettingsScreen({super.key, required this.modelConfig});

  @override
  State<ModelSettingsScreen> createState() => _ModelSettingsScreenState();
}

class _ModelSettingsScreenState extends State<ModelSettingsScreen> {
  final TextEditingController _openAiController = TextEditingController();
  final TextEditingController _claudeController = TextEditingController();
  final TextEditingController _doubaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _openAiController.text = widget.modelConfig.openAiApiKey ?? '';
    _claudeController.text = widget.modelConfig.claudeApiKey ?? '';
    _doubaoController.text = widget.modelConfig.doubaoApiKey ?? '';
  }

  @override
  void dispose() {
    _openAiController.dispose();
    _claudeController.dispose();
    _doubaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 模型设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('AI 运行模式'),
          const SizedBox(height: 8),
          _buildModeSelector(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('选择云端模型'),
          const SizedBox(height: 8),
          _buildCloudModelSelector(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('API 密钥配置'),
          const SizedBox(height: 8),
          _buildApiKeyConfig(),
          const SizedBox(height: 24),
          
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildModeSelector() {
    return Card(
      child: Column(
        children: [
          _buildModeOption(
            title: '完全本地模式',
            subtitle: '100% 隐私保护，无网络请求',
            icon: Icons.security,
            mode: AiMode.local,
          ),
          const Divider(height: 1),
          _buildModeOption(
            title: '混合模式（推荐）',
            subtitle: '优先本地，失败时降级云端',
            icon: Icons.auto_mode,
            mode: AiMode.hybrid,
          ),
          const Divider(height: 1),
          _buildModeOption(
            title: '云端优先',
            subtitle: '使用最强大的云端模型',
            icon: Icons.cloud,
            mode: AiMode.cloud,
          ),
        ],
      ),
    );
  }

  Widget _buildModeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required AiMode mode,
  }) {
    return RadioListTile<AiMode>(
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(icon),
      value: mode,
      groupValue: widget.modelConfig.aiMode,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            widget.modelConfig.updateAiMode(value);
          });
        }
      },
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildCloudModelSelector() {
    return Card(
      child: Column(
        children: [
          _buildCloudModelOption(
            model: CloudModelType.openai,
            name: 'OpenAI',
            description: 'GPT-3.5/4 模型，全球最佳质量',
            icon: Icons.lightbulb,
          ),
          const Divider(height: 1),
          _buildCloudModelOption(
            model: CloudModelType.claude,
            name: 'Claude',
            description: 'Claude 3 模型，隐私友好，健康领域强',
            icon: Icons.favorite,
          ),
          const Divider(height: 1),
          _buildCloudModelOption(
            model: CloudModelType.doubao,
            name: '豆包',
            description: '中文优化，国内访问速度快',
            icon: Icons.language,
          ),
        ],
      ),
    );
  }

  Widget _buildCloudModelOption({
    required CloudModelType model,
    required String name,
    required String description,
    required IconData icon,
  }) {
    return RadioListTile<CloudModelType>(
      title: Text(name),
      subtitle: Text(description),
      secondary: Icon(icon),
      value: model,
      groupValue: widget.modelConfig.cloudModel,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            widget.modelConfig.updateCloudModel(value);
          });
        }
      },
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildApiKeyConfig() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildApiKeyField(
              label: 'OpenAI API Key',
              controller: _openAiController,
              hint: 'sk-...',
              onChanged: (value) => widget.modelConfig.updateOpenAiApiKey(value),
            ),
            const SizedBox(height: 16),
            _buildApiKeyField(
              label: 'Claude API Key',
              controller: _claudeController,
              hint: 'sk-ant-...',
              onChanged: (value) => widget.modelConfig.updateClaudeApiKey(value),
            ),
            const SizedBox(height: 16),
            _buildApiKeyField(
              label: '豆包 API Key',
              controller: _doubaoController,
              hint: '请输入您的 API Key',
              onChanged: (value) => widget.modelConfig.updateDoubaoApiKey(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      obscureText: true,
      onChanged: onChanged,
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '关于 AI 模型',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '• 本地模式：使用预设规则分析，无网络请求，完全私密\n'
              '• 混合模式：优先本地，复杂任务使用云端\n'
              '• 云端模式：使用最强大的 AI 模型，需要配置 API Key\n\n'
              '您的 API Key 仅保存在本地，不会上传到任何服务器。',
            ),
          ],
        ),
      ),
    );
  }
}
