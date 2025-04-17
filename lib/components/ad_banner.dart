import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  final double height;

  const AdBanner({
    super.key,
    this.height = 50,
  });

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  String _getAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Android test ad unit ID
    } else if (Platform.isIOS) {
      final bannerId = dotenv.env['ADMOB_BANNER_ID'] ?? 'ca-app-pub-3940256099942544/2934735716';
      return kReleaseMode ? bannerId : 'ca-app-pub-3940256099942544/2934735716'; // iOS test ad unit ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void _loadAd() {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return;
    }

    final adUnitId = _getAdUnitId();

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return const SizedBox();
    }
    if (_bannerAd == null || !_isAdLoaded) {
      return SizedBox(height: widget.height);
    }

    return Container(
      height: widget.height,
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
