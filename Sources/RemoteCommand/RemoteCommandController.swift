//
//  RemoteCommandController.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/9/11.
//

import MediaPlayer

class RemoteCommandController<T: MediaEndpoint> {

    private unowned var player: MediaPlayer<T>

    init(_ mediaPlayer: MediaPlayer<T>) {
        player = mediaPlayer
    }

    func setupCommands(
        _ commands: [Command],
        disabledCommands: [Command] = []
    ) {
        for command in Command.allCases {
            command.removeHandler()

            if commands.contains(command) {
                command.addHandler(handleCommand(_:event:))
            }

            command.setEnabled(!disabledCommands.contains(command))
        }
    }

    private func handleCommand(_ command: Command, event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        switch command {
        case .pause:
            player.pause()

        case .play:
            player.play()

        case .stop:
            player.stop()

        case .togglePlayPause:
            player.state == .playing ? player.pause() : player.play()

        case .changePlaybackRate:
            guard case let event as MPChangePlaybackRateCommandEvent = event else { return .commandFailed }
            player.playbackRate = event.playbackRate

        case .changeRepeatMode:
            ()

        case .changeShuffleMode:
            ()

        case .next:
            player.next()

        case .previous:
            player.previous()

        case .seekForward:
            ()

        case .seekBackward:
            ()

        case .changePlaybackPosition:
            guard case let event as MPChangePlaybackPositionCommandEvent = event else { return .commandFailed }
            player.seek(to: event.positionTime)

        default: ()
        }

        return .success
    }
}
