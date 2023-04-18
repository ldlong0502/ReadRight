import 'package:ebook/view_models/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer, required this.isMiniPlayer});
  final AudioPlayer audioPlayer;
  final bool isMiniPlayer;
  @override
  Widget build(BuildContext context) {
    return isMiniPlayer ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             IconButton(
                onPressed: onRedo,
                icon: SvgPicture.asset(
                  'assets/icons/redo.svg',
                  color: Colors.black,
                  height: 25,
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: StreamBuilder<PlayerState>(
                    stream: audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      context
                          .read<AudioProvider>()
                          .setAudioHistory(audioPlayer);
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (!(playing ?? false)) {
                        return IconButton(
                            onPressed: audioPlayer.play,
                            iconSize: 30,
                            color: Colors.white,
                            icon: const Icon(Icons.play_arrow_rounded));
                      } else if (processingState != ProcessingState.completed) {
                        return IconButton(
                            onPressed: audioPlayer.pause,
                            iconSize: 30,
                            color: Colors.white,
                            icon: const Icon(Icons.pause_rounded));
                      }
                      return const Icon(
                        Icons.pause_rounded,
                        size: 30,
                        color: Colors.white,
                      );
                    }),
              ),         
            ],
    ) : Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
                    onPressed: audioPlayer.seekToPrevious,
                    iconSize: 30,
                    color: Colors.white,
                    icon: const Icon(Icons.skip_previous_outlined)),
        IconButton(
            onPressed: onUndo,
            icon: SvgPicture.asset('assets/icons/undo.svg', color: Colors.white , height: 25,),),
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white24,
          child: StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                context
                          .read<AudioProvider>()
                          .setAudioHistory(audioPlayer);
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (!(playing ?? false)) {
                  
                  return IconButton(
                      onPressed: audioPlayer.play,
                      iconSize: 40,
                      color: Colors.white,
                      icon: const Icon(Icons.play_arrow_rounded));
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                      onPressed: audioPlayer.pause,
                      iconSize: 40,
                      color: Colors.white,
                      icon: const Icon(Icons.pause_rounded));
                }
                return const Icon(Icons.pause_rounded, size: 40 , color: Colors.white,);
              }),
        ),
        IconButton(
          onPressed: onRedo,
          icon: SvgPicture.asset(
            'assets/icons/redo.svg',
            color: Colors.white,
            height: 25,
          ),
        ),
            IconButton(
            onPressed: audioPlayer.seekToNext,
            iconSize: 30,
            color: Colors.white,
            icon: const Icon(Icons.skip_next_outlined)),
      ],
    );
  }
  onRedo() async {
    var time = audioPlayer.position;
    int seconds = time.inSeconds + 30;
    if(seconds > audioPlayer.duration!.inSeconds) {
      seconds = audioPlayer.duration!.inSeconds;
    }
    await audioPlayer.seek(Duration(seconds: seconds));
  }

  onUndo() async  {
    var time = audioPlayer.position;
    int seconds = time.inSeconds - 15;
    if(seconds < 0) seconds = 0;
    await audioPlayer.seek(Duration(seconds: seconds));
  }
}

