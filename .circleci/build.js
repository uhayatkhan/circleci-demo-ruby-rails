const fetch = require('node-fetch');

const organization = 'uhayatkhan';
const project = 'circleci-demo-ruby-rails';
// This is the environment variable added via CircleCI UI
const token = process.env.CIRCLE_API_TOKEN;
const branch = 'master';
const url = `https://circleci.com/api/v1.1/project/github/${organization}/${project}/tree/${branch}?circle-token=${token}&shallow=true&filter=running`;

// This is a build-in environment variable
const currentBuildNum = process.env.CIRCLE_BUILD_NUM;
const job = 'build';
const interval = 20000;
  
async function wait() {
  const resp = await fetch(url);
  const builds = await resp.json();

  const otherStagingDeployRunning = builds.find(build => {
    const isSameJob = (build.workflows && build.workflows.job_name) === job;
    // Need parsing because the API response `build_num` is a number
    // but the environment variable is a string
    const isDifferentBuild = parseInt(build.build_num) !== parseInt(currentBuildNum);

    return isSameJob && isDifferentBuild;
  });

  if (otherStagingDeployRunning) {
    // Something must be logged to prevent the job from timing out
    console.log(`Another staging deployment already running (build ${otherStagingDeployRunning.build_num}), will check again in ${interval / 1000} seconds...`);
    setTimeout(wait, interval);
  } else {
    process.exit(0);
  }
}

wait();
