class IfSimplyFooter < ActiveAdmin::Component
  def build
    super(id: "footer")
    para "Copyright #{Date.today.year} Simple Media Technology, LLC"
  end
end
