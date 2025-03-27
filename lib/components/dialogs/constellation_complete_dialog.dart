import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/constellation_data.dart';

class ConstellationCompletionDialog extends StatefulWidget {
  final String constellationName;
  final int score;
  final Duration timeTaken;
  final VoidCallback onContinue;

  const ConstellationCompletionDialog({
    super.key,
    required this.constellationName,
    required this.score,
    required this.timeTaken,
    required this.onContinue,
  });

  @override
  State<ConstellationCompletionDialog> createState() =>
      _ConstellationCompletionDialogState();
}

class _ConstellationCompletionDialogState
    extends State<ConstellationCompletionDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ConstellationInfo _info;
  late final List<Color> _starColors;
  int _displayedScore = 0;
  double _animationValue = 0.0;

  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _info = ConstellationDataService.getConstellationInfo(
      widget.constellationName,
    );

    // Generate star colors for the header animation
    _starColors = List.generate(15, (_) {
      final baseColors = [
        Colors.white,
        Colors.blue.shade200,
        Colors.amber.shade100,
      ];
      return baseColors[_random.nextInt(baseColors.length)];
    });

    // Animate score counting up
    Future.delayed(const Duration(milliseconds: 500), () {
      const animationDuration = Duration(milliseconds: 1500);
      const fps = 30.0;
      final steps = (animationDuration.inMilliseconds / (1000 / fps)).round();
      final increment = widget.score / steps;

      int step = 0;
      _animateScore() {
        if (step < steps) {
          setState(() {
            _displayedScore = (increment * step).round();
            _animationValue += 1 / steps;
          });
          step++;
          Future.delayed(
            Duration(milliseconds: (1000 / fps).round()),
            _animateScore,
          );
        } else {
          setState(() {
            _displayedScore = widget.score;
          });
        }
      }

      _animateScore();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background stars
            Positioned.fill(
              child: _buildBackgroundStars(),
            ),

            // Main content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildTabBar(),
                Expanded(child: _buildTabContent()),
                _buildFooter(),
              ],
            ),

            // Constellation drawing overlay
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: ConstellationDrawingPainter(
                    name: widget.constellationName,
                    animationValue: _animationValue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1, 1),
            duration: 300.ms,
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildBackgroundStars() {
    return CustomPaint(
      painter: StarfieldPainter(),
      child: Container(), // Empty container for full-size CustomPaint
    );
  }

  Widget _buildHeader() {
    final size = MediaQuery.of(context).size;
    final isPhone = size.width < 600;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.2),
            Colors.purple.withOpacity(0.2),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Achievement banner
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade800, Colors.orange.shade900],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  "Constellation Completed!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().slideY(
                begin: -0.5,
                duration: 600.ms,
                curve: Curves.elasticOut,
                delay: 300.ms,
              ),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.constellationName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ).animate().slideX(
                          begin: -0.2,
                          duration: 400.ms,
                          curve: Curves.easeOut,
                        ),
                    const SizedBox(height: 4),
                    Text(
                      _info.mythology.split('.').first,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ).animate().fadeIn(
                          delay: 200.ms,
                          duration: 400.ms,
                        ),
                  ],
                ),
              ),
              if (isPhone)
                Column(
                  children: _scoreCards(),
                )
              else
                Row(
                  children: _scoreCards(),
                )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _scoreCards() {
    return [
      _buildScoreCard('Score', _displayedScore.toString()),
      const SizedBox(width: 12),
      _buildScoreCard(
        'Time',
        '${widget.timeTaken.inMinutes}:${(widget.timeTaken.inSeconds % 60).toString().padLeft(2, '0')}',
      ),
    ];
  }

  Widget _buildScoreCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.easeOut,
          delay: label == 'Score' ? 500.ms : 700.ms,
        );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.03),
            Colors.transparent,
          ],
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Cultural History'),
          Tab(text: 'Star Guide'),
        ],
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.blue.shade400,
              width: 2,
            ),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(),
        _buildCulturalTab(),
        _buildStarGuideTab(),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoGrid(),
          const SizedBox(height: 16),
          _buildFunFactsSection(),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
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
          _info.brightestStar,
          Icons.star,
          Colors.amber,
          delay: 0,
        ),
        _buildInfoCard(
          'Best Viewing',
          _info.bestViewing,
          Icons.visibility,
          Colors.blue,
          delay: 100,
        ),
        _buildInfoCard(
          'Distance',
          _info.distance,
          Icons.route,
          Colors.green,
          delay: 200,
        ),
        _buildInfoCard(
          'Magnitude',
          _info.magnitude,
          Icons.brightness_7,
          Colors.orange,
          delay: 300,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      String title, String content, IconData icon, Color color,
      {int delay = 0}) {
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

  Widget _buildFunFactsSection() {
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
          ...List.generate(_info.funFacts.length, (index) {
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
                      _info.funFacts[index],
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

  Widget _buildCulturalTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _info.culturalSignificance.length,
      itemBuilder: (context, index) {
        final culture = _info.culturalSignificance[index];
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
                          color: _getCultureColor(culture.culture)
                              .withOpacity(0.3),
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

  Widget _buildStarGuideTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildObservationTips(),
        const SizedBox(height: 16),
        _buildMainStars(),
      ],
    );
  }

  Widget _buildObservationTips() {
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
          ...List.generate(_info.observationTips.length, (index) {
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
                      _info.observationTips[index],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fade(
                  delay: Duration(milliseconds: index * 100),
                  duration: 300.ms,
                );
          }),
        ],
      ),
    ).animate().fade(duration: 400.ms).slideY(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
        );
  }

  Widget _buildMainStars() {
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
          ...List.generate(_info.mainStars.length, (index) {
            final star = _info.mainStars[index];
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
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
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
                  _buildStarDetailRow(
                      'Magnitude', star.magnitude, Colors.green),
                  _buildStarDetailRow('Distance', star.distance, Colors.blue),
                  _buildStarDetailRow(
                      'Spectral Type', star.spectralType, Colors.purple),
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

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.02),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.swipe,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Swipe or tap tabs to learn more',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: widget.onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Continue',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ).animate().scale(
                delay: 1000.ms,
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),
        ],
      ),
    );
  }
}

class StarfieldPainter extends CustomPainter {
  final _random = math.Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    final starCount = 150;

    for (int i = 0; i < starCount; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final radius = _random.nextDouble() * 1.5 + 0.5;
      final opacity = _random.nextDouble() * 0.5 + 0.2;

      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), radius, paint);

      // Add glow to random stars
      if (_random.nextDouble() < 0.2) {
        final glowPaint = Paint()
          ..color = Colors.white.withOpacity(opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

        canvas.drawCircle(Offset(x, y), radius * 3, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConstellationDrawingPainter extends CustomPainter {
  final String name;
  final double animationValue;
  final _random = math.Random();

  ConstellationDrawingPainter({
    required this.name,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Simple representations of constellations
    // In a real app, you'd have more detailed constellation data

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final maxRadius = math.min(size.width, size.height) * 0.4;

    final List<Offset> points = [];
    final List<List<int>> connections = [];

    // Create different constellation patterns based on name
    switch (name) {
      case 'Triangulum':
        points.addAll([
          Offset(centerX - maxRadius * 0.4, centerY + maxRadius * 0.2),
          Offset(centerX + maxRadius * 0.4, centerY + maxRadius * 0.2),
          Offset(centerX, centerY - maxRadius * 0.4),
        ]);
        connections.addAll([
          [0, 1],
          [1, 2],
          [2, 0]
        ]);
        break;
      case 'Cassiopeia':
        points.addAll([
          Offset(centerX - maxRadius * 0.6, centerY - maxRadius * 0.1),
          Offset(centerX - maxRadius * 0.3, centerY - maxRadius * 0.3),
          Offset(centerX, centerY - maxRadius * 0.1),
          Offset(centerX + maxRadius * 0.3, centerY - maxRadius * 0.3),
          Offset(centerX + maxRadius * 0.6, centerY - maxRadius * 0.1),
        ]);
        connections.addAll([
          [0, 1],
          [1, 2],
          [2, 3],
          [3, 4]
        ]);
        break;
      case 'Ursa Minor':
        points.addAll([
          Offset(centerX, centerY - maxRadius * 0.5), // Polaris
          Offset(centerX - maxRadius * 0.1, centerY - maxRadius * 0.3),
          Offset(centerX - maxRadius * 0.2, centerY - maxRadius * 0.1),
          Offset(centerX - maxRadius * 0.1, centerY + maxRadius * 0.1),
          Offset(centerX + maxRadius * 0.2, centerY + maxRadius * 0.3),
          Offset(centerX + maxRadius * 0.4, centerY + maxRadius * 0.2),
          Offset(centerX + maxRadius * 0.5, centerY + maxRadius * 0.4),
        ]);
        connections.addAll([
          [0, 1],
          [1, 2],
          [2, 3],
          [3, 4],
          [4, 5],
          [5, 6]
        ]);
        break;
      default:
        // Generic constellation with random points for other names
        final pointCount = 6 + _random.nextInt(5);

        for (int i = 0; i < pointCount; i++) {
          final angle = i * (2 * math.pi / pointCount);
          final radius = maxRadius * (0.5 + _random.nextDouble() * 0.5);

          points.add(Offset(
            centerX + math.cos(angle) * radius,
            centerY + math.sin(angle) * radius,
          ));
        }

        // Create connections in a circle
        for (int i = 0; i < pointCount; i++) {
          connections.add([i, (i + 1) % pointCount]);
        }
    }

    // Draw connections
    final progressValue = animationValue.clamp(0.0, 1.0);
    final connectionCount = (progressValue * connections.length).floor();

    for (int i = 0; i < connectionCount; i++) {
      final connection = connections[i];
      final start = points[connection[0]];
      final end = points[connection[1]];

      // Calculate partial connection for the last line being drawn
      Offset drawEnd = end;
      if (i == connectionCount - 1 && connectionCount < connections.length) {
        final partialProgress = (progressValue * connections.length) % 1.0;
        drawEnd = Offset(
          start.dx + (end.dx - start.dx) * partialProgress,
          start.dy + (end.dy - start.dy) * partialProgress,
        );
      }

      // Draw connection line
      final linePaint = Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawLine(start, drawEnd, linePaint);
    }

    // Draw constellation points
    for (int i = 0; i < points.length; i++) {
      if (progressValue < (i / points.length)) continue;

      final point = points[i];

      // Glow effect
      final glowPaint = Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(point, 6, glowPaint);

      // Star point
      final starPaint = Paint()
        ..color = Colors.white.withOpacity(0.5)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(point, 2, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ConstellationDrawingPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
