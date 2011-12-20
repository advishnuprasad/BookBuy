class CurrencyratesController < ApplicationController
  # GET /currencyrates
  # GET /currencyrates.xml
  def index
    @currencyrates = Currencyrate.order('code1').order('code2').paginate(:per_page => 15, :page => params[:page])

    breadcrumbs.add 'Currency Rates'
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @currencyrates }
    end
  end

  # GET /currencyrates/1
  # GET /currencyrates/1.xml
  def show
    @currencyrate = Currencyrate.find(params[:id])

    breadcrumbs.add 'Currency Rates', currencyrates_path
    breadcrumbs.add @currencyrate.code1 + "-" + @currencyrate.code2
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @currencyrate }
    end
  end

  # GET /currencyrates/new
  # GET /currencyrates/new.xml
  def new
    @currencyrate = Currencyrate.new

    breadcrumbs.add 'Currency Rates', currencyrates_path
    breadcrumbs.add 'New'
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @currencyrate }
    end
  end

  # GET /currencyrates/1/edit
  def edit
    @currencyrate = Currencyrate.find(params[:id])
    
    breadcrumbs.add 'Currency Rates', currencyrates_path
    breadcrumbs.add @currencyrate.code1 + "-" + @currencyrate.code2
  end

  # POST /currencyrates
  # POST /currencyrates.xml
  def create
    @currencyrate = Currencyrate.new(params[:currencyrate])
    @currencyrate.created_by = current_user.id
    
    respond_to do |format|
      if @currencyrate.save
        format.html { 
          flash[:success] = 'Currency Rate was successfully created.'
          redirect_to(@currencyrate) 
        }
        format.xml  { render :xml => @currencyrate, :status => :created, :location => @currencyrate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @currencyrate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /currencyrates/1
  # PUT /currencyrates/1.xml
  def update
    @currencyrate = Currencyrate.find(params[:id])
    @currencyrate.modified_by = current_user.id
    
    respond_to do |format|
      if @currencyrate.update_attributes(params[:currencyrate])
        format.html { 
          flash[:success] = 'Currency Rate was successfully updated.'
          redirect_to(@currencyrate)
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @currencyrate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /currencyrates/1
  # DELETE /currencyrates/1.xml
  def destroy
    @currencyrate = Currencyrate.find(params[:id])
    @currencyrate.destroy

    respond_to do |format|
      format.html { redirect_to(currencyrates_url) }
      format.xml  { head :ok }
    end
  end
end
