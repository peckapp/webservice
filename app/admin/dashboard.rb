ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      columns do
        column do
          panel "Deployment Information" do
            link = link_to(`git rev-parse --short HEAD`, "https://github.com/peckapp/webservice/commit/#{`git rev-parse HEAD`}")
            para %(<h4>Currently deployed:</h4> <br/> <b> #{`git log -1 --pretty=%B`} </b> , #{link}).html_safe
          end
        end
        column do
          panel "Application Status" do
            para %(<h4>Current Statistics:</h4> #{simple_format(`iostat`)}).html_safe
          end
        end
        column do
          panel "Other Information" do
            para %(<b>Main Website:</b> #{link_to('www.peckapp.com', "https://www.peckapp.com")}).html_safe
          end
        end
      end
    end

    # Here is an example of a simple dashboard with columns and panels.

    columns do
      column do
        panel "Recent SimpleEvents" do
          ul do
            SimpleEvent.sorted.take(5).map do |event|
              li link_to(event.title, admin_simple_event_path(event))
            end
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to ActiveAdmin."
        end
      end
    end # end columns
  end # content
end
