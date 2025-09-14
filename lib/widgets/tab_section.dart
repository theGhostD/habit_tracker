import 'package:flutter/material.dart';

class TabSection extends StatefulWidget {
  const TabSection({super.key});

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> {
  List<String> tabList = ['All', 'Community Service', 'Creativity', 'Digital'];
  String selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabList
            .map(
              (tabValue) => Container(
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: selectedTab == tabValue
                      ? Colors.blue[200]
                      : const Color.fromARGB(15, 0, 0, 0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = tabValue;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      tabValue,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
