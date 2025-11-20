import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSkeletonLoader extends StatelessWidget {
  const ProfileSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: isMobile
          ? ResponsiveWrapper(
              maxWidth: 600,
              child: CustomScrollView(
                slivers: [
                  _buildSkeletonAppBar(context),
                  _buildSkeletonContent(context),
                ],
              ),
            )
          : Scrollbar(
              thumbVisibility: false,
              child: SingleChildScrollView(
                child: Center(
                  child: ResponsiveWrapper(
                    maxWidth: ResponsiveUtils.getMaxContentWidth(context),
                    child: Padding(
                      padding: ResponsiveUtils.getResponsivePadding(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),
                          _buildWebSkeletonHeader(context),
                          const SizedBox(height: 48),
                          ResponsiveUtils.isDesktop(context)
                              ? _buildDesktopSkeletonLayout(context)
                              : _buildTabletSkeletonLayout(context),
                          const SizedBox(height: 48),
                          // Footer skeleton
                          Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const SizedBox(
                                width: 150,
                                height: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSkeletonAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: const SizedBox(
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(height: 16),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const SizedBox(
                  width: 150,
                  height: 24,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonContent(BuildContext context) {
    return SliverPadding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 24),
          _buildSkeletonCard([
            _buildSkeletonRow(),
            const Divider(height: 24),
            _buildSkeletonRow(),
            const Divider(height: 24),
            _buildSkeletonRow(),
          ]),
          const SizedBox(height: 24),
          _buildSkeletonCard([
            _buildSkeletonListTile(),
            const Divider(height: 1),
            _buildSkeletonListTile(),
          ]),
          const SizedBox(height: 24),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const SizedBox(width: 200, height: 50),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const SizedBox(width: 150, height: 40),
            ),
          ),
          const SizedBox(height: 200),
        ]),
      ),
    );
  }

  Widget _buildSkeletonCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SizedBox(width: 150, height: 18),
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonRow() {
    return Row(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: SizedBox(width: 40, height: 40),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const SizedBox(width: 80, height: 12),
              ),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const SizedBox(width: double.infinity, height: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonListTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 40, height: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const SizedBox(width: 100, height: 14),
                ),
                const SizedBox(height: 6),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const SizedBox(width: 150, height: 12),
                ),
              ],
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 16, height: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildWebSkeletonHeader(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 4,
            ),
          ),
          child: SizedBox(
            width: ResponsiveUtils.isDesktop(context) ? 140 : 120,
            height: ResponsiveUtils.isDesktop(context) ? 140 : 120,
          ),
        ),
        const SizedBox(height: 24),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            width: 200,
            height: ResponsiveUtils.isDesktop(context) ? 32 : 28,
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const SizedBox(
            width: 250,
            height: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopSkeletonLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildSkeletonCard([
            _buildSkeletonRow(),
            const Divider(height: 24),
            _buildSkeletonRow(),
            const Divider(height: 24),
            _buildSkeletonRow(),
          ]),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildSkeletonCard([
                _buildSkeletonListTile(),
                const Divider(height: 1),
                _buildSkeletonListTile(),
              ]),
              const SizedBox(height: 24),
              Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const SizedBox(width: 200, height: 50),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const SizedBox(width: 150, height: 40),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletSkeletonLayout(BuildContext context) {
    return Column(
      children: [
        _buildSkeletonCard([
          _buildSkeletonRow(),
          const Divider(height: 24),
          _buildSkeletonRow(),
          const Divider(height: 24),
          _buildSkeletonRow(),
        ]),
        const SizedBox(height: 24),
        _buildSkeletonCard([
          _buildSkeletonListTile(),
          const Divider(height: 1),
          _buildSkeletonListTile(),
        ]),
        const SizedBox(height: 24),
        Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const SizedBox(width: 200, height: 50),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const SizedBox(width: 150, height: 40),
          ),
        ),
      ],
    );
  }
}
