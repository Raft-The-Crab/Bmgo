const fs = require('fs');
const path = require('path');

function walk(dir, cb) {
  fs.readdirSync(dir).forEach(f => {
    const full = path.join(dir, f);
    if (fs.statSync(full).isDirectory()) walk(full, cb);
    else cb(full);
  });
}

const results = [];
walk(process.cwd(), (file) => {
  if (/smali.*\.smali$/.test(file)) {
    const content = fs.readFileSync(file, 'utf8');
    if (content.indexOf('setDefaultUncaughtExceptionHandler') !== -1 || content.indexOf('setUncaughtExceptionHandler') !== -1) {
      results.push(file);
    }
  }
});

if (!results.length) console.log('No setDefaultUncaughtExceptionHandler/setUncaughtExceptionHandler occurrences found');
else {
  console.log('Found occurrences in:');
  results.forEach(r => console.log(' -', path.relative(process.cwd(), r)));
}
