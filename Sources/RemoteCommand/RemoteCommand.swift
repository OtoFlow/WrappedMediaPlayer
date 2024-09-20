//
//  RemoteCommand.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/9/11.
//

import MediaPlayer

public class _AnyRemoteCommand { }

public typealias RemoteCommands = _AnyRemoteCommand

@dynamicMemberLookup
public class RemoteCommand<Command: MPRemoteCommand, Event: MPRemoteCommandEvent>: _AnyRemoteCommand {

    private let command: KeyPath<MPRemoteCommandCenter, Command>

    public init(
        _ command: KeyPath<MPRemoteCommandCenter, Command>,
        event: Event.Type = MPRemoteCommandEvent.self
    ) {
        self.command = command
    }

    public subscript<Property>(dynamicMember keyPath: ReferenceWritableKeyPath<Command, Property>) -> Property {
        get { MPRemoteCommandCenter.shared()[keyPath: command][keyPath: keyPath] }
        set { MPRemoteCommandCenter.shared()[keyPath: command][keyPath: keyPath] = newValue }
    }

    public func addHandler(_ handler: @escaping (_ event: Event) -> MPRemoteCommandHandlerStatus) {
        let command = MPRemoteCommandCenter.shared()[keyPath: command]
        command.addTarget { event in
            guard case let event as Event = event else {
                return .commandFailed
            }
            return handler(event)
        }
    }
}

extension RemoteCommands {

    public static let pause = RemoteCommand(\.pauseCommand)

    public static let play = RemoteCommand(\.playCommand)

    public static let stop = RemoteCommand(\.stopCommand)

    public static let togglePlayPause = RemoteCommand(\.togglePlayPauseCommand)

    public static let enableLanguageOption = RemoteCommand(\.enableLanguageOptionCommand)

    public static let disableLanguageOption = RemoteCommand(\.disableLanguageOptionCommand)

    public static let changePlaybackRate = RemoteCommand(\.changePlaybackRateCommand, event: MPChangePlaybackRateCommandEvent.self)

    public static let changeRepeatMode = RemoteCommand(\.changeRepeatModeCommand, event: MPChangeRepeatModeCommandEvent.self)

    public static let changeShuffleMode = RemoteCommand(\.changeShuffleModeCommand, event: MPChangeShuffleModeCommandEvent.self)

    public static let nextTrack = RemoteCommand(\.nextTrackCommand)

    public static let previousTrack = RemoteCommand(\.previousTrackCommand)

    public static let skipForward = RemoteCommand(\.skipForwardCommand, event: MPSkipIntervalCommandEvent.self)

    public static let skipBackward = RemoteCommand(\.skipBackwardCommand, event: MPSkipIntervalCommandEvent.self)

    public static let seekForward = RemoteCommand(\.seekForwardCommand, event: MPSeekCommandEvent.self)

    public static let seekBackward = RemoteCommand(\.seekBackwardCommand, event: MPSeekCommandEvent.self)

    public static let changePlaybackPosition = RemoteCommand(\.changePlaybackPositionCommand, event: MPChangePlaybackPositionCommandEvent.self)

    public static let rating = RemoteCommand(\.ratingCommand, event: MPRatingCommandEvent.self)

    public static let like = RemoteCommand(\.likeCommand, event: MPFeedbackCommandEvent.self)

    public static let dislike = RemoteCommand(\.dislikeCommand, event: MPFeedbackCommandEvent.self)

    public static let bookmark = RemoteCommand(\.bookmarkCommand, event: MPFeedbackCommandEvent.self)
}

public enum Command: CaseIterable {

    case pause, play, stop, togglePlayPause

    case enableLanguageOption, disableLanguageOption

    case changePlaybackRate

    case changeRepeatMode, changeShuffleMode

    case next, previous

    case skipForward, skipBackward

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
        case .enableLanguageOption:   \.enableLanguageOptionCommand
        case .disableLanguageOption:  \.disableLanguageOptionCommand
        case .changePlaybackRate:     \.changePlaybackRateCommand as (MPRemoteCommandCenter) -> MPChangePlaybackRateCommand
        case .changeRepeatMode:       \.changeRepeatModeCommand as (MPRemoteCommandCenter) -> MPChangeRepeatModeCommand
        case .changeShuffleMode:      \.changeShuffleModeCommand as (MPRemoteCommandCenter) -> MPChangeShuffleModeCommand
        case .next:                   \.nextTrackCommand
        case .previous:               \.previousTrackCommand
        case .skipForward:            \.skipForwardCommand as (MPRemoteCommandCenter) -> MPSkipIntervalCommand
        case .skipBackward:           \.skipBackwardCommand as (MPRemoteCommandCenter) -> MPSkipIntervalCommand
        case .seekForward:            \.seekForwardCommand
        case .seekBackward:           \.seekBackwardCommand
        case .changePlaybackPosition: \.changePlaybackPositionCommand as (MPRemoteCommandCenter) -> MPChangePlaybackPositionCommand
        case .rating:                 \.ratingCommand as (MPRemoteCommandCenter) -> MPRatingCommand
        case .like:                   \.likeCommand as (MPRemoteCommandCenter) -> MPFeedbackCommand
        case .dislike:                \.dislikeCommand as (MPRemoteCommandCenter) -> MPFeedbackCommand
        case .bookmark:               \.bookmarkCommand as (MPRemoteCommandCenter) -> MPFeedbackCommand
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
