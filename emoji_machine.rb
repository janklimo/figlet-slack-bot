# frozen_string_literal: true

class EmojiMachine
  attr_accessor :figlet, :text_input

  FIGLET_BODY_DEFAULT = ':smile:'
  FIGLET_BACKGROUND_DEFAULT = ':cloud:'
  REGEX = /:[\w-]+:/

  def initialize(text)
    font = Figlet::Font.new(font_path('banner'))
    @figlet = Figlet::Typesetter.new(font)
    @text_input = text
  end

  def generate_text
    figlet[text]
      .gsub!('#', emoji[0] || FIGLET_BODY_DEFAULT)
      .gsub!(' ', emoji[1] || FIGLET_BACKGROUND_DEFAULT)
  end

  def text
    text_input.dup.tap do |t|
      # keep the text only by removing all emoji
      t.gsub!(REGEX, '')
      t.squish!
    end
  end

  def emoji
    # the first emoji given becomes text body, the second one background
    text_input.scan(REGEX).flatten
  end

  private

  def font_path(font_name)
    File.join(File.dirname(__FILE__), 'fonts', "#{font_name}.flf")
  end
end
