import 'package:blt/src/pages/drawer/drawer_imports.dart';,,
import 'package:url_launcher/url_launcher.dart';

const String kBltSupportUrl = 'https://owaspblt.org/bounties/';

Future<void> openBltSupport() async {
  final uri = Uri.parse(kBltSupportUrl);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class SponsorPage extends StatefulWidget {
  const SponsorPage({super.key});

  @override
  State<SponsorPage> createState() => _SponsorPageState();
}

class _SponsorPageState extends State<SponsorPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  Map<String, dynamic>? intent;
  int selected = -1;

  final List<dynamic> tiers = [
    {
      "title": "Ant Tier",
      "svg": "assets/ant.svg",
      "subtitle": "Join the Colony - \\$10",
      "option": 0,
    },
    {
      "title": "Flea Tier",
      "svg": "assets/flea.svg",
      "subtitle": "Leap into Action - \\$50",
      "option": 2,
    },
    {
      "title": "Scorpion Tier",
      "svg": "assets/scorpion.svg",
      "subtitle": "Strike with Power - \\$100",
      "option": 3,
    },
    {
      "title": "Wasp Tier",
      "svg": "assets/wasp.svg",
      "subtitle": "Rule the Hive - \\$500",
      "option": 4,
    }
  ];

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color.fromRGBO(34, 22, 23, 1)
          : Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? const Color.fromRGBO(58, 21, 31, 1)
            : const Color(0xFFDC4654),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Sponsor BLT",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Text(
                  "Sponsor BLT",
                  style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                      color: Color(0xFF737373),
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Text(
                  "Join us in driving innovation and excellence in the tech community. Your sponsorship helps fuel groundbreaking projects, ensuring we continue to develop and share cutting-edge solutions with the world.",
                  style: GoogleFonts.aBeeZee(
                    textStyle: const TextStyle(
                      color: Color(0xFF737373),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (selected == index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = -1;
                        });
                      },
                      child: SelectedSponsorTile(sponsor: tiers[index]),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = index;
                      });
                    },
                    child: UnselectedSponsorTile(sponsor: tiers[index]),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: tiers.length,
              ),
              const SizedBox(height: 30),
              TextButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.volunteer_activism,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Sponsor",
                        style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(
                    isDarkMode
                        ? const Color.fromRGBO(126, 33, 58, 1)
                        : const Color(0xFFDC4654),
                  ),
                ),
                onPressed: () {
                  if (selected == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Please choose a tier before proceeding to payment.",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: isDarkMode
                            ? const Color.fromRGBO(126, 33, 58, 1)
                            : const Color(0xFFDC4654),
                      ),
                    );
                  } else {
                    openBltSupport();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UnselectedSponsorTile extends StatelessWidget {
  const UnselectedSponsorTile({super.key, this.sponsor});
  final dynamic sponsor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1.5,
          color: isDarkMode
              ? const Color.fromRGBO(73, 40, 49, 1)
              : const Color(0xFFDC4654),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: size.width * 0.4,
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.12,
                height: size.width * 0.12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SvgPicture.asset(
                    sponsor["svg"],
                    colorFilter: isDarkMode
                        ? const ColorFilter.mode(
                            Color.fromARGB(255, 212, 212, 212),
                            BlendMode.srcIn,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sponsor["title"],
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                        color: isDarkMode
                            ? const Color.fromARGB(255, 161, 161, 161)
                            : const Color.fromARGB(255, 88, 88, 88),
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Text(
                    sponsor["subtitle"],
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                        color: !isDarkMode
                            ? const Color.fromARGB(255, 161, 161, 161)
                            : const Color.fromARGB(255, 98, 98, 98),
                        fontSize: 16,
                      ),
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
}

class SelectedSponsorTile extends StatelessWidget {
  const SelectedSponsorTile({super.key, this.sponsor});
  final dynamic sponsor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color.fromRGBO(58, 21, 31, 1)
            : const Color(0xFFDC4654),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: size.width * 0.12,
                  height: size.width * 0.12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SvgPicture.asset(
                      sponsor["svg"],
                      colorFilter: isDarkMode
                          ? const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sponsor["title"],
                      style: GoogleFonts.ubuntu(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Text(
                      sponsor["subtitle"],
                      style: GoogleFonts.ubuntu(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 233, 232, 232),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.verified,
              color: isDarkMode
                  ? const Color.fromARGB(255, 161, 161, 161)
                  : Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
