xml.instruct!

  xml.feature do
    @experiment.each do |feature|
      xml.email do
        xml.to feature.start
        xml.from feature.end
        xml.subject feature.quality
      end
    end
  end