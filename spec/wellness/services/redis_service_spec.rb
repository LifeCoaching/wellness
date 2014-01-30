require 'spec_helper'

describe Wellness::Services::RedisService do
  let(:params) {
    {
      redis: {
        url: 'redis://127.0.0.1:6379/0'
      }
    }
  }
  let(:service) { described_class.new(params) }
  let(:redis_info) {
    {
      'uptime_in_seconds' => '612488',
      'uptime_in_days' => '7',
      'connected_clients' => '1',
      'used_memory_human' => '979.22K',
      'total_connections_received' => '2',
      'total_commands_processed' => '1',
      'rejected_connections' => '0',
      'sync_full' => '0',
      'sync_partial_ok' => '0',
      'sync_partial_err' => '0',
      'expired_keys' => '0',
      'evicted_keys' => '0',
      'keyspace_hits' => '0',
      'keyspace_misses' => '0'
    }
  }
  describe '#check' do
    subject { service.check }
    context 'when redis can\'t connect' do
      it 'fails the health check' do
        expect(subject).to include(status: 'UNHEALTHY')
      end
    end
    context 'when redis returns the its details' do
      let(:client) { double('Redis', info: redis_info) }
      before do
        service.stub(build_client: client)
      end
      it 'passes the health check' do
        expect(subject).to include(status: 'HEALTHY')
      end
    end
  end
end