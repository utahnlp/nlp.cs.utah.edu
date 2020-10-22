var http = require('http')
var createHandler = require('node-gitlab-webhook')
var handler = createHandler([ // multiple handlers
  { path: '/master', secret: 'nlp.cs.utah.edu' }
])
// var handler = createHandler({ path: '/master', secret: 'nlp.cs.utah.edu' }) // single handler

http.createServer(function (req, res) {
  handler(req, res, function (err) {
    res.statusCode = 200
    res.end('error:'+err)
  })
}).listen(9999)

handler.on('error', function (err) {
  console.error('Error:', err.message)
})

const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function deploy() {
    const { stdout, stderr } = await exec('./build.sh master git@gitlab.flux.utah.edu:nlpml/nlp.cs.utah.edu.git /uusoc/facility/res/nlp/nlp_web_build/src/ /uusoc/facility/res/nlp/public_html/test/');
      console.log('stdout:', stdout);
        console.log('stderr:', stderr);
}

handler.on('push', function (event) {
  console.log(
    'Received a push event for %s to %s',
    event.payload.repository.name,
    event.payload.ref
  )
  switch (event.path) {
    case '/master':
      deploy()
      break
    default:
      // do sth else or nothing
      break
  }
})
