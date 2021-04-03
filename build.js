// a very simple buildsystem for a very simple website
const fs = require('fs');
const fsExtra = require('fs-extra');
const pug = require('pug');
const yaml = require('yaml');

// source file directory
const SRCDIR = './src';

// output file directory
const BUILDDIR = './docs';

// directory to find pug files
const TEMPLATEDIR = `${SRCDIR}/templates`;

// list of files to copy to build directory (path relative to src/build)
const COPYFILES = ['res', 'CNAME'];

// clear builddir
console.log(`Clearing build directory ${BUILDDIR}...`);
fs.rmSync(BUILDDIR, {recursive: true, force: true});

// create builddir
console.log(`Creating build directory ${BUILDDIR}...`);
fs.mkdirSync(BUILDDIR);

// copy files to builddir
console.log(`Copying static files...`);
for (const file of COPYFILES) {
  console.log(`Copying file ${SRCDIR}/${file} -> ${BUILDDIR}/${file}`)
  fsExtra.copySync(`${SRCDIR}/${file}`, `${BUILDDIR}/${file}`);
}

// get pages to build and where to build them
const pagesYaml = fs.readFileSync(`${SRCDIR}/index.yaml`, 'utf-8');
const pages = yaml.parse(pagesYaml);
for (const page of pages) {
  const {template, destination, title, dataSrc} = page;
  const outDir = `${BUILDDIR}/${destination || template}`;
  const outFile = `${outDir}/index.html`;
  const templateFile = `${TEMPLATEDIR}/${template}.pug`;
  const data = dataSrc
    && yaml.parse(fs.readFileSync(`${SRCDIR}/${dataSrc}`, 'utf-8'));

  console.log(`Making directory ${outDir}...`);
  fs.mkdirSync(outDir, {recursive: true});

  console.log(`Reading template file ${templateFile}...`);
  const templateFileHtml = pug.renderFile(templateFile, {
    title: title,
    data: data
  });

  console.log(`Writing compiled file to ${outFile}...`);
  fs.writeFileSync(outFile, templateFileHtml);
}
