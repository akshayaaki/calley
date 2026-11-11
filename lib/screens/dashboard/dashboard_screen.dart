import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/calling_list_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/whatsapp_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../history/call_history_screen.dart';
import '../leads/leads_queue_screen.dart';
import '../schedule/schedule_screen.dart';
import 'widgets/calling_list_modal.dart';
import 'widgets/custom_drawer.dart';
import 'widgets/donut_chart_widget.dart';
import 'widgets/empty_dashboard_widget.dart';
import 'widgets/stat_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        context.read<CallingListProvider>().fetchLists(user.id);
      }
    });
  }

  void _onStartCalling() {
    final listProvider = context.read<CallingListProvider>();
    if (listProvider.selectedList == null) {
      CallingListModal.show(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LeadsQueueScreen()),
      );
    }
  }

  String _getAppBarTitle() {
    switch (_currentNavIndex) {
      case 3:
        return 'Call History';
      case 4:
        return 'Schedule Calendar';
      case 0:
      default:
        return AppStrings.dashboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: _getAppBarTitle(),
        onLeadingPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: const CustomDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _buildCurrentTabBody(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildCurrentTabBody() {
    if (_currentNavIndex == 3) {
      return const CallHistoryScreen();
    } else if (_currentNavIndex == 4) {
      return const ScheduleScreen();
    }
    return _buildDashboardHome();
  }

  Widget _buildDashboardHome() {
    final user = context.watch<AuthProvider>().currentUser;
    final listProvider = context.watch<CallingListProvider>();
    final username = user?.username ?? 'Swati';
    final selectedList = listProvider.selectedList;
    final details = listProvider.listDetails;

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          if (user != null) {
            await listProvider.fetchLists(user.id);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top User Greeting Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppStyles.roundedMedium,
                  boxShadow: AppStyles.buttonShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello $username',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          AppStrings.welcomeToCalley,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Content Area: Empty State vs Loaded List State
              if (selectedList == null)
                const EmptyDashboardWidget()
              else ...[
                // Calling List Card (Screen 08)
                InkWell(
                  onTap: () => CallingListModal.show(context),
                  borderRadius: AppStyles.roundedMedium,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: AppStyles.roundedMedium,
                      border: Border.all(color: AppColors.border, width: 1.2),
                      boxShadow: AppStyles.cardShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedList.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${details?.totalCalls ?? selectedList.totalCalls}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  AppStrings.calls,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // "S" Squircle Badge from Figma 08
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Donut Progress Chart with smooth sweep animation
                if (listProvider.isLoadingDetails)
                  const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  )
                else
                  DonutChartWidget(
                    pending: details?.pending ?? 28,
                    called: details?.called ?? 22,
                    rescheduled: details?.rescheduled ?? 9,
                    size: 210,
                  ),
                const SizedBox(height: 28),

                // 3 Stat Cards Row: Pending | Done | Schedule
                Row(
                  children: [
                    StatCardWidget(
                      title: AppStrings.pending,
                      count: details?.pending ?? 28,
                      accentColor: AppColors.chartPending,
                      backgroundColor: AppColors.surfaceOrange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LeadsQueueScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    StatCardWidget(
                      title: AppStrings.done,
                      count: details?.called ?? 22,
                      accentColor: AppColors.success,
                      backgroundColor: AppColors.surfaceGreen,
                      onTap: () {
                        setState(() {
                          _currentNavIndex = 3;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    StatCardWidget(
                      title: AppStrings.schedule,
                      count: details?.rescheduled ?? 9,
                      accentColor: AppColors.chartRescheduled,
                      backgroundColor: AppColors.surfacePurple,
                      onTap: () {
                        setState(() {
                          _currentNavIndex = 4;
                        });
                      },
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              // Bottom Action: WhatsApp button + Start Calling Now
              Row(
                children: [
                  const WhatsAppButton(size: 52),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: AppStrings.startCallingNow,
                      onPressed: _onStartCalling,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.badge_outlined, 'Lists', onTap: () {
                CallingListModal.show(context);
              }),
              // Center Play / Start Calling Pill Button
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _onStartCalling,
                    child: Container(
                      width: 58,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _buildNavItem(3, Icons.call_missed_outgoing_rounded, 'History'),
              _buildNavItem(4, Icons.calendar_month_outlined, 'Schedule'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {VoidCallback? onTap}) {
    final isSelected = _currentNavIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {
            setState(() {
              _currentNavIndex = index;
            });
          },
          child: SizedBox(
            height: 64,
            child: Center(
              child: AnimatedScale(
                scale: isSelected ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  size: 25,
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
