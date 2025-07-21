module Denko
  module Behaviors
    module Reader
      # Optimize these since we don't need to care about thread-safety like CRuby.

      def read_using(reader_method, &block)
        @read_type = :regular
        reader_method.call
        block.call(@read_result) if block_given?
        @read_result
      end

      def read(&block)
        @read_type = :regular
        _read
        block.call(@read_result) if block_given?
        @read_result
      end

      def read_raw(reader_method)
        # Can't guarantee read order.
        raise StandardError, "#read_raw unavailable while listening" if @listening

        @read_type = :raw
        reader_method.call
        @read_result
      end

      def update(data)
        @read_result = (@read_type == :raw) ? data : super(data)
        @read_type = :idle
        @read_result
      end
    end
  end
end
