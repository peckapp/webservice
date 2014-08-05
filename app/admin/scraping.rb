ActiveAdmin.register_page 'Scraping' do

  content do
    h3 'Main Scraping page, will have lots of useful tools!'
    div '<object type="text/html" data="http://www.williams.edu/" width="800px" height="600px" style="overflow:auto;border:5px ridge blue"></object>'.html_safe
    # script "$(\"#siteloader\") .html('<object data=\"http://www.peckapp.com\"/>');".html_safe
  end

end
