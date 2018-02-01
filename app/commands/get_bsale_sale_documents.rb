class GetBsaleSaleDocuments < PowerTypes::Command.new(:opts ={})
def perform (opts ={})
  document= Bsale::Document.new(opts[:limit],opts[:offset],opts[:fields],opts[:expand],opts[:emissiondate],opts[:expirationdate],opts[:emissiondaterange],opts[:number],opts[:token],opts[:documenttypeid],opts[:clientid],opts[:clientcode],opts[:officeid],opts[:saleconditionid],opts[:informedsii],opts[:codesii],opts[:totalamount],opts[:referencecode],opts[:referencenumber],opts[:state])
  docu = document.all(document.to_h)
  docu.slice(:id, :document_type)
 
  docu = document.map do |key, x|
 
    if key == "document_type" do
       @documents = 
       @documents.save

end
end
