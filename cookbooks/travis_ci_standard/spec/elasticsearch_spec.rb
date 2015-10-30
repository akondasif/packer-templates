describe 'elasticsearch installation', sudo: true do
  before :all do
    sh('sudo service elasticsearch start')
    sleep 5
    sh('curl -X GET http://localhost:9200/')
    sleep 8
    sh('curl -X PUT \'http://localhost:9200/twitter/user/kimchy\' ' \
       '-d \'{ "name" : "Shay Banon" }\'')
    sh(
      'curl -X PUT \'http://localhost:9200/twitter/tweet/1\' ' \
      '-d \' { "user": "kimchy", "postDate": "2009-11-15T13:12:00", ' \
      '"message": "Trying out Elasticsearch" }\'')
    sleep 8
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe command(
    "curl -X GET 'http://localhost:9200/twitter/tweet/1?pretty=true'"
  ) do
    its(:stdout) { should include('Trying out Elasticsearch') }
  end

  describe command(
    "curl -X GET 'http://localhost:9200/twitter/tweet/_search?q=message:Trying&pretty=true'"
  ) do
    its(:stdout) { should match(/"total": 1/) }
    its(:stdout) { should match(/"user": "kimchy"/) }
    its(:stdout) { should match(/"message": "Trying out Elasticsearch"/) }
  end
end
