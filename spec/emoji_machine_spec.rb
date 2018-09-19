# frozen_string_literal: true

describe EmojiMachine do
  describe 'text' do
    it 'handles normal text' do
      machine = EmojiMachine.new('my text')
      expect(machine.text).to eq 'my text'
    end

    it 'handles normal text with emoji' do
      machine = EmojiMachine.new('my text :joy: :rocket:')
      expect(machine.text).to eq 'my text'
    end

    it 'handles emoji with no text' do
      machine = EmojiMachine.new(':joy: :rocket:')
      expect(machine.text).to eq ''
    end

    it 'handles no text at all' do
      machine = EmojiMachine.new('')
      expect(machine.text).to eq ''
    end
  end

  describe 'emoji' do
    it 'handles normal text' do
      machine = EmojiMachine.new('my text')
      expect(machine.emoji).to eq []
    end

    it 'handles normal text with emoji' do
      machine = EmojiMachine.new('my text :joy: :rocket:')
      expect(machine.emoji).to eq [':joy:', ':rocket:']
    end

    it 'handles emoji with no text' do
      machine = EmojiMachine.new(':joy: :rocket:')
      expect(machine.emoji).to eq [':joy:', ':rocket:']
    end

    it 'handles no text at all' do
      machine = EmojiMachine.new('')
      expect(machine.emoji).to eq []
    end
  end
end
