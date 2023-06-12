let formatInput = input => {
  /*
  Starts with:
    yarn run v1.22.19
    $ tsc --noEmit
  Ends with: 
    info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
 */
  input->String.split("\n")->Array.slice(~start=2, ~end=-2)
}

let readFromStdin = () => {
  open NodeJs

  let stdinString = ref("")

  Promise.make((resolve, _reject) =>
    Process.process
    ->Process.stdin
    ->Stream.onData(chunk =>
      stdinString := chunk->Buffer.toString->String.concat(stdinString.contents, _)
    )
    ->Stream.onEnd(() => stdinString.contents->formatInput->resolve(. _))
    ->ignore
  )
}
