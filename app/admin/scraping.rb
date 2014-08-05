ActiveAdmin.register_page 'Scraping' do

  content do
    para 'Main Scraping page, will have lots of cool tools!'
    div '<object type="text/html" data="http://validator.w3.org/" width="800px" height="600px" style="overflow:auto;border:5px ridge blue"></object>'.html_safe
    # script "$(\"#siteloader\") .html('<object data=\"http://www.peckapp.com\"/>');".html_safe
  end

end
