# frozen_string_literal: true

RSpec.describe RuboCop::Cop::InternalAffairs::UselessRestrictOnSend, :config do
  it 'registers an offense when using `RESTRICT_ON_SEND` and not defines send callback method' do
    expect_offense(<<~RUBY)
      class FooCop
        RESTRICT_ON_SEND = %i[bad_method].freeze
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Useless `RESTRICT_ON_SEND` is defined.
      end
    RUBY

    expect_correction(<<~RUBY)
      class FooCop
      #{'  '}
      end
    RUBY
  end

  it 'does not register an offense when using `RESTRICT_ON_SEND` and defines `on_send`' do
    expect_no_offenses(<<~RUBY)
      class FooCop
        RESTRICT_ON_SEND = %i[bad_method].freeze
        def on_send(node)
          # ...
        end
      end
    RUBY
  end

  it 'does not register an offense when using `RESTRICT_ON_SEND` and defines `after_send`' do
    expect_no_offenses(<<~RUBY)
      class FooCop
        RESTRICT_ON_SEND = %i[bad_method].freeze
        def after_send(node)
          # ...
        end
      end
    RUBY
  end
end
