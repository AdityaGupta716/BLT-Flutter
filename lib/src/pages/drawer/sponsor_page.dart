import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// ============================================================================
// CONSTANTS
// ============================================================================

/// URL for BLT sponsorship page
const String kBltSupportUrl = 'https://owaspblt.org/bounties/';

/// Error message when no tier is selected
const String kNoTierSelectedError =
    "Please choose a tier before proceeding to payment.";

/// Error message when URL launch fails
const String kUrlLaunchError =
    "Could not open the sponsorship page. Please try again later.";

/// Color constants specific to the sponsor page
class SponsorColors {
  SponsorColors._();

  // Primary brand color
  static const Color primaryRed = Color(0xFFDC4654);
  static const Color primaryRedLight = Color(0xFFE8707C);
  static const Color primaryRedDark = Color(0xFFC23545);

  // Dark theme colors
  static const Color darkBackground = Color.fromRGBO(34, 22, 23, 1);
  static const Color darkPrimary = Color.fromRGBO(58, 21, 31, 1);
  static const Color darkAccent = Color.fromRGBO(126, 33, 58, 1);
  static const Color darkBorder = Color.fromRGBO(73, 40, 49, 1);
  static const Color darkCard = Color.fromRGBO(44, 28, 33, 1);

  // Text colors
  static const Color textGray = Color(0xFF737373);
  static const Color textLightGray = Color.fromARGB(255, 161, 161, 161);
  static const Color textDarkGray = Color.fromARGB(255, 60, 60, 60);
  static const Color textMediumGray = Color.fromARGB(255, 120, 120, 120);
  static const Color textWhite = Colors.white;
  static const Color textOffWhite = Color.fromARGB(255, 233, 232, 232);
  static const Color iconLightGray = Color.fromARGB(255, 212, 212, 212);
}

// ============================================================================
// MODEL
// ============================================================================

/// Represents a sponsorship tier with price and display information
class SponsorTier {
  final String title;
  final String svgAssetPath;
  final String subtitle;
  final int priceUSD;

  const SponsorTier({
    required this.title,
    required this.svgAssetPath,
    required this.subtitle,
    required this.priceUSD,
  });

  static const List<SponsorTier> availableTiers = [
    SponsorTier(
      title: "Ant Tier",
      svgAssetPath: "assets/ant.svg",
      subtitle: "Join the Colony",
      priceUSD: 10,
    ),
    SponsorTier(
      title: "Flea Tier",
      svgAssetPath: "assets/flea.svg",
      subtitle: "Leap into Action",
      priceUSD: 50,
    ),
    SponsorTier(
      title: "Scorpion Tier",
      svgAssetPath: "assets/scorpion.svg",
      subtitle: "Strike with Power",
      priceUSD: 100,
    ),
    SponsorTier(
      title: "Wasp Tier",
      svgAssetPath: "assets/wasp.svg",
      subtitle: "Rule the Hive",
      priceUSD: 500,
    ),
  ];

  String get formattedPrice => '\$$priceUSD';
  String get fullSubtitle => '$subtitle - $formattedPrice';
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

Future<bool> openBltSupport() async {
  try {
    final uri = Uri.parse(kBltSupportUrl);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      debugPrint('Failed to launch $kBltSupportUrl: launchUrl returned false');
    }
    return launched;
  } catch (e) {
    debugPrint('Error launching $kBltSupportUrl: $e');
    return false;
  }
}

// ============================================================================
// MAIN PAGE
// ============================================================================

class SponsorPage extends StatefulWidget {
  const SponsorPage({super.key});

  @override
  State<SponsorPage> createState() => _SponsorPageState();
}

class _SponsorPageState extends State<SponsorPage> {
  int? _selectedTierIndex;

  bool get _hasSelectedTier => _selectedTierIndex != null;

  void _selectTier(int index) {
    setState(() {
      _selectedTierIndex = index;
    });
  }

  void _deselectTier() {
    setState(() {
      _selectedTierIndex = null;
    });
  }

  Future<void> _handleSponsorButtonPressed(BuildContext context) async {
    if (!_hasSelectedTier) {
      _showNoTierSelectedError(context);
      return;
    }
    final success = await openBltSupport();
    if (!success && context.mounted) {
      _showUrlLaunchError(context);
    }
  }

  void _showNoTierSelectedError(BuildContext context) {
    _showErrorSnackBar(context, kNoTierSelectedError);
  }

  void _showUrlLaunchError(BuildContext context) {
    _showErrorSnackBar(context, kUrlLaunchError);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: SponsorColors.textWhite, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: SponsorColors.textWhite),
              ),
            ),
          ],
        ),
        backgroundColor: isDarkMode
            ? SponsorColors.darkAccent
            : SponsorColors.primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? SponsorColors.darkBackground
          : const Color(0xFFF8F8F8),
      appBar: _buildAppBar(isDarkMode),
      body: _buildBody(context, isDarkMode),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      elevation: 0,
      backgroundColor: isDarkMode
          ? SponsorColors.darkPrimary
          : SponsorColors.primaryRed,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: SponsorColors.textWhite,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        "Sponsor BLT",
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(
            color: SponsorColors.textWhite,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, bool isDarkMode) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDarkMode),
            _buildTierList(isDarkMode),
            const SizedBox(height: 24),
            _buildSponsorButton(context, isDarkMode),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: SponsorColors.primaryRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Choose a Tier",
                style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                    color: isDarkMode
                        ? SponsorColors.textOffWhite
                        : SponsorColors.textDarkGray,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Your sponsorship fuels groundbreaking open-source security projects.",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                color: isDarkMode
                    ? SponsorColors.textMediumGray
                    : SponsorColors.textGray,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTierList(bool isDarkMode) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: SponsorTier.availableTiers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final tier = SponsorTier.availableTiers[index];
        final isSelected = _selectedTierIndex == index;

        return GestureDetector(
          onTap: () => isSelected ? _deselectTier() : _selectTier(index),
          child: isSelected
              ? SelectedSponsorTile(tier: tier)
              : UnselectedSponsorTile(tier: tier),
        );
      },
    );
  }

  Widget _buildSponsorButton(BuildContext context, bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextButton(
        onPressed: () => _handleSponsorButtonPressed(context),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            isDarkMode ? SponsorColors.darkAccent : SponsorColors.primaryRed,
          ),
          overlayColor: WidgetStateProperty.all(
            Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.volunteer_activism_rounded,
              color: SponsorColors.textWhite,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              "Sponsor Now",
              style: GoogleFonts.ubuntu(
                textStyle: const TextStyle(
                  color: SponsorColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TILE WIDGETS
// ============================================================================

class UnselectedSponsorTile extends StatelessWidget {
  const UnselectedSponsorTile({
    super.key,
    required this.tier,
  });

  final SponsorTier tier;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: isDarkMode ? SponsorColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border(
          left: BorderSide(
            width: 4,
            color: SponsorColors.primaryRed.withOpacity(0.7),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _buildTierIcon(size, isDarkMode),
            const SizedBox(width: 14),
            _buildTierInfo(isDarkMode),
            _buildPriceBadge(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildTierIcon(Size size, bool isDarkMode) {
    return Container(
      width: size.width * 0.11,
      height: size.width * 0.11,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDarkMode
            ? SponsorColors.darkAccent.withOpacity(0.3)
            : SponsorColors.primaryRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        tier.svgAssetPath,
        colorFilter: ColorFilter.mode(
          isDarkMode ? SponsorColors.iconLightGray : SponsorColors.primaryRed,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildTierInfo(bool isDarkMode) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tier.title,
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                color: isDarkMode
                    ? SponsorColors.textOffWhite
                    : SponsorColors.textDarkGray,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            tier.subtitle,
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                color: isDarkMode
                    ? SponsorColors.textMediumGray
                    : SponsorColors.textGray,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBadge(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode
            ? SponsorColors.darkAccent.withOpacity(0.4)
            : SponsorColors.primaryRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tier.formattedPrice,
        style: GoogleFonts.ubuntu(
          textStyle: TextStyle(
            color: isDarkMode
                ? SponsorColors.textLightGray
                : SponsorColors.primaryRed,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class SelectedSponsorTile extends StatelessWidget {
  const SelectedSponsorTile({
    super.key,
    required this.tier,
  });

  final SponsorTier tier;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [SponsorColors.darkAccent, SponsorColors.darkPrimary]
              : [SponsorColors.primaryRed, SponsorColors.primaryRedDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: SponsorColors.primaryRed.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _buildTierIcon(size),
            const SizedBox(width: 14),
            Expanded(child: _buildTierInfo()),
            _buildPriceBadge(),
            const SizedBox(width: 10),
            _buildCheckmark(),
          ],
        ),
      ),
    );
  }

  Widget _buildTierIcon(Size size) {
    return Container(
      width: size.width * 0.11,
      height: size.width * 0.11,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        tier.svgAssetPath,
        colorFilter: const ColorFilter.mode(
          SponsorColors.textWhite,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildTierInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tier.title,
          style: GoogleFonts.ubuntu(
            textStyle: const TextStyle(
              color: SponsorColors.textWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          tier.subtitle,
          style: GoogleFonts.ubuntu(
            textStyle: const TextStyle(
              color: SponsorColors.textOffWhite,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tier.formattedPrice,
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(
            color: SponsorColors.textWhite,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckmark(  ) {
    return const Icon(
      Icons.check_circle_rounded,
      color: SponsorColors.textWhite,
      size: 24,
    );
  }
}
