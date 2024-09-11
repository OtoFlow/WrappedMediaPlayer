//
//  RemoteCommand.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/9/11.
//

import MediaPlayer

public class _AnyRemoteCommand { }

public typealias RemoteCommands = _AnyRemoteCommand

public class RemoteCommand<Event: MPRemoteCommandEvent>: _AnyRemoteCommand {

    public let command: Command

    public init(_ command: Command) {
        self.command = command
    }

    public init(_ command: Command, type: Event.Type = MPRemoteCommandEvent.self) {
        self.command = command
    }
}

extension RemoteCommands {

    public static let pause = RemoteCommand(.pause)

    public static let play = RemoteCommand(.play)

    public static let stop = RemoteCommand(.stop)

    public static let togglePlayPause = RemoteCommand(.togglePlayPause)

    public static let changePlaybackRate = RemoteCommand<MPChangePlaybackRateCommandEvent>(.changePlaybackRate)

    public static let changeRepeatMode = RemoteCommand<MPChangeRepeatModeCommandEvent>(.changeRepeatMode)

    public static let changeShuffleMode = RemoteCommand<MPChangeShuffleModeCommandEvent>(.changeShuffleMode)

    public static let nextTrack = RemoteCommand(.next)

    public static let previousTrack = RemoteCommand(.previous)

    public static let seekForward = RemoteCommand<MPSeekCommandEvent>(.seekForward)

    public static let seekBackward = RemoteCommand<MPSeekCommandEvent>(.seekBackward)

    public static let changePlaybackPosition = RemoteCommand<MPChangePlaybackPositionCommandEvent>(.changePlaybackPosition)

    public static let rating = RemoteCommand<MPRatingCommandEvent>(.rating)

    public static let like = RemoteCommand<MPFeedbackCommandEvent>(.like)

    public static let dislike = RemoteCommand<MPFeedbackCommandEvent>(.dislike)

    public static let bookmark = RemoteCommand<MPFeedbackCommandEvent>(.bookmark)
}

extension RemoteCommand {

    public func addHandler(_ handler: @escaping (_ event: Event) -> MPRemoteCommandHandlerStatus) {
        command.addHandler { _, event in
            guard case let event as Event = event else {
                return .commandFailed
            }
            return handler(event)
        }
    }
}

public enum Command: CaseIterable {

    case pause, play, stop, togglePlayPause

    case changePlaybackRate

    case changeRepeatMode, changeShuffleMode

    case nextTrack, previousTrack

    case seekForward, seekBackward

    case changePlaybackPosition

    case rating, like, dislike, bookmark

    public var isEnabled: Bool { remoteCommand.isEnabled }

    private var remoteCommand: MPRemoteCommand {
        centerRemoteCommand(.shared())
    }

    private var centerRemoteCommand: (MPRemoteCommandCenter) -> MPRemoteCommand {
        switch self {
        case .pause:                  \.pauseCommand
        case .play:                   \.playCommand
        case .stop:                   \.stopCommand
        case .togglePlayPause:        \.togglePlayPauseCommand
        case .changePlaybackRate:     \.changePlaybackRateCommand
        case .changeRepeatMode:       \.changeRepeatModeCommand
        case .changeShuffleMode:      \.changeShuffleModeCommand
        case .next:                   \.nextTrackCommand
        case .previous:               \.previousTrackCommand
        case .seekForward:            \.seekForwardCommand
        case .seekBackward:           \.seekBackwardCommand
        case .changePlaybackPosition: \.changePlaybackPositionCommand
        case .rating:                 \.ratingCommand
        case .like:                   \.likeCommand
        case .dislike:                \.dislikeCommand
        case .bookmark:               \.bookmarkCommand
        }
    }

    public func setEnabled(_ isEnabled: Bool) {
        remoteCommand.isEnabled = isEnabled
    }

    func addHandler(_ handler: @escaping (Command, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus) {
        remoteCommand.addTarget { handler(self, $0) }
    }

    func removeHandler() {
        remoteCommand.removeTarget(nil)
    }
}
