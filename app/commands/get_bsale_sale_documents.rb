class GetBsaleSaleDocuments < PowerTypes::Command.new(:opts ={})
def perform (opts ={})
  document= Bsale::Document.new(opts[:limit],opts[:offset],opts[:fields],opts[:expand],opts[:emissiondate],opts[:expirationdate],opts[:emissiondaterange],opts[:number],opts[:token],opts[:documenttypeid],opts[:clientid],opts[:clientcode],opts[:officeid],opts[:saleconditionid],opts[:informedsii],opts[:codesii],opts[:totalamount],opts[:referencecode],opts[:referencenumber],opts[:state])
  docu = document.all(document.to_h)
  docu.slice(:id, :document_type)
 
  @docu_arr= []

  doc = {"document_type" => "",
        "bsale_id"=>"",
        "alegra_id"=>"" }

  docu.each do |key, x|
    if key == "id"
      doc["id"]= x
    end 
    elsif key == "document_type" 
       x.each do |key2, value|
        if key2== "id"
          doc["document_type"]=value
        end
      end 
    @docu_arr.push (doc) 
    end

  @docu_arr.each do |key,value|
    if key == "id" 
      @docu_arr.find_or_create_by(id : key)
    end
end
