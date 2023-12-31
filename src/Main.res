let groupSameFiles = files => {
  files->Array.reduce([], (acc, file) => {
    let maybePrevFile = acc->Array.at(-1)

    switch maybePrevFile {
    | Some(prevFile) => {
        let isSameAsPrev = prevFile === file

        switch isSameAsPrev {
        | true => acc
        | false => acc->Array.concat([file])
        }
      }
    | None => acc->Array.concat([file])
    }
  })
}

let extractFilePaths = (input: array<string>) => {
  /** Anything before '(' */
  let filePathRegExp = %re("/[^(]*/")

  input
  ->Array.map(inputEntry => {
    let maybeFilePathMatch = String.match(inputEntry, filePathRegExp)
    switch maybeFilePathMatch {
    | Some(filePathMatch) => filePathMatch->RegExp.Result.fullMatch->Some
    | None => None
    }
  })
  ->Array.keepSome
  ->groupSameFiles
}

let indexToHumanIndex = index => index + 1

let run = async () => {
  let filePaths = (await Input.readFromStdin())->extractFilePaths
  let stringFilePathsLength = Array.length(filePaths)->indexToHumanIndex->Int.toString

  Console.log("\nTo continue close the opened file\n")

  filePaths->Array.forEachWithIndex((file, index) => {
    let stringIndex = index->indexToHumanIndex->Int.toString

    Console.log(` - Opening ${file} [${stringIndex}/${stringFilePathsLength}]`)
    VsCode.openFile(file, ~wait=true, ())
  })
}

run()->ignore
