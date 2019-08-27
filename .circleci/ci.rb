
require 'net/http'
require 'json'
require 'async/await'
include Async::Await

ORGANIZATION = '';
PROJECT = '';
# This is the environment variable added via CircleCI UI
TOKEN = ENV['CIRCLE_API_TOKEN'] #process.env.CIRCLE_API_TOKEN;
BRANCH = 'devops';
URL = `https://circleci.com/api/v1.1/project/github/#{ORGANIZATION}/#{PROJECT}/tree/#{BRANCH}?circle-token=#{TOKEN}&shallow=true&filter=running`;

# This is a build-in environment variable
CURRENTBUILDNUM = ENV['CIRCLE_BUILD_NUM'] #process.env.CIRCLE_BUILD_NUM;  
JOB = 'auto-deploy';
INTERVAL = 20000;
  

async def  wait() {
  uri = URI(URL)
  response = Net::HTTP.get(uri)
  builds = JSON.parse(response)
  print(builds)
}

wait()


