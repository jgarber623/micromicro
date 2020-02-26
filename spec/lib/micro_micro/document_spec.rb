describe MicroMicro::Document do
  context 'when markup is not a String' do
    it 'raises an ArgumentError' do
      expect { described_class.new(1, 'https://example.com') }.to raise_error(MicroMicro::ArgumentError, 'markup must be a String (given Integer)')
    end
  end

  context 'when base_url is not a String' do
    it 'raises an ArgumentError' do
      expect { described_class.new('<!doctype html>', 1) }.to raise_error(MicroMicro::ArgumentError, 'base_url must be a String (given Integer)')
    end
  end
end
