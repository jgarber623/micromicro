describe MicroMicro::ParsedDocument do
  context 'when markup is not a String' do
    it 'raises an ArgumentError' do
      expect { described_class.new(1) }.to raise_error(MicroMicro::ArgumentError, 'markup must be a String (given Integer)')
    end
  end
end
