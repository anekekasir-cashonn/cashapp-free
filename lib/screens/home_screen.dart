import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cashapp_free/providers/index.dart';
import 'package:cashapp_free/utils/localization_helper.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  
  const HomeScreen({Key? key, this.onNavigate}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, dynamic> _todayStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayStatistics();
  }

  Future<void> _loadTodayStatistics() async {
    final transactionProvider =
        context.read<TransactionProvider>();
    _todayStats = await transactionProvider.getDailyStatistics(DateTime.now());
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final lang = Provider.of<SettingsProvider>(context).language;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                t('home_screen.title', lang),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Statistics Cards
              if (!_isLoading)
                Column(
                  children: [
                    // Today's Transaction
                    _buildStatCard(
                      context,
                      icon: Icons.receipt,
                      title: t('home_screen.today_transactions', lang),
                      value: _todayStats['transactionCount'].toString(),
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),

                    // Today's Revenue
                    _buildStatCard(
                      context,
                      icon: Icons.trending_up,
                      title: t('home_screen.today_revenue', lang),
                      value:
                          'Rp ${NumberFormat('#,###').format(_todayStats['totalAmount'] ?? 0)}',
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),

                    // Total Revenue
                    _buildStatCard(
                      context,
                      icon: Icons.wallet,
                      title: t('home_screen.total_revenue', lang),
                      value:
                          'Rp ${NumberFormat('#,###').format(transactionProvider.totalRevenue)}',
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),

                    // Total Transactions
                    _buildStatCard(
                      context,
                      icon: Icons.shopping_cart,
                      title: t('home_screen.total_transactions', lang),
                      value: transactionProvider.totalTransactions.toString(),
                      color: Colors.purple,
                    ),
                  ],
                )
              else
                const Center(
                  child: CircularProgressIndicator(),
                ),

              const SizedBox(height: 24),

              // Quick Actions
              Text(
                t('home_screen.quick_actions', lang),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: t('home_screen.new_sale', lang),
                      icon: Icons.add_shopping_cart,
                      onTap: () {
                        _navigateToTab(2);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: t('home_screen.inventory', lang),
                      icon: Icons.inventory_2,
                      onTap: () {
                        _navigateToTab(1);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: t('home_screen.history', lang),
                      icon: Icons.history,
                      onTap: () {
                        _navigateToTab(3);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: t('settings_screen.title', lang),
                      icon: Icons.settings,
                      onTap: () {
                        _navigateToTab(4);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTab(int tabIndex) {
    if (widget.onNavigate != null) {
      widget.onNavigate!(tabIndex);
    }
  }
}
