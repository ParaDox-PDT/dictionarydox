import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_state.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/mixin/unit_details_mixin.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/widgets/unit_details_app_bar.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/widgets/words_carousel_view.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/widgets/words_list_view.dart';
import 'package:dictionarydox/src/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitDetailsPage extends StatefulWidget {
  final Unit unit;

  const UnitDetailsPage({super.key, required this.unit});

  @override
  State<UnitDetailsPage> createState() => _UnitDetailsPageState();
}

class _UnitDetailsPageState extends State<UnitDetailsPage>
    with UnitDetailsMixin {
  @override
  Unit get unit => widget.unit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnitDetailsAppBar(
        unit: unit,
        isCarouselView: isCarouselView,
        onToggleView: toggleView,
        onQuizPressed: navigateToQuiz,
      ),
      body: BlocProvider.value(
        value: unitBloc,
        child: BlocBuilder<UnitBloc, UnitState>(
          builder: (context, state) {
            if (state is UnitLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UnitError) {
              return Center(child: Text(state.message));
            }

            if (state is UnitWordsLoaded) {
              if (state.words.isEmpty) {
                return EmptyState(
                  icon: Icons.text_snippet,
                  title: 'No Words Yet',
                  message: 'Add your first word to this unit',
                  action: ElevatedButton(
                    onPressed: navigateToAddWord,
                    child: const Text('Add Word'),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: navigateToQuiz,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Quiz'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  Expanded(
                    child: isCarouselView
                        ? WordsCarouselView(
                            words: state.words,
                            onPlayAudio: playWordPronunciation,
                            onDelete: showDeleteDialog,
                            onImageTap: showImageDialog,
                          )
                        : WordsListView(
                            words: state.words,
                            onPlayAudio: playWordPronunciation,
                            onDelete: showDeleteDialog,
                            onImageTap: showImageDialog,
                          ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddWord,
        child: const Icon(Icons.add),
      ),
    );
  }
}
