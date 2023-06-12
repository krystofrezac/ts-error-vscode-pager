let openFile = (file, ~wait, ()) => {
  open NodeJs

  let waitFlag = switch wait {
  | true => "--wait"
  | false => ""
  }

  let command = `code ${file} ${waitFlag}`
  ChildProcess.execSync(command)->ignore
}
