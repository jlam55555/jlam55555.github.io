// a very simple buildsystem for a very simple website
const fs = require('fs');
const fsExtra = require('fs-extra');
const pug = require('pug');
const yaml = require('yaml');

const BUILDDIR = './docs';
const TEMPLATEDIR = './src/templates';
const RESDIR = './src/res';

// clear builddir
console.log(`Clearing build directory ${BUILDDIR}...`);
fs.rmSync(BUILDDIR, {recursive: true, force: true});

// create builddir
console.log(`Creating build directory ${BUILDDIR}...`);
fs.mkdirSync(BUILDDIR);

// copy res to builddir (symlink doesn't work in GitHub pages)
console.log(`Symlinking resource directory to ${RESDIR}...`);
fsExtra.copySync(RESDIR, `${BUILDDIR}/res`);

// get pages to build and where to build them
const pagesYaml = fs.readFileSync('src/pages.yaml', 'utf-8');
const pages = yaml.parse(pagesYaml);
for (const page of pages) {
  const {template, destination, title} = page;
  const outDir = `${BUILDDIR}/${destination || template}`;
  const outFile = `${outDir}/index.html`;
  const templateFile = `${TEMPLATEDIR}/${template}.pug`;

  console.log(`Making directory ${outDir}...`);
  fs.mkdirSync(outDir, {recursive: true});

  console.log(`Reading template file ${templateFile}...`);
  const templateFileHtml = pug.renderFile(templateFile, {
    title: title
  });

  console.log(`Writing compiled file to ${outFile}...`);
  fs.writeFileSync(outFile, templateFileHtml);
}
