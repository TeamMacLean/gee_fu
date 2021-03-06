class RegistrationsController < Devise::RegistrationsController
  def create
    email = params[:user][:email]
    password = params[:user][:password]

    logger.error "Hello #{email} - #{password}"

    webApolloOutput = `createuser -U postgres #{email} --createdb --no-superuser --no-createrole`

    webApolloOutputTwo = `#{WebApolloPath}/tools/user/add_user.pl -D #{WebApolloDatabase} -U #{WebApolloDatabaseUsername} -P #{WebApolloDatabasePassword} -u #{email} -p #{password}`

    webApolloOutputThree = `#{WebApolloPath}/tools/user/set_track_permissions.pl -D #{WebApolloDatabase} -U #{WebApolloDatabaseUsername} -P #{WebApolloDatabasePassword} -r -w -u #{email} -t #{WebApolloPath}/data/scratch/seqids.txt  > /dev/null`


    # if(waUserAdded)
    # 	logger.error "{email} user added to database"
    # else
    # 	logger.error "ONE FAILED"
    # end
    # if(waUserAddedTwo)
    # 	logger.error "{email} user added to WebApollo"
    # else
    # 	logger.error "TWO FAILED"
    # end
    # logger.error "FINISHED WEBAPOLLO STUFF"

    super
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    signed_up_path
  end

end