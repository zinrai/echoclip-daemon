# echoclip-daemon

A daemon script that listens for network connections and copies received data to the macOS clipboard.

## Background

The motivation behind this tool was to enable seamless clipboard integration between [tmux](https://github.com/tmux/tmux/wiki) sessions running on a Debian GNU/Linux virtual machine and the macOS host system. It allows text copied within tmux to be immediately available for pasting in macOS applications.

## Features

- Automatic daemon process management
- Proper handling of termination signals
- Checks for required commands before starting
- Prevents duplicate instances
- Continues running after terminal session ends
- Automatic cleanup of child processes on termination

## Requirements

- macOS operating system
- `nc` (netcat) command
- `pbcopy` command (included in macOS by default)

## Usage

### Starting the Daemon

```bash
$ ./echoclip-daemon.sh
```

The script will automatically:
- Check for required commands
- Terminate any existing instances
- Start a new daemon process in the background

### Sending Data to Clipboard

From another machine on the network, you can send data to the clipboard using netcat:

```bash
echo "Hello World" | nc localhost 12345
```

### Stopping the Daemon

To stop the daemon, use either of these commands:

```bash
$ pkill -f echoclip-deamon.sh
```

## License

This project is licensed under the MIT License - see the [LICENSE](https://opensource.org/license/mit) for details.
