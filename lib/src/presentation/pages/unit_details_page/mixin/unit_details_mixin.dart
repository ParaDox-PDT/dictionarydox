import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_event.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/widgets/image_view_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

/// Mixin containing all business logic for UnitDetailsPage
mixin UnitDetailsMixin<T extends StatefulWidget> on State<T> {
  late final UnitBloc unitBloc;
  late final FlutterTts flutterTts;
  bool isCarouselView = false;

  Unit get unit;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    unitBloc = sl<UnitBloc>()..add(LoadUnitWordsEvent(unit.id));
    flutterTts.setLanguage('en-US');
  }

  @override
  void dispose() {
    unitBloc.close();
    flutterTts.stop();
    super.dispose();
  }

  /// Toggle between list and carousel view
  void toggleView() {
    setState(() {
      isCarouselView = !isCarouselView;
    });
  }

  /// Refresh words list
  void refreshWords() {
    unitBloc.add(LoadUnitWordsEvent(unit.id));
  }

  /// Navigate to quiz selection
  Future<void> navigateToQuiz() async {
    await context.push('/unit/${unit.id}/quiz-select');
    refreshWords();
  }

  /// Navigate to add word page
  Future<void> navigateToAddWord() async {
    await context.push('/unit/${unit.id}/add-word');
    refreshWords();
  }

  /// Play word pronunciation
  Future<void> playWordPronunciation(dynamic word) async {
    await flutterTts.speak(word.english);
  }

  /// Show delete confirmation dialog
  void showDeleteDialog(dynamic word) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Word'),
        content: const Text('Are you sure you want to delete this word?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              unitBloc.add(DeleteWordEvent(wordId: word.id, unitId: unit.id));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Show image in full screen dialog
  void showImageDialog(String imageUrl) {
    ImageViewDialog.show(context, imageUrl);
  }
}
