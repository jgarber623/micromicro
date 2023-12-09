# frozen_string_literal: true

RSpec.describe MicroMicro, ".parse" do
  subject(:document) { described_class.parse(markup, base_url) }

  let(:base_url) { "http://example.com" }

  let(:markup) do
    <<~HTML.chomp
      <article class="h-entry">
        <h1 class="p-name">Hello, world!</h1>
      </article>
    HTML
  end

  it { is_expected.to be_a(MicroMicro::Document) }
end
