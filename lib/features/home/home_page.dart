import 'package:flutter/material.dart';

import 'widgets/community_links_section.dart';
import 'widgets/gallery_preview_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/recent_events_section.dart';
import 'widgets/speaker_cta_section.dart';
import 'widgets/sponsors_section.dart';
import 'widgets/stats_section.dart';
import 'widgets/upcoming_event_section.dart';
import 'widgets/what_we_do_section.dart';
import 'widgets/why_join_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HeroSection(),
        StatsSection(),
        WhatWeDoSection(),
        UpcomingEventSection(),
        WhyJoinSection(),
        RecentEventsSection(),
        SpeakerCtaSection(),
        GalleryPreviewSection(),
        SponsorsSection(),
        CommunityLinksSection(),
      ],
    );
  }
}
