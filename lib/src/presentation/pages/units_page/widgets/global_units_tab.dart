import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/domain/usecases/get_global_units.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/unit_grid_view.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/widgets/unit_list_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GlobalUnitsTab extends StatefulWidget {
  final Function(dynamic unit) onUnitTap;

  const GlobalUnitsTab({
    super.key,
    required this.onUnitTap,
  });

  @override
  State<GlobalUnitsTab> createState() => _GlobalUnitsTabState();
}

class _GlobalUnitsTabState extends State<GlobalUnitsTab> {
  late final GetGlobalUnits _getGlobalUnits;
  Future<List<dynamic>>? _globalUnitsFuture;
  List<dynamic>? _cachedUnits; // Cache units to avoid reloading on tab switch

  @override
  void initState() {
    super.initState();
    _getGlobalUnits = sl<GetGlobalUnits>();
    // Load only if not cached (first time)
    if (_cachedUnits == null) {
      _loadGlobalUnits();
    }
  }

  Future<void> _loadGlobalUnits({bool forceRefresh = false}) async {
    // If cached and not forcing refresh, use cache
    if (_cachedUnits != null && !forceRefresh) {
      return;
    }

    setState(() {
      _globalUnitsFuture = _getGlobalUnits().then((result) {
        return result.fold(
          (failure) => <dynamic>[],
          (units) {
            _cachedUnits = units; // Cache the result
            return units;
          },
        );
      });
    });

    await _globalUnitsFuture;
  }

  @override
  Widget build(BuildContext context) {
    // If cached units exist, show them immediately
    if (_cachedUnits != null && _globalUnitsFuture == null) {
      return _buildContent(_cachedUnits!);
    }

    return FutureBuilder<List<dynamic>>(
      future: _globalUnitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoader(context);
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading global units',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadGlobalUnits,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final globalUnits = snapshot.data ?? [];
        return _buildContent(globalUnits);
      },
    );
  }

  Widget _buildContent(List<dynamic> globalUnits) {
    final content = globalUnits.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.public,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No global units available',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Global units will appear here',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          )
        : ResponsiveWrapper(
            child: ResponsiveUtils.isDesktop(context)
                ? UnitGridView(
                    units: globalUnits,
                    onUnitTap: widget.onUnitTap,
                    onUnitDelete: (_) {}, // No delete for global units
                  )
                : UnitListView(
                    units: globalUnits,
                    onUnitTap: widget.onUnitTap,
                    onUnitDelete: (_) {}, // No delete for global units
                  ),
          );

    // Wrap with RefreshIndicator only if content is scrollable
    if (globalUnits.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await _loadGlobalUnits(forceRefresh: true);
          setState(() {}); // Rebuild after refresh
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: content,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _loadGlobalUnits(forceRefresh: true);
        setState(() {}); // Rebuild after refresh
      },
      child: content,
    );
  }

  Widget _buildShimmerLoader(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final itemCount = isDesktop ? 6 : 3;

    return ResponsiveWrapper(
      child: isDesktop
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) => _UnitShimmerCard(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: itemCount,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _UnitShimmerCard(),
              ),
            ),
    );
  }
}

class _UnitShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
