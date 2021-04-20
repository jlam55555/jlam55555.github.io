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
const buildDir = (module, buildDest) => {
  const pagesYaml = fs.readFileSync(`${SRCDIR}/${module}`, 'utf-8');
  const pages = yaml.parse(pagesYaml);
  for (const page of pages) {
    const {module, template, destination, dataSrc, is404} = page;

    // must specify template or module
    if (template === undefined && module === undefined) {
      console.error('Each index entry must indicate a template or submodule.'
        + `Got: ${page}`);
      process.exit(-1);
    }

    // TODO: should do more error checking

    // submodule, not a subpage; generate recursively
    if (module !== undefined) {
      buildDir(module, `${buildDest}/${destination}`);
      continue;
    }

    // 404 page is specifically built to /404.html, as GitHub Pages expects
    const outDir = `${BUILDDIR}/${buildDest}/${destination === undefined
        ? template : destination}`;
    const outFile = is404 ? `${BUILDDIR}/404.html` : `${outDir}/index.html`;
    const templateFile = `${TEMPLATEDIR}/${template}.pug`;

    // parse extra data
    let data;
    if (dataSrc !== undefined) {
      const dataSrcExt = dataSrc.split('.').pop()
      data = fs.readFileSync(`${SRCDIR}/${dataSrc}`, 'utf-8');

      // special parsing for certain file types
      switch (dataSrcExt) {
        case 'yaml':
          data = yaml.parse(data);
          break;
        case 'pug':
          data = pug.compile(data, {
            filename: `${SRCDIR}/${dataSrc}`
          })();
          break;
        // TODO: can add other special parsing types (e.g., JSON)
      }
    }

    console.log(`Making directory ${outDir}...`);
    fs.mkdirSync(outDir, {recursive: true});

    console.log(`Reading template file ${templateFile}...`);
    const templateFileHtml = pug.renderFile(templateFile, {
      filename: templateFile,
      ...page,
      data: data
    });

    console.log(`Writing compiled file to ${outFile}...`);
    fs.writeFileSync(outFile, templateFileHtml);
  }
};

// begin recursive build
buildDir('index.yaml', '');