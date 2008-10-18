# encoding: utf-8

require File.join(File.expand_path(File.dirname(__FILE__)), "spec_helper")

def add_static_content(pdf) #TODO: needs to be more comprehensive
  pdf.instance_eval do
    font('Helvetica')
    font.size = 40
    text "Hello World"
    font.size = 10
    text "Hello Tiny World"
    line_width = 10
    stroke_line(0,0,bounds.width,bounds.height)
  end
end


# TODO:  test is probably brittle since it assumes unordered hashes will always be translated in the same order-- how to fix?
# though maybe this isn't an issue with 1.9?
describe "A transcript" do

  it "should reproduce a static construction exactly as reinvoking the same high level methods would" do
    @slow_pdf = Prawn::Document.new
    add_static_content @slow_pdf
    @slow_pdf.start_new_page
    add_static_content @slow_pdf

    @fast_pdf = Prawn::Document.new
    transcript = @fast_pdf.record { add_static_content(@fast_pdf) }
    @fast_pdf.start_new_page
    @fast_pdf.replay transcript

    @fast_pdf.render.should == @slow_pdf.render
  end

end
