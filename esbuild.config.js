import esbuild from "esbuild"

const watch = process.argv.includes("--watch")
const minify = process.argv.includes("--minify")

const options = {
  entryPoints: ["frontend/javascript/index.js"],
  bundle: true,
  minify,
  sourcemap: !minify,
  outfile: "output/_bridgetown/static/js/site.js",
  target: ["es2020"],
}

if (watch) {
  const context = await esbuild.context(options)
  await context.watch()
} else {
  await esbuild.build(options)
}
