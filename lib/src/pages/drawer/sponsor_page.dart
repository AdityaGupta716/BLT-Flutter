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

/// App-wide color constants for consistent theming
class AppColors {
  AppColors._();

  // Primary brand color
  static const Color primaryRed = Color(0xFFDC4654);

  // Dark theme colors
  static const Color darkBackground = Color.fromRGBO(34, 22, 23, 1);
  static const Color darkPrimary = Color.fromRGBO(58, 21, 31, 1);
  static const Color darkAccent = Color.fromRGBO(126, 33, 58, 1);
  static const Color darkBorder = Color.fromRGBO(73, 40, 49, 1);

  // Text colors
  static const Color textGray = Color(0xFF737373);
  static const Color textLightGray = Color.fromARGB(255, 161, 161, 161);
  static const Color textDarkGray = Color.fromARGB(255, 88, 88, 88);
  static const Color textMediumGray = Color.fromARGB(255, 98, 98, 98);
  static const Color textWhite = Colors.white;
  static const Color textOffWhite = Color.fromARGB(255, 233, 232, 232);
  static const Color iconLightGray = Color.fromARGB(255, 212, 212, 212);
}

// ============================================================================
// MODEL
// ============================================================================

/// Represents a sponsorship tier with price and display information
class SponsorTier {
  /// Display title of the tier (e.g., "Ant Tier")
  final String title;

  /// Path to SVG asset for tier icon
  final String svgAssetPath;

  /// Subtitle describing the tier
  final String subtitle;

  /// Price in USD
  final int priceUSD;

  const SponsorTier({
    required this.title,
    required this.svgAssetPath,
    required this.subtitle,
    required this.priceUSD,
  });

  /// Available sponsorship tiers
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

  /// Formatted price string (e.g., "$10")
  String get formattedPrice => '\$$priceUSD';

  /// Full subtitle with price (e.g., "Join the Colony - $10")
  String get fullSubtitle => '$subtitle - $formattedPrice';
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/// Opens the BLT sponsorship page in an external browser.
///
/// Returns `true` if the URL was successfully launched, `false` otherwise.
/// This includes both exceptions and cases where `launchUrl` returns `false`.
Future<bool> openBltSupport() async {
  try {
    final uri = Uri.parse(kBltSupportUrl);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      debugPrint(
        'Failed to launch $kBltSupportUrl: launchUrl returned false',
      );
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

/// Page for displaying sponsorship tiers and handling tier selection
class SponsorPage extends StatefulWidget {
  const SponsorPage({super.key});

  @override
  State<SponsorPage> createState() => _SponsorPageState();
}

class _SponsorPageState extends State<SponsorPage> {
  /// Index of currently selected tier, null if no tier is selected
  int? _selectedTierIndex;

  /// Whether a tier has been selected
  bool get _hasSelectedTier => _selectedTierIndex != null;

  /// Select a tier by index
  void _selectTier(int index) {
    setState(() {
      _selectedTierIndex = index;
    });
  }

  /// Deselect the currently selected tier
  void _deselectTier() {
    setState(() {
      _selectedTierIndex = null;
    });
  }

  /// Handle sponsor button press - validates selection and opens URL
  Future<void> _handleSponsorButtonPressed(BuildContext context) async {
    // Validate tier selection before proceeding
    if (!_hasSelectedTier) {
      _showNoTierSelectedError(context);
      return;
    }

    // Attempt to open the sponsorship URL
    final success = await openBltSupport();

    // Show error if URL launch failed and widget is still mounted
    if (!success && context.mounted) {
      _showUrlLaunchError(context);
    }
  }

  /// Show error when no tier is selected
  void _showNoTierSelectedError(BuildContext context) {
    _showErrorSnackBar(context, kNoTierSelectedError);
  }

  /// Show error when URL launch fails
  void _showUrlLaunchError(BuildContext context) {
    _showErrorSnackBar(context, kUrlLaunchError);
  }

  /// Display an error message in a SnackBar
  void _showErrorSnackBar(BuildContext context, String message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textWhite),
        ),
        backgroundColor: isDarkMode
            ? AppColors.darkAccent
            : AppColors.primaryRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : Theme.of(context).canvasColor,
      appBar: _buildAppBar(isDarkMode),
      body: _buildBody(context, isDarkMode),
    );
  }

  /// Build the app bar
  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: isDarkMode
          ? AppColors.darkPrimary
          : AppColors.primaryRed,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textWhite,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        "Sponsor BLT",
        style: TextStyle(
          color: AppColors.textWhite,
          fontSize: 20,
        ),
      ),
    );
  }

  /// Build the page body
  Widget _buildBody(BuildContext context, bool isDarkMode) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildIntroText(),
            const SizedBox(height: 10),
            _buildTierList(isDarkMode),
            const SizedBox(height: 30),
            _buildSponsorButton(context, isDarkMode),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Build the page header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Text(
        "Sponsor BLT",
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(
            color: AppColors.textGray,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Build the introductory text
  Widget _buildIntroText() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: Text(
        "Join us in driving innovation and excellence in the tech community. "
        "Your sponsorship helps fuel groundbreaking projects, ensuring we continue "
        "to develop and share cutting-edge solutions with the world.",
        style: GoogleFonts.aBeeZee(
          textStyle: const TextStyle(
            color: AppColors.textGray,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  /// Build the list of sponsorship tiers
  Widget _buildTierList(bool isDarkMode) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: SponsorTier.availableTiers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
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

  /// Build the sponsor button
  Widget _buildSponsorButton(BuildContext context, bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => _handleSponsorButtonPressed(context),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            isDarkMode ? AppColors.darkAccent : AppColors.primaryRed,
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.all(16.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.volunteer_activism,
              color: AppColors.textWhite,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              "Sponsor",
              style: GoogleFonts.ubuntu(
                textStyle: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 22,
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

/// Widget for displaying an unselected sponsor tier
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1.5,
          color: isDarkMode ? AppColors.darkBorder : AppColors.primaryRed,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildTierIcon(size, isDarkMode),
            const SizedBox(width: 10),
            _buildTierInfo(isDarkMode),
          ],
        ),
      ),
    );
  }

  /// Build the tier icon
  Widget _buildTierIcon(Size size, bool isDarkMode) {
    return SizedBox(
      width: size.width * 0.12,
      height: size.width * 0.12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.asset(
          tier.svgAssetPath,
          colorFilter: isDarkMode
              ? const ColorFilter.mode(
                  AppColors.iconLightGray,
                  BlendMode.srcIn,
                )
              : null,
        ),
      ),
    );
  }

  /// Build the tier information text
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
                    ? AppColors.textLightGray
                    : AppColors.textDarkGray,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            tier.fullSubtitle,
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                color: isDarkMode
                    ? AppColors.textMediumGray
                    : AppColors.textLightGray,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying a selected sponsor tier
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
        color: isDarkMode ? AppColors.darkPrimary : AppColors.primaryRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildTierIcon(size),
                const SizedBox(width: 10),
                _buildTierInfo(),
              ],
            ),
            _buildCheckmark(isDarkMode),
          ],
        ),
      ),
    );
  }

  /// Build the tier icon
  Widget _buildTierIcon(Size size) {
    return SizedBox(
      width: size.width * 0.12,
      height: size.width * 0.12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.asset(
          tier.svgAssetPath,
          colorFilter: const ColorFilter.mode(
            AppColors.textWhite,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  /// Build the tier information text
  Widget _buildTierInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tier.title,
          style: GoogleFonts.ubuntu(
            textStyle: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          tier.fullSubtitle,
          style: GoogleFonts.ubuntu(
            textStyle: const TextStyle(
              color: AppColors.textOffWhite,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Build the checkmark icon
  Widget _buildCheckmark(bool isDarkMode) {
    return Icon(
      Icons.verified,
      color: isDarkMode ? AppColors.textLightGray : AppColors.textWhite,
      size: 30,
    );
  }
}
