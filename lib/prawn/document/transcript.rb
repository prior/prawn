module Prawn
  class Document

    # This method records the raw content and page_resources created by running
    # the associated block.  It returns a Transcipt object that continas this
    # information.  The Transcript object can then later be used with the 
    # replay method to quickly reproduce duplicate pdf pieces.
    def record(&block)
      stream_length = @page_content.stream.length
      block.call
      Transcript.new(@page_content.stream[stream_length..-1], page_resources.dup)
    end

    # This method replays the content associated with the provided transcipt.
    # It also ensures that the appropriate page_resources are also available.
    def replay(transcript)
      transcript.page_resources.each {|k,v| page_resources[k] = v}
      @page_content << transcript.content
    end


    private

    # A Transcript is just a simple struct containing the content string added
    # during recording and a copy of the page_resources after recording
    class Transcript
      attr_reader :content, :page_resources

      def initialize(content, page_resources)
        @content = content
        @page_resources = page_resources
      end

    end
  end
end

