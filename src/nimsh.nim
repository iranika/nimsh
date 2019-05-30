# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import os, osproc, rdstdin, strformat, strutils, terminal, times, strformat


proc lsh_read_line(): string =
  result = readLineFromStdin(">").strip


const LSH_TOK_SEPS: set[char] = {' ','\t','\r','\n','\a'}
proc lsh_split_line(line: string): seq[string] =
  result = line.split(LSH_TOK_SEPS)

proc lsh_cd(args: seq[string]): int =
  echo "cd is builtin command."
  echo "args :" & $args
  return 1

proc lsh_ls(args: seq[string]): int =
  echo "ls is builtin command."
  echo "args :" & $args
  return 1

proc lsh_exit(args: seq[string]): int =
  echo "Good bye"
  return 0

type builtin_command = object
  name: string
  fn: proc (args: seq[string]): int
var
  BUILTIN_COMMANDS: seq[builtin_command] = @[
    builtin_command(name:"ls", fn:lsh_ls),
    builtin_command(name:"cd", fn:lsh_cd),
    builtin_command(name:"exit", fn:lsh_exit),
  ]

proc lsh_execute(args: seq[string]): int =
  if args.len == 0:
    return 0
  
  for cmd in BUILTIN_COMMANDS:
    if args[0] == cmd.name:
      return cmd.fn(args)

proc runForever() =
  var line: string
  var args: seq[string]
  var status: int

  while (status == 1):
    line = lsh_read_line()
    args = lsh_split_line(line)
    status = lsh_execute(args)








proc init() = 
  return

proc main() =
  init()

  runForever()


when isMainModule:
  import cligen
  dispatch(main, help = {})
