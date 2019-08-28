require 'net/http'
require 'json'




ORGANIZATION = 'uhayatkhan';
PROJECT = 'circleci-demo-ruby-rails';

TOKEN = ENV['CIRCLE_API_TOKEN'] #process.env.CIRCLE_API_TOKEN;
BRANCH = 'master';
URL = `https://circleci.com/api/v1.1/project/github/#{ORGANIZATION}/#{PROJECT}/tree/#{BRANCH}?circle-token=#{TOKEN}&shallow=true&filter=running`;
print(URL)

INTERVAL = 20;
CURRENTBUILDNUM = ENV['CIRCLE_BUILD_NUM'] #ENV['CIRCLE_BUILD_NUM']
print(ENV['CIRCLE_BUILD_NUM'])
JOB = 'build';

def  wait
  uri = URI('https://circleci.com/api/v1.1/project/github/uhayatkhan/circleci-demo-ruby-rails/tree/master?circle-token=ce62040f14d50d1a16390838d47b2379c40965be&shallow=true')
  response = Net::HTTP.get(uri)
  builds = JSON.parse(response)

  if builds[0].has_key? 'workflows'
  	if builds[0]['workflows']['job_name'] == JOB
  		isSameJob = true
  	end
  end
  print(builds[0]['build_num'])
  print(Integer(CURRENTBUILDNUM))
  if (Integer(builds[0]['build_num']) != Integer(CURRENTBUILDNUM))
  	isDifferentBuild = true
  end

  if isSameJob && isDifferentBuild
  	print("Another staging deployment already running, will check again in #{INTERVAL} seconds...")
  	sleep INTERVAL
    puts wait
  else
  	print("No other staging deployment already running, build started without wait.")
  end 

end

puts wait

