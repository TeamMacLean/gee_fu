#Implements the REST interface for returning the references that belong to a Genome
class ReferencesController < ApplicationController
  
  #returns the list of references and associated data in the database
  # use /references.format?params
  # where format = xml or json
  def index #regular web request
    @references = Reference.all
    respond @references
  end
  
  #returns the list of references belonging to Genome id and associated data in the database
  # use /references/id.format?params
  # where format = xml or json
  # optional params: 
  # => name (some_reference_name) returns the reference with name
  # => sequence=true  returns the reference sequence (if available..)
  def show  
  
    if params[:name]
      if Genome.exists?(params[:id])
        @reference = Reference.first(:conditions => {:genome_id => params[:id], :name => params[:name] } )
        if @reference
          if params[:sequence] #fold in the reference sequence..
            @reference = { :name => @reference.name,
                    :id => @reference.id,
                    :length => @reference.length,
                    :genome_id => @reference.genome_id,
                    :created_at => @reference.created_at,
                    :sequence => @reference.sequence
                }
          end
          #respond_to do |format|
          #  format.json { render :json => @reference.to_json(:include => @reference.sequence) }
          #  format.xml  { render :xml => @reference.to_xml(:include => @reference.sequence) }
          #end
          respond @reference
        else
          respond :false
        end
      else
        respond :false
      end

    else  
      if Genome.exists?(params[:id])
        @references = Reference.first(:conditions => {:genome_id => params[:id]} )
        respond @references
      else
        respond :false
      end
    end
    
    
  end
  
  def respond(response)
    respond_to do |format|
      format.json { render :json => response, :layout => false }
      format.xml  { render :xml => response, :layout => false }
    end
  end
  
end
