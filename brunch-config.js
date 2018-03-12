module.exports = {
  config: {
    server: {
      port: 3000
    },
    paths: {
      watched: ["src", "spec"]
    },
    files: {
      javascripts: { joinTo: "javascripts/application.js" }
    },
    plugins: {
      elmBrunch: {
        mainModules: ['src/elm/Main.elm'],
        outputFolder: "public/javascripts/",
        outputFile: "elm.js"
      }
    }
  }
}
