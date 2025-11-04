import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_event.dart';
import 'package:dictionarydox/src/presentation/blocs/unit/unit_state.dart';
import 'package:dictionarydox/src/presentation/widgets/dd_card.dart';
import 'package:dictionarydox/src/presentation/widgets/empty_state.dart';
import 'package:dictionarydox/src/presentation/widgets/image_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

class UnitDetailsPage extends StatefulWidget {
  final Unit unit;

  const UnitDetailsPage({super.key, required this.unit});

  @override
  State<UnitDetailsPage> createState() => _UnitDetailsPageState();
}

class _UnitDetailsPageState extends State<UnitDetailsPage> {
  late final UnitBloc _unitBloc;
  final _audioPlayer = AudioPlayer();
  final _flutterTts = FlutterTts();
  bool _isCarouselView = false;

  @override
  void initState() {
    super.initState();
    _unitBloc = sl<UnitBloc>()..add(LoadUnitWordsEvent(widget.unit.id));
    _flutterTts.setLanguage('en-US');
  }

  @override
  void dispose() {
    _unitBloc.close();
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _refreshWords() {
    _unitBloc.add(LoadUnitWordsEvent(widget.unit.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.unit.name),
        actions: [
          IconButton(
            icon: Icon(_isCarouselView ? Icons.view_list : Icons.view_carousel),
            onPressed: () {
              setState(() {
                _isCarouselView = !_isCarouselView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.quiz),
            onPressed: () async {
              await context.push('/unit/${widget.unit.id}/quiz-select');
              _refreshWords();
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _unitBloc,
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
                    onPressed: () async {
                      await context.push('/unit/${widget.unit.id}/add-word');
                      _refreshWords();
                    },
                    child: const Text('Add Word'),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await context
                            .push('/unit/${widget.unit.id}/quiz-select');
                        _refreshWords();
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Quiz'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _isCarouselView
                        ? _buildCarouselView(state.words)
                        : _buildListView(state.words),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/unit/${widget.unit.id}/add-word');
          _refreshWords();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _playWordPronunciation(dynamic word) async {
    if (word.audioUrl != null) {
      try {
        await _audioPlayer.play(UrlSource(word.audioUrl));
      } catch (e) {
        await _flutterTts.speak(word.english);
      }
    } else {
      await _flutterTts.speak(word.english);
    }
  }

  void _showDeleteDialog(BuildContext context, String wordId) {
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
              context
                  .read<UnitBloc>()
                  .add(DeleteWordEvent(wordId: wordId, unitId: widget.unit.id));
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<dynamic> words) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildListWordCard(word),
        );
      },
    );
  }

  Widget _buildCarouselView(List<dynamic> words) {
    return CarouselSlider.builder(
      itemCount: words.length,
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.75,
        viewportFraction: 0.85,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        autoPlay: false,
      ),
      itemBuilder: (context, index, realIndex) {
        final word = words[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildCarouselWordCard(word),
        );
      },
    );
  }

  // List view uchun kichik card
  Widget _buildListWordCard(dynamic word) {
    return DdCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (word.imageUrl != null)
                GestureDetector(
                  onTap: () => _showImageDialog(word.imageUrl!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: word.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ImageShimmer(
                        width: 60,
                        height: 60,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              if (word.imageUrl != null) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.english,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      word.uzbek,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (word.phonetic != null && word.phonetic!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        word.phonetic!,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _playWordPronunciation(word),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(context, word.id);
                    },
                  ),
                ],
              ),
            ],
          ),
          if (word.description != null && word.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              word.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          if (word.example != null && word.example!.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Example:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              word.example!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  // Carousel view uchun katta card
  Widget _buildCarouselWordCard(dynamic word) {
    return DdCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Rasm birinchi qatorda katta shaklda
            if (word.imageUrl != null) ...[
              GestureDetector(
                onTap: () => _showImageDialog(word.imageUrl!),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: word.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ImageShimmer(
                      width: double.infinity,
                      height: 200,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.error, size: 50),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Phonetic (talaffuz)
            if (word.phonetic != null && word.phonetic!.isNotEmpty) ...[
              Center(
                child: Text(
                  word.phonetic!,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            // English word
            Center(
              child: Text(
                word.english,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            // Uzbek word
            Center(
              child: Text(
                word.uzbek,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[700],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            // Description
            if (word.description != null && word.description!.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                word.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
            ],
            // Example
            if (word.example != null && word.example!.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Example',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                word.example!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 12),
            ],
            // Buttons pastda
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _playWordPronunciation(word),
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Listen'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteDialog(context, word.id),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
