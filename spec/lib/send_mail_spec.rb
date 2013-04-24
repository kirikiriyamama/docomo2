require 'spec_helper'

require File.join(PATH, 'lib', 'send_mail')


describe '#send_mail' do
	before :all do
		config_path = File.join(PATH, 'config', 'email_delivery.yml')

		@config = YAML.load_file(config_path).symbolize_keys[ENVIRONMENT.to_sym]
		@message = send_mail(config_path, 'subject', 'body')
	end

	context '送信に成功した場合' do
		it { @message.to.should == @config[:to] }
		it { @message.subject.should == 'subject' }
		it { @message.body.raw_source.should == 'body' }
	end
end
