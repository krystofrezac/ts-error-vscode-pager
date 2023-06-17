let formatInput = input => {
  /*
  Starts with:
    yarn run v1.22.19
    $ tsc --noEmit
  Ends with: 
    info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
 */
  let inputBody = input->String.split("\n")->Array.slice(~start=2, ~end=-2)

  let groupedErrors = inputBody->Array.reduce([], (acc, line) => {
    let startsWithWhiteSpaceRegExp = %re("/^\s/")
    let belongsToPreviousLine = RegExp.test(startsWithWhiteSpaceRegExp, line)

    switch belongsToPreviousLine {
    | true => {
        let previousLineOption = Array.at(acc, -1)

        switch previousLineOption {
        | Some(previousLine) => {
            let accWithoutPreviousLine = Array.slice(acc, ~start=0, ~end=-1)
            let newLastLine = `${previousLine}\n${line}`
            Array.concat(accWithoutPreviousLine, [newLastLine])
          }
        | None => acc
        }
      }
    | false => Array.concat(acc, [line])
    }
  })
  groupedErrors
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
