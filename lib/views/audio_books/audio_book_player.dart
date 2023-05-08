
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:ebook/components/control.dart';
import 'package:ebook/models/audio_book.dart';
import 'package:ebook/models/media_data.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/dialogs.dart';
import 'package:ebook/view_models/audio_provider.dart';
import 'package:ebook/view_models/speed_provider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';

import '../../models/position_data.dart';
import '../../util/const.dart';

final ValueNotifier<double> playerExpandProgress =
    ValueNotifier(playerMinHeight);



class AudioBookPlayer extends StatefulWidget {
  const AudioBookPlayer({super.key, required this.audioBook});
  final AudioBook audioBook;
  @override
  State<AudioBookPlayer> createState() => _AudioBookPlayerState();
}

class _AudioBookPlayerState extends State<AudioBookPlayer> {

  bool isMax = true;
  
  @override
  Widget build(BuildContext context) {
    
    
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<AudioProvider>(
      builder: (context, event, _) {
        return Miniplayer(
            minHeight: 60,
            maxHeight: screenHeight,
            controller: event.controller,
            onDismiss: (){
               
              context.read<AudioProvider>().setAudioHistory(event.audioPlayer);
              context.read<AudioProvider>().audioPlayer.dispose();
              context.read<AudioProvider>().setAudioBook(null);
              
            },
            valueNotifier: playerExpandProgress,
            builder: (height, percentage) {
              if(isMax){
                event.controller.animateToHeight(state: PanelState.MAX);
                isMax = false;
              }
              final bool miniplayer = percentage < miniplayerPercentageDeclaration;
              if (!miniplayer) {
                return Scaffold(
                    body: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Container(
                          height: screenHeight,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ThemeConfig.lightAccent,
                                ThemeConfig.fourthAccent
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildAction(screenHeight, event),
                              _buildBook(screenHeight, event),
                              _buildPlayer(screenHeight, event),
                              _buildChapter(screenHeight, event)
                            ],
                          )),
                    ));
              } else {
                
                return Container(
                  alignment: Alignment.center,
                  color: Colors.white10,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      widget.audioBook.image,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(widget.audioBook.title, style:  TextStyle(
                                            fontSize: 15.0,
                                            overflow: TextOverflow.ellipsis,
                                            color: ThemeConfig.lightAccent)),
                                    StreamBuilder<SequenceState?>(
                                        stream: event.audioPlayer.sequenceStateStream,
                                        builder: ((context, snapshot) {
                                          final state = snapshot.data;
                                          if (state?.sequence.isEmpty ?? true) {
                                            return const SizedBox();
                                          }
    
                                          final chapter = state!.currentSource!.tag
                                              as MediaData;
                                          return Text(chapter.title, style:  const TextStyle(
                                                fontSize: 15.0,
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.grey),);
                                        }))
                                  ],
                                )),
                            Expanded(
                              flex: 2,
                              child: Controls(
                                  audioPlayer: event.audioPlayer, isMiniPlayer: true),
                            ),
                          ],
                        ),
                      ),
                       Expanded(
                        flex: 2,
                        child: StreamBuilder<PositionData>(
                                      stream: event.positionDataSteam,
                                      builder: (context, snapshot) {
                                        final positionData = snapshot.data;
                                        return ProgressBar(
                        barHeight: 2,
                        baseBarColor: Colors.grey,
                        bufferedBarColor: Colors.white30,
                        progressBarColor: Colors.amberAccent,
                        thumbColor: Colors.transparent,
                        timeLabelTextStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                        progress: positionData?.position ?? Duration.zero,
                        buffered: positionData?.bufferedPosition ?? Duration.zero,
                        total: positionData?.duration ?? Duration.zero,
                        onSeek: event.audioPlayer.seek,
                                        );
                                      }),)
                    ],
                  ),
                );
              }
            });
      }
    );
  }

  _buildBook(double screenHeight , AudioProvider event) {
    return SizedBox(
        height: screenHeight * 0.6,
        width: double.infinity,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                  height: screenHeight * 0.45,
                  width: 200,
                  child: Image.network(
                    widget.audioBook.image,
                    fit: BoxFit.fill,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.audioBook.title,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<SequenceState?>(
                stream: event.audioPlayer.sequenceStateStream,
                builder: ((context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }

                  final chapter = state!.currentSource!.tag as MediaData;
                  return AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        chapter.title,
                        textStyle: const TextStyle(
                            fontSize: 15.0, color: Colors.white),
                        cursor: '',
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                    repeatForever: true,
                  );
                }))
          ],
        ));
  }

  _buildAction(double screenHeight, AudioProvider event) {
    return SizedBox(
      height: screenHeight * 0.1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: InkWell(
              onTap: () {

                event.controller.animateToHeight(state: PanelState.MIN);
              },
              child: const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }

  _buildPlayer(double screenHeight , AudioProvider event) {
    return SizedBox(
      height: screenHeight * 0.15,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: StreamBuilder<PositionData>(
                stream: event.positionDataSteam,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                    barHeight: 8,
                    baseBarColor: Colors.white38,
                    bufferedBarColor: Colors.grey,
                    progressBarColor: Colors.white,
                    thumbColor: Colors.white,
                    timeLabelTextStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: event.audioPlayer.seek,
                  );
                }),
          ),
          Controls(audioPlayer: event.audioPlayer, isMiniPlayer: false),
        ],
      ),
    );
  }

  _buildChapter(double screenHeight , AudioProvider event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: IconButton(
                  onPressed: () async {
                    Dialogs().showChapterBottomDialog(
                        context,
                        widget.audioBook.listMp3,
                        event.audioPlayer.currentIndex!,
                        onChooseChapter);
                  },
                  color: Colors.white,
                  icon: const Icon(
                    Icons.menu_open_rounded,
                  )),
            ),
            const SizedBox(
              height: 30,
              child: Text(
                'Chương',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        Consumer<SpeedProvider>(builder: (context, event, _) {
          return InkWell(
            onTap: () {
              Dialogs().showSpeedBottomDialog(context, onChooseSpeed);
            },
            child: Column(
              children: [
                SizedBox(
                    height: 40,
                    child: Center(
                      child: Text(
                        '${event.getSpeed()}x',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )),
                const SizedBox(
                  height: 30,
                  child: Text(
                    'Tốc độ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        })
      ],
    );
  }

  onChooseChapter(int index ) async {
    var event = context.read<AudioProvider>();
    if (index == event.audioPlayer.currentIndex) return;
    await event.audioPlayer.setAudioSource(event.playList,
        initialIndex: index, initialPosition: Duration.zero);
   event.audioPlayer.play();
  }

  onChooseSpeed(double speed) async {
    var event = context.read<AudioProvider>();
    await event.audioPlayer.setSpeed(speed);
  }
}
