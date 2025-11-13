import 'package:flutter/material.dart';

class UnitsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const UnitsAppBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      toolbarHeight: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[700],
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            dividerColor: Colors.transparent,
            padding: const EdgeInsets.all(4),
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('My Units'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public, size: 20),
                    SizedBox(width: 8),
                    Text('Global Units'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68);
}
