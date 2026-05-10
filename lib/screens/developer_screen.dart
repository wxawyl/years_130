import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.developerCenter),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeroSection(context, l10n),
            const SizedBox(height: 24),
            _buildFeatureGrid(context, l10n),
            const SizedBox(height: 24),
            _buildContributorsSection(l10n),
            const SizedBox(height: 24),
            _buildStatsSection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, AppLocalizations l10n) {
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
          const Icon(Icons.code, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text(
            l10n.buildTogether,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.developerDescription,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showGetStartedDialog(context, l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF7E57C2),
            ),
            child: Text(l10n.getStarted),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, AppLocalizations l10n) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        FeatureCard(
          icon: Icons.extension,
          title: l10n.pluginMarket,
          description: l10n.pluginMarketDescription,
          color: Colors.blue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PluginMarketScreen()),
          ),
        ),
        FeatureCard(
          icon: Icons.description,
          title: l10n.apiDocs,
          description: l10n.apiDocsDescription,
          color: Colors.green,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ApiDocsScreen()),
          ),
        ),
        FeatureCard(
          icon: Icons.code,
          title: l10n.github,
          description: l10n.githubDescription,
          color: Colors.black,
          onTap: () => _launchUrl(context, 'https://github.com'),
        ),
        FeatureCard(
          icon: Icons.people,
          title: l10n.community,
          description: l10n.communityDescription,
          color: Colors.orange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CommunityScreen()),
          ),
        ),
        FeatureCard(
          icon: Icons.model_training,
          title: l10n.aiMarket,
          description: l10n.aiMarketDescription,
          color: Colors.purple,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIMarketScreen()),
          ),
        ),
        FeatureCard(
          icon: Icons.badge,
          title: l10n.contributors,
          description: l10n.contributorsDescription,
          color: Colors.pink,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContributorsScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildContributorsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.topContributors,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildContributorAvatar('Dev1', true),
            _buildContributorAvatar('Dev2', false),
            _buildContributorAvatar('Dev3', true),
            _buildContributorAvatar('Dev4', false),
            _buildContributorAvatar('Dev5', false),
            _buildContributorAvatar('Dev6', true),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('+24', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContributorAvatar(String name, bool isVerified) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF7E57C2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                name.substring(3),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (isVerified)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(AppLocalizations l10n) {
    final stats = [
      StatCard(value: '128', label: l10n.plugins),
      StatCard(value: '2.4K', label: l10n.stars),
      StatCard(value: '38', label: l10n.contributors),
      StatCard(value: '156', label: l10n.commits),
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(child: stat);
      }).toList(),
    );
  }

  void _showGetStartedDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.welcomeDeveloper),
        content: Text(l10n.developerWelcomeMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _launchUrl(BuildContext context, String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $url...')),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class PluginMarketScreen extends StatelessWidget {
  const PluginMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.pluginMarket), centerTitle: true),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}

class ApiDocsScreen extends StatelessWidget {
  const ApiDocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.apiDocs), centerTitle: true),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.community), centerTitle: true),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}

class AIMarketScreen extends StatelessWidget {
  const AIMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aiMarket), centerTitle: true),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}

class ContributorsScreen extends StatelessWidget {
  const ContributorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.contributors), centerTitle: true),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}