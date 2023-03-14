# frozen_string_literal: true

RSpec.describe MicroMicro::Property do
  subject(:property) { MicroMicro.parse(markup, base_url).items.first.properties.first }

  let(:base_url) { 'http://example.com' }

  describe '#item' do
    let(:markup) do
      <<~HTML.chomp
        <article class="h-entry">
          <div class="e-content">
            <p>Hello, world!</p>
          </div>
        </article>
      HTML
    end

    its(:item) { is_expected.to be_nil }
  end

  describe '#value' do
    let(:markup) do
      <<~HTML.chomp
        <article class="h-entry">
          <div class="e-content h-card">
            <p>Hello, world!</p>
            <p>by <a href="https://sixtwothree.org" class="p-name u-url">Jason Garber</a></p>
          </div>
        </article>
      HTML
    end

    its(:value) do
      is_expected.to eq(
        {
          # rubocop:disable Layout/LineLength
          html: %(<p>Hello, world!</p>\n    <p>by <a href="https://sixtwothree.org/" class="p-name u-url">Jason Garber</a></p>),
          # rubocop:enable Layout/LineLength
          properties: {
            name: ['Jason Garber'],
            url: ['https://sixtwothree.org/']
          },
          type: ['h-card'],
          value: %(Hello, world!\n    by Jason Garber)
        }
      )
    end
  end
end
