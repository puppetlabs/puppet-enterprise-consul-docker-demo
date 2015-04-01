require 'spec_helper'
describe 'unattended_upgrades' do

  context 'with defaults for all parameters' do
    it { should contain_class('unattended_upgrades') }
  end
end
