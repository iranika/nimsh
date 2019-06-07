# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import rdstdin, strutils, terminal
import posix

proc lsh_read_line(): string =
  result = readLineFromStdin(">").strip

const LSH_TOK_SEPS: set[char] = {' ','\t','\r','\n','\a'}
proc lsh_split_line(line: string): seq[string] =
  result = line.split(LSH_TOK_SEPS)

proc lsh_cd(args: seq[string]): int =
  if args.len == 1:
    stderr.write("lsh: expected argument to \"cd\"\n")
  else:
    if chdir(args[1]) != 0:
      stderr.write("lsh: argument is invalid.\n")
  return 0

proc lsh_exit(args: seq[string]): int =
  echo "Good bye"
  return -1

type builtin_command = object
  name: string
  fn: proc (args: seq[string]): int
var
  BUILTIN_COMMANDS: seq[builtin_command] = @[
    builtin_command(name:"cd", fn:lsh_cd),
    builtin_command(name:"exit", fn:lsh_exit),
    builtin_command(name:"quit", fn:lsh_exit),
  ]

proc lsh_launch(args: seq[string]): int =
  var status :cint

  var pid = fork()
  if pid == 0:
    #child process
    if execvp(args[0], args.allocCStringArray()) == -1:
      stderr.write("command execute error.\n")
    quit(0)
  elif pid < 0:
    stderr.write("fork error.\n")
  else:
    #Parent process  
    let wpid = waitpid(pid, status, WUNTRACED)
    if WIFEXITED(status):
      return 0
  return 0

proc lsh_execute(args: seq[string]): int =
  if args.len == 1:
    if isNilOrEmpty(args[0]):
      return 0
  
  for cmd in BUILTIN_COMMANDS:
    if args[0] == cmd.name:
      return cmd.fn(args)
  
  return lsh_launch(args)

proc runForever() =
  var line: string
  var args: seq[string]
  var status: int

  while (status == 0):
    line = lsh_read_line()
    args = lsh_split_line(line)
    status = lsh_execute(args)

proc init() = 
  echo("Welcome to nimsh! 🍣")
  
  return

proc main() =
  init()
  runForever()

when isMainModule:
  import cligen
  dispatch(main, help = {})
