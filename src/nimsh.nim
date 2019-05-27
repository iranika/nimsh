# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import os, osproc, rdstdin, strformat, strutils, terminal, times, strformat

var
  currentExpression = ""

proc getPromptSymbol(): string =
  result = "nimsh> "

proc cleanExit(exitCode = 0) =
  quit(exitCode)

proc runForever() =
  while true:
    try:
      currentExpression = readLineFromStdin(getPromptSymbol()).strip
    except IOError:
      continue
    
    if currentExpression in ["exit", "exit()", "quit", "quit()"]:
      cleanExit()
    
    stdout.writeLine($currentExpression)

proc init() = 
  return

proc main() =
  init()

  runForever()


when isMainModule:
  import cligen
  dispatch(main, help = {})
