//
//  RemoteCommandController.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/9/11.
//

import MediaPlayer

class RemoteCommandController {

    func setupCommands(
        _ commands: [Command],
        disabledCommands: [Command] = [],
        commandHandler: @escaping (Command, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus
    ) {
        for command in Command.allCases {
            command.remoteHandler()

            if commands.contains(command) {
                command.addHandler(commandHandler)
            }

            command.setEnabled(disabledCommands.contains(command))
        }
    }

    func addCommand<Event>(
        _ command: RemoteCommand<Event>,
        handler: @escaping (Event) -> MPRemoteCommandHandlerStatus
    ) {
        command.addHandler(handler)
    }
}
