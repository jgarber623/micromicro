# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::ItemsCollection do
  subject(:items_collection) { MicroMicro.parse(markup, base_url).items }

  let(:base_url) { 'http://example.com' }

  let(:markup) do
    <<~HTML.chomp
      <article class="h-entry">
        <h1 class="p-name">Hello, world!</h1>
      </article>
    HTML
  end

  its(:types) { is_expected.to eq(['h-entry']) }
end
