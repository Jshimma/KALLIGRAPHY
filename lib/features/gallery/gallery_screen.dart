import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const _photos = [
    _GalleryPhoto(
      'Introduction.jpg',
      'Introductions',
      'A beginning worth remembering.',
    ),
    _GalleryPhoto('Wedding.jpg', 'Weddings', 'The day they became one.'),
    _GalleryPhoto('Moment6.jpg', 'Moments', 'The in-between moments.'),
    _GalleryPhoto(
      'Introduction2.jpg',
      'Introductions',
      'A room full of anticipation.',
    ),
    _GalleryPhoto('Wedding2.jpg', 'Weddings', 'Love, surrounded by everyone.'),
    _GalleryPhoto('photoshoot.jpg', 'Portraits', 'In their element.'),
    _GalleryPhoto('Introduction3.jpg', 'Introductions', 'The first chapter.'),
    _GalleryPhoto('Moments.jpg', 'Moments', 'Life, as it felt.'),
    _GalleryPhoto('Wedding3.jpg', 'Weddings', 'A day worth holding onto.'),
    _GalleryPhoto(
      'Introduction4.jpg',
      'Introductions',
      'Where the story begins.',
    ),
    _GalleryPhoto('graduation.jpg', 'Graduations', 'A milestone made visible.'),
    _GalleryPhoto('Wedding4.jpg', 'Weddings', 'Joy in every direction.'),
    _GalleryPhoto('photoshoot3.jpg', 'Portraits', 'A portrait with presence.'),
    _GalleryPhoto('Introduction5.jpg', 'Introductions', 'A new beginning.'),
    _GalleryPhoto(
      'Moments2.jpg',
      'Moments',
      'Nothing staged. Everything felt.',
    ),
    _GalleryPhoto('Wedding5.jpg', 'Weddings', 'The people who made the day.'),
    _GalleryPhoto(
      'Baby shower.jpg',
      'Baby Showers',
      'Waiting for someone special.',
    ),
    _GalleryPhoto('Introduction6.jpg', 'Introductions', 'The room remembers.'),
    _GalleryPhoto('graduation2.jpg', 'Graduations', 'Made it here.'),
    _GalleryPhoto('Wedding6.jpg', 'Weddings', 'Held in the moment.'),
    _GalleryPhoto(
      'photoshoot4.jpg',
      'Portraits',
      'The person behind the portrait.',
    ),
    _GalleryPhoto('Moments3.jpg', 'Moments', 'A little piece of ordinary.'),
    _GalleryPhoto(
      'Introduction7.jpg',
      'Introductions',
      'Before everything changed.',
    ),
    _GalleryPhoto('Wedding7.jpg', 'Weddings', 'Forever, documented.'),
    _GalleryPhoto('photoshoot5.jpg', 'Portraits', 'Presence over perfection.'),
    _GalleryPhoto('graduation3.jpg', 'Graduations', 'One chapter closes.'),
    _GalleryPhoto('Moments4.jpg', 'Moments', 'The moments between moments.'),
    _GalleryPhoto(
      'Introduction8.jpg',
      'Introductions',
      'A celebration of arrival.',
    ),
    _GalleryPhoto('photoshoot6.jpg', 'Portraits', 'Seen as you are.'),
    _GalleryPhoto('Wedding.jpg', 'Weddings', 'Remember this feeling.'),
    _GalleryPhoto('Moments5.jpg', 'Moments', 'A memory in motion.'),
    _GalleryPhoto(
      'Introduction9.jpg',
      'Introductions',
      'The beginning of something.',
    ),
    _GalleryPhoto('photoshoot7.jpg', 'Portraits', 'Unmistakably you.'),
    _GalleryPhoto('Moments6.jpg', 'Moments', 'The beauty of being there.'),
    _GalleryPhoto('Introduction10.jpg', 'Introductions', 'And so it begins.'),
    _GalleryPhoto('photoshoot8.jpg', 'Portraits', 'A frame of character.'),
    _GalleryPhoto('photoshoot9.jpg', 'Portraits', 'Quiet confidence.'),
    _GalleryPhoto('photoshoot10.jpg', 'Portraits', 'Nothing but presence.'),
    _GalleryPhoto('photoshoot11.jpg', 'Portraits', 'A story in one frame.'),
    _GalleryPhoto('Wedding2.jpg', 'Weddings', 'Where memory becomes tangible.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _GalleryHero(),
            const _GalleryStatement(),
            _GalleryArchive(photos: _photos),
            const _GalleryClosing(),
          ],
        ),
      ),
    );
  }
}

class _GalleryPhoto {
  const _GalleryPhoto(this.fileName, this.category, this.caption);

  final String fileName;
  final String category;
  final String caption;

  String get path => 'assets/images/ryan/$fileName';
}

class _GalleryHero extends StatelessWidget {
  const _GalleryHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 100, 28, 95),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 800;

                final title = Text(
                  'THE\nGALLERY.',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.ivory,
                    fontSize: wide ? 112 : 68,
                    height: .78,
                    letterSpacing: -2,
                  ),
                );

                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Eyebrow(
                      'KALLYGRAPHY / VISUAL ARCHIVE',
                      color: AppColors.sand,
                    ),
                    const SizedBox(height: 28),
                    Container(width: 55, height: 3, color: AppColors.mocha),
                    const SizedBox(height: 25),
                    Text(
                      'A collection of celebrations, people, '
                      'places and fleeting moments.',
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: AppColors.sand, height: 1.75),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'EVERY FRAME HOLDS A MEMORY.',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.mocha,
                      ),
                    ),
                  ],
                );

                if (!wide) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [title, const SizedBox(height: 55), copy],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(flex: 5, child: title),
                    const SizedBox(width: 100),
                    Expanded(flex: 2, child: copy),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryStatement extends StatelessWidget {
  const _GalleryStatement();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.mocha,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 760;

              final statement = Text(
                'PHOTOGRAPHS THAT FEEL LIKE MEMORY.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.ivory,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              );

              final count = const Text(
                '39 FRAMES',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.ivory,
                ),
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [statement, const SizedBox(height: 16), count],
                );
              }

              return Row(
                children: [
                  Expanded(child: statement),
                  count,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GalleryArchive extends StatelessWidget {
  const _GalleryArchive({required this.photos});

  final List<_GalleryPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(20, 85, 20, 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 850;

              if (!wide) {
                return _MobileGallery(photos: photos);
              }

              return _EditorialGallery(photos: photos);
            },
          ),
        ),
      ),
    );
  }
}

class _EditorialGallery extends StatelessWidget {
  const _EditorialGallery({required this.photos});

  final List<_GalleryPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < photos.length; index += 3)
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: _GalleryRow(photos: photos, startIndex: index),
          ),
      ],
    );
  }
}

class _GalleryRow extends StatelessWidget {
  const _GalleryRow({required this.photos, required this.startIndex});

  final List<_GalleryPhoto> photos;
  final int startIndex;

  @override
  Widget build(BuildContext context) {
    final first = photos[startIndex];
    final hasSecond = startIndex + 1 < photos.length;
    final hasThird = startIndex + 2 < photos.length;

    if (!hasSecond) {
      return _LargeGalleryTile(
        photo: first,
        index: startIndex,
        onTap: () => _openGallery(context, photos, startIndex),
      );
    }

    if (!hasThird) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: _GalleryTile(
              photo: first,
              index: startIndex,
              tall: true,
              onTap: () => _openGallery(context, photos, startIndex),
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            flex: 2,
            child: _GalleryTile(
              photo: photos[startIndex + 1],
              index: startIndex + 1,
              tall: false,
              onTap: () => _openGallery(context, photos, startIndex + 1),
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _GalleryTile(
            photo: first,
            index: startIndex,
            tall: true,
            onTap: () => _openGallery(context, photos, startIndex),
          ),
        ),
        const SizedBox(width: 22),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _GalleryTile(
                photo: photos[startIndex + 1],
                index: startIndex + 1,
                tall: false,
                onTap: () => _openGallery(context, photos, startIndex + 1),
              ),
              const SizedBox(height: 22),
              _GalleryTile(
                photo: photos[startIndex + 2],
                index: startIndex + 2,
                tall: false,
                onTap: () => _openGallery(context, photos, startIndex + 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileGallery extends StatelessWidget {
  const _MobileGallery({required this.photos});

  final List<_GalleryPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < photos.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: _LargeGalleryTile(
              photo: photos[index],
              index: index,
              onTap: () => _openGallery(context, photos, index),
            ),
          ),
      ],
    );
  }
}

class _LargeGalleryTile extends StatelessWidget {
  const _LargeGalleryTile({
    required this.photo,
    required this.index,
    required this.onTap,
  });

  final _GalleryPhoto photo;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _GalleryTile(photo: photo, index: index, tall: true, onTap: onTap);
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({
    required this.photo,
    required this.index,
    required this.tall,
    required this.onTap,
  });

  final _GalleryPhoto photo;
  final int index;
  final bool tall;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.sand,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: tall ? .86 : 1.12,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  photo.path,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: AppColors.espresso,
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              color: AppColors.sand,
              padding: const EdgeInsets.fromLTRB(16, 13, 16, 17),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          photo.category.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                            color: AppColors.mocha,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          photo.caption,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.espresso,
                                height: 1.35,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: AppColors.brown,
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

void _openGallery(
  BuildContext context,
  List<_GalleryPhoto> photos,
  int initialIndex,
) {
  showDialog<void>(
    context: context,
    barrierColor: AppColors.espresso.withValues(alpha: .97),
    builder: (_) => _GalleryViewer(photos: photos, initialIndex: initialIndex),
  );
}

class _GalleryViewer extends StatefulWidget {
  const _GalleryViewer({required this.photos, required this.initialIndex});

  final List<_GalleryPhoto> photos;
  final int initialIndex;

  @override
  State<_GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<_GalleryViewer> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  void _previous() {
    if (_index == 0) return;
    setState(() => _index--);
  }

  void _next() {
    if (_index == widget.photos.length - 1) return;
    setState(() => _index++);
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photos[_index];

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Material(
        color: AppColors.espresso,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(70, 75, 70, 90),
                  child: Image.asset(
                    photo.path,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_outlined,
                        size: 60,
                        color: AppColors.sand,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 24,
                left: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo.category.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.mocha,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      photo.caption,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        color: AppColors.sand,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 18,
                right: 18,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.ivory),
                ),
              ),
              Positioned(
                left: 18,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: _index == 0 ? null : _previous,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.cream.withValues(alpha: .12),
                      foregroundColor: AppColors.ivory,
                      disabledForegroundColor: AppColors.sand.withValues(
                        alpha: .25,
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Positioned(
                right: 18,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: _index == widget.photos.length - 1
                        ? null
                        : _next,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.cream.withValues(alpha: .12),
                      foregroundColor: AppColors.ivory,
                      disabledForegroundColor: AppColors.sand.withValues(
                        alpha: .25,
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
              Positioned(
                bottom: 24,
                left: 28,
                right: 28,
                child: Row(
                  children: [
                    Text(
                      (_index + 1).toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.ivory,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Container(height: 1, color: AppColors.brown),
                      ),
                    ),
                    Text(
                      widget.photos.length.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.sand,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryClosing extends StatelessWidget {
  const _GalleryClosing();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.darkBrown,
      padding: const EdgeInsets.fromLTRB(28, 110, 28, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 760;

              final heading = Text(
                'YOUR STORY\nDESERVES\nTO BE FELT.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.ivory,
                  fontSize: wide ? 72 : 50,
                  height: .85,
                  letterSpacing: -1,
                ),
              );

              final action = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LET’S CREATE SOMETHING\nWORTH REMEMBERING.',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.8,
                      color: AppColors.sand,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: () => context.go('/booking'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.mocha,
                      foregroundColor: AppColors.ivory,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 27,
                        vertical: 19,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'START YOUR INQUIRY  →',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.7,
                      ),
                    ),
                  ),
                ],
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [heading, const SizedBox(height: 45), action],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: heading),
                  const SizedBox(width: 90),
                  action,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {this.color = AppColors.brown});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.2,
        color: color,
      ),
    );
  }
}
