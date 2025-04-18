import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/background_gradient.dart';
import '../core/game_theme.dart';
import '../core/sound_controller.dart';
import '../data/constellation_data.dart';
import '../provider/database_provider.dart';
import '../provider/theme_provider.dart';
import '../core/router.dart';
import '../components/toast.dart';

class ConstellationManualScreen extends StatefulHookConsumerWidget {
  const ConstellationManualScreen({super.key});

  @override
  ConsumerState<ConstellationManualScreen> createState() => _ConstellationManualScreenState();
}

class _ConstellationManualScreenState extends ConsumerState<ConstellationManualScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _scrollController;
  late final AnimationController _starsController;

  int _selectedConstellation = 0;
  bool _showConstellationLines = true;
  late ThemeConfig _themeConfig;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _starsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat(reverse: false);

    // Play constellation sound effect
    SoundController().playSound('connect');

    // Set initial theme
    _themeConfig = ref.read(gameThemeProvider).config;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWideScreen = size.width > 600;
    final theme = ref.watch(gameThemeProvider);
    final constellations = ConstellationDataService.constellations.values.toList();
    final selectedInfo = constellations[_selectedConstellation];

    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Stack(
            children: [
              // Animated stars background
              CustomPaint(
                size: Size.infinite,
                painter: StarfieldPainter(animation: _starsController),
              ),

              // Main content
              Column(
                children: [
                  _buildAppBar(context),
                  if (isWideScreen)
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left panel - constellation list
                          Container(
                            width: 280,
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: _buildConstellationList(constellations),
                          ),

                          // Right panel - details
                          Expanded(
                            child: _buildDetailPanel(selectedInfo, isWideScreen),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          // Constellation visualization
                          SizedBox(
                            height: 200,
                            child: _buildConstellationVisualization(selectedInfo),
                          ),

                          // Carousel for mobile
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: constellations.length,
                              itemBuilder: (context, index) {
                                return _buildConstellationCard(constellations[index], index, true);
                              },
                            ),
                          ),

                          // Details tabs
                          Expanded(
                            child: _buildDetailPanel(selectedInfo, isWideScreen),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showConstellationLines = !_showConstellationLines;
          });
          showToast(context, _showConstellationLines ? "Constellation lines shown" : "Constellation lines hidden",
              type: ToastType.info);
        },
        backgroundColor: _themeConfig.activeStarColor,
        child: Icon(
          _showConstellationLines ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.6),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              SoundController().playSound('click');
              Navigator.of(context).pop();
            },
          ),
          const Text(
            "Constellation Manual",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              SoundController().playSound('click');
              _showInfoDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConstellationList(List<ConstellationInfo> constellations) {
    return ListView.builder(
      itemCount: constellations.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return _buildConstellationCard(constellations[index], index, false);
      },
    );
  }

  Widget _buildConstellationCard(ConstellationInfo info, int index, bool isHorizontal) {
    final isSelected = _selectedConstellation == index;
    final theme = ref.watch(gameThemeProvider);

    return GestureDetector(
      onTap: () {
        SoundController().playSound('click');
        setState(() {
          _selectedConstellation = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: isHorizontal ? 8 : 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    _themeConfig.activeStarColor.withOpacity(0.3),
                    _themeConfig.activeStarColor.withOpacity(0.1),
                  ]
                : [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _themeConfig.activeStarColor.withOpacity(0.5) : Colors.white.withOpacity(0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: isHorizontal
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    info.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 2,
                      width: 24,
                      decoration: BoxDecoration(
                        color: _themeConfig.activeStarColor,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              )
            : Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black45,
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        color: isSelected ? _themeConfig.activeStarColor : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          info.bestViewing,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDetailPanel(ConstellationInfo info, bool isWideScreen) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          // Constellation visualization (only for wide screen)
          if (isWideScreen)
            SizedBox(
              height: 300,
              child: _buildConstellationVisualization(info),
            ),

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Overview"),
              Tab(text: "Mythology"),
              Tab(text: "Stars"),
              Tab(text: "Cultural"),
            ],
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _themeConfig.activeStarColor,
                  width: 2,
                ),
              ),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.5),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(info),
                _buildMythologyTab(info),
                _buildStarsTab(info),
                _buildCulturalTab(info),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConstellationVisualization(ConstellationInfo info) {
    final theme = ref.watch(gameThemeProvider);

    return Stack(
      children: [
        // Title overlay
        Positioned(
          left: 16,
          top: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star_outline,
                  color: _themeConfig.activeStarColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  info.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Constellation visualization
        Center(
          child: CustomPaint(
            painter: ConstellationPainter(
              info: info,
              showLines: _showConstellationLines,
              themeConfig: _themeConfig,
            ),
            size: const Size(300, 250),
          ),
        ),

        // Star count indicator
        Positioned(
          right: 16,
          bottom: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  "${info.mainStars.length} stars",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildOverviewTab(ConstellationInfo info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewHeader(info),
          const SizedBox(height: 16),
          _buildInfoGrid(info),
          const SizedBox(height: 24),
          _buildObservationTips(info),
          const SizedBox(height: 24),
          _buildFunFactsSection(info),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOverviewHeader(ConstellationInfo info) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.2),
            Colors.purple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "INTRODUCTION",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            info.mythology.split('.').take(2).join('.') + ".",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildInfoGrid(ConstellationInfo info) {
    final size = MediaQuery.of(context).size;
    final isPhone = size.width < 600;
    return GridView.count(
      crossAxisCount: isPhone ? 1 : 2,
      shrinkWrap: true,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: isPhone ? 10 / 3 : 2.0,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildInfoCard(
          'Brightest Star',
          info.brightestStar,
          Icons.star,
          Colors.amber,
          delay: 0,
        ),
        _buildInfoCard(
          'Best Viewing',
          info.bestViewing,
          Icons.visibility,
          Colors.blue,
          delay: 100,
        ),
        _buildInfoCard(
          'Distance',
          info.distance,
          Icons.route,
          Colors.green,
          delay: 200,
        ),
        _buildInfoCard(
          'Magnitude',
          info.magnitude,
          Icons.brightness_7,
          Colors.orange,
          delay: 300,
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color, {int delay = 0}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            Colors.black.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fade(
          delay: Duration(milliseconds: delay),
          duration: 400.ms,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          delay: Duration(milliseconds: delay),
          duration: 400.ms,
        );
  }

  Widget _buildObservationTips(ConstellationInfo info) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.lightBlue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Observation Tips',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(info.observationTips.length, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      info.observationTips[index],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fade(
                  delay: Duration(milliseconds: index * 100 + 400),
                  duration: 300.ms,
                );
          }),
        ],
      ),
    ).animate().fade(delay: 300.ms, duration: 400.ms).slideY(
          begin: 0.1,
          end: 0,
          delay: 300.ms,
          duration: 400.ms,
        );
  }

  Widget _buildFunFactsSection(ConstellationInfo info) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.yellow, size: 20),
              SizedBox(width: 8),
              Text(
                'Fun Facts',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(info.funFacts.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      info.funFacts[index],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fade(
                  delay: Duration(milliseconds: 400 + index * 100),
                  duration: 400.ms,
                )
                .slideX(
                  begin: 0.1,
                  end: 0,
                  delay: Duration(milliseconds: 400 + index * 100),
                  duration: 400.ms,
                );
          }),
        ],
      ),
    ).animate().fade(
          delay: 400.ms,
          duration: 400.ms,
        );
  }

  Widget _buildMythologyTab(ConstellationInfo info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMythologyHeader(info),
          const SizedBox(height: 24),
          _buildMythologyStory(info),
          const SizedBox(height: 24),
          if (info.culturalSignificance.isNotEmpty) _buildMythologyConnections(info),
        ],
      ),
    );
  }

  Widget _buildMythologyHeader(ConstellationInfo info) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withOpacity(0.2),
            Colors.indigo.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "MYTHOLOGY",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "The Story Behind the Stars",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Across different cultures and time periods, people have created stories to explain patterns in the night sky.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMythologyStory(ConstellationInfo info) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.auto_stories,
                color: Colors.amber,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "The Legend",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.white24,
            height: 24,
          ),
          Text(
            info.mythology,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildMythologyConnections(ConstellationInfo info) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.withOpacity(0.1),
            Colors.deepOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.connecting_airports,
                color: Colors.amber,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Connected Myths',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(info.culturalSignificance.take(3).length, (index) {
            final culture = info.culturalSignificance[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getCultureIcon(culture.culture),
                        size: 16,
                        color: _getCultureColor(culture.culture),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        culture.culture,
                        style: TextStyle(
                          color: _getCultureColor(culture.culture),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.white24,
                    height: 16,
                  ),
                  Text(
                    culture.interpretation,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(
                  delay: Duration(milliseconds: 300 + index * 150),
                  duration: 400.ms,
                );
          }),
        ],
      ),
    ).animate().fadeIn(
          delay: 400.ms,
          duration: 400.ms,
        );
  }

  IconData _getCultureIcon(String culture) {
    switch (culture.toLowerCase()) {
      case 'greek':
      case 'ancient greek':
        return Icons.architecture;
      case 'egyptian':
        return Icons.temple_hindu;
      case 'native american':
        return Icons.filter_hdr;
      case 'chinese':
        return Icons.landscape;
      case 'babylonian':
        return Icons.domain;
      default:
        return Icons.public;
    }
  }

  Color _getCultureColor(String culture) {
    switch (culture.toLowerCase()) {
      case 'greek':
      case 'ancient greek':
        return Colors.blue;
      case 'egyptian':
        return Colors.amber;
      case 'native american':
        return Colors.green;
      case 'chinese':
        return Colors.red;
      case 'babylonian':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  Widget _buildStarsTab(ConstellationInfo info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStarsBanner(),
          const SizedBox(height: 24),
          _buildStarList(info),
          const SizedBox(height: 24),
          _buildStarComposition(info),
        ],
      ),
    );
  }

  Widget _buildStarsBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.withOpacity(0.2),
            Colors.orange.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "ASTROPHYSICS",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Star Composition",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Stars in a constellation aren't physically related - they appear close from Earth but can be at vastly different distances.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStarList(ConstellationInfo info) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.star_outline,
                color: Colors.amber,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Main Stars',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(info.mainStars.length, (index) {
            final star = info.mainStars[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.amber.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: _getStarColor(star.spectralType),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        star.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${star.designation})',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildStarDetailRow('Magnitude', star.magnitude, Colors.green),
                  _buildStarDetailRow('Distance', star.distance, Colors.blue),
                  _buildStarDetailRow('Spectral Type', star.spectralType, Colors.purple),
                ],
              ),
            ).animate().fade(
                  delay: Duration(milliseconds: 200 + index * 150),
                  duration: 400.ms,
                );
          }),
        ],
      ),
    )
        .animate()
        .fade(
          delay: 200.ms,
          duration: 400.ms,
        )
        .slideY(
          begin: 0.1,
          end: 0,
          delay: 200.ms,
          duration: 400.ms,
        );
  }

  Color _getStarColor(String spectralType) {
    if (spectralType.startsWith('O')) return Colors.blue;
    if (spectralType.startsWith('B')) return Colors.blue.shade200;
    if (spectralType.startsWith('A')) return Colors.white;
    if (spectralType.startsWith('F')) return Colors.yellow.shade100;
    if (spectralType.startsWith('G')) return Colors.yellow;
    if (spectralType.startsWith('K')) return Colors.orange;
    if (spectralType.startsWith('M')) return Colors.red;
    return Colors.white;
  }

  Widget _buildStarDetailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarComposition(ConstellationInfo info) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.indigo.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.science,
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Astrophysical Properties',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildAstroProperty(
                  "Star Types",
                  "Mixture of giant stars and main sequence stars",
                  Icons.category,
                  Colors.amber,
                ),
                const Divider(color: Colors.white12, height: 16),
                _buildAstroProperty(
                  "Average Temperature",
                  "Varies from 3,000K (red) to 20,000K (blue)",
                  Icons.thermostat,
                  Colors.orange,
                ),
                const Divider(color: Colors.white12, height: 16),
                _buildAstroProperty(
                  "Age Range",
                  "From young stars (millions of years) to ancient stars (billions of years)",
                  Icons.hourglass_empty,
                  Colors.green,
                ),
                const Divider(color: Colors.white12, height: 16),
                _buildAstroProperty(
                  "Stellar Evolution",
                  "Contains stars at various life stages including main sequence and giants",
                  Icons.sync,
                  Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildAstroProperty(String title, String value, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCulturalTab(ConstellationInfo info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCulturalHeader(),
          const SizedBox(height: 24),
          _buildCulturalSignificanceList(info),
          const SizedBox(height: 24),
          _buildHistoricalObservations(),
        ],
      ),
    );
  }

  Widget _buildCulturalHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.teal.withOpacity(0.2),
            Colors.indigo.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "CULTURAL SIGNIFICANCE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Across Civilizations",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Constellations have guided navigation, influenced religion, and inspired art across many cultures throughout history.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildCulturalSignificanceList(ConstellationInfo info) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: info.culturalSignificance.length,
      itemBuilder: (context, index) {
        final culture = info.culturalSignificance[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.indigo.withOpacity(0.1),
                Colors.indigo.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getCultureIcon(culture.culture),
                    size: 20,
                    color: _getCultureColor(culture.culture),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    culture.culture,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: _getCultureColor(culture.culture).withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                culture.interpretation,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fade(
              delay: Duration(milliseconds: index * 200),
              duration: 400.ms,
            )
            .slideY(
              begin: 0.2,
              end: 0,
              delay: Duration(milliseconds: index * 200),
              duration: 400.ms,
            );
      },
    );
  }

  Widget _buildHistoricalObservations() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.brown.withOpacity(0.1),
            Colors.amber.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.history_edu,
                color: Colors.amber,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Historical Significance',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildHistoryItem(
                  "Navigation",
                  "Used by sailors and travelers for thousands of years to navigate seas and deserts",
                  Icons.explore,
                  Colors.blue,
                ),
                const Divider(color: Colors.white12, height: 16),
                _buildHistoryItem(
                  "Agriculture",
                  "Helped farmers track seasons and know when to plant and harvest crops",
                  Icons.grass,
                  Colors.green,
                ),
                const Divider(color: Colors.white12, height: 16),
                _buildHistoryItem(
                  "Timekeeping",
                  "Early civilizations used star patterns to mark time and create calendars",
                  Icons.schedule,
                  Colors.amber,
                ),
                const Divider(color: Colors.white12, height: 16),
                _buildHistoryItem(
                  "Religious Ceremonies",
                  "Many ancient temples and monuments were aligned with stars for ceremonies and rituals",
                  Icons.temple_hindu,
                  Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildHistoryItem(String title, String value, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "About the Constellation Manual",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "This manual provides detailed information about the constellations in the night sky. Learn about their mythology, star composition, and cultural significance across different civilizations.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              Text(
                "• View detailed star maps and constellation patterns\n• Learn historical and mythological stories\n• Discover scientific facts about the stars\n• Explore cultural interpretations from different civilizations",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConstellationPainter extends CustomPainter {
  final ConstellationInfo info;
  final bool showLines;
  final ThemeConfig themeConfig;

  ConstellationPainter({
    required this.info,
    required this.showLines,
    required this.themeConfig,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final level = ConstellationDataService.levels.firstWhere(
      (level) => level.name == info.name,
    );

    print("Level: ${level.name}");

    final stars = level.starPositions.map((pos) {
      return Offset(
        pos.dx * size.width,
        pos.dy * size.height,
      );
    }).toList();
    final starCount = stars.length;
    final connections = level.connections;

    // Draw the connections first (if enabled)
    if (showLines) {
      final linePaint = Paint()
        ..color = themeConfig.lineColor
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      for (final connection in connections) {
        if (connection[0] < starCount && connection[1] < starCount) {
          canvas.drawLine(stars[connection[0]], stars[connection[1]], linePaint);
        }
      }
    }

    for (int i = 0; i < stars.length; i++) {
      final starGlowPaint = Paint()
        ..color = (i < starCount ? themeConfig.activeStarColor : themeConfig.starColor)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      final glowSize = i < starCount ? 2.5 : 2.5;
      canvas.drawCircle(stars[i], glowSize, starGlowPaint);

      // Star core
      final starPaint = Paint()..color = (i < starCount ? themeConfig.activeStarColor : themeConfig.starColor);

      canvas.drawCircle(stars[i], 2.0, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StarfieldPainter extends CustomPainter {
  final AnimationController animation;
  final List<Offset> stars = [];
  final List<double> starSizes = [];
  final List<double> twinklePhases = [];

  StarfieldPainter({required this.animation}) : super(repaint: animation) {
    // Generate random stars
    final random = math.Random(42);
    for (int i = 0; i < 100; i++) {
      stars.add(Offset(random.nextDouble(), random.nextDouble()));
      starSizes.add(0.5 + random.nextDouble() * 1.5);
      twinklePhases.add(random.nextDouble() * math.pi * 2);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < stars.length; i++) {
      final position = Offset(
        stars[i].dx * size.width,
        stars[i].dy * size.height,
      );

      // Twinkle effect
      final twinkle = 0.5 + (math.sin(animation.value * math.pi * 2 + twinklePhases[i]) + 1) * 0.25;

      final paint = Paint()
        ..color = Colors.white.withOpacity(twinkle)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(position, starSizes[i], paint);

      // Add glow to some stars
      if (starSizes[i] > 1.2) {
        final glowPaint = Paint()
          ..color = Colors.white.withOpacity(twinkle * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

        canvas.drawCircle(position, starSizes[i] * 3, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
