#	README

###	Steps to follow for integrating two factor authentication using Duo with Rails
*	Sign up for a Duo Account: (https://signup.duo.com/)
*	Login to the Duo Admin Panel: (https://admin.duosecurity.com)
*	Click 'Protect an Application' and locate Web SDK, click 'protect this application'
*	Prepare a `.yml` file under config folder (ex. `/config/duo_cred.yml`) file to store credentials as given in the admin panel of Integration Key, Secret Key and API hostname and add it as below
	```sh
	DUO_IKEY: DIXXX
	DUO_SKEY: lMXXX
	DUO_HOST: api-XXX.duosecurity.com
	```
* 	Generate a random 40 character string by `SecureRandom.gen_random(40)` and add it to your 'duo_cred.yml' file as your DUO akey
	```sh
	DUO_IKEY: DIXXX
	DUO_SKEY: lMXXX
	DUO_HOST: api-XXX.duosecurity.com
	DUO_AKEY: R*\x14\XXX
	```
*	Add `require 'yaml'` in `application.rb` located in `/config/application.rb`
*	Load the Yaml file into the initializer folder by creating file as `duo.rb` located in `/config/initializers/duo.rb` and add following line of code
	```sh
	DUO = YAML.load_file(Rails.root.join('config/duo_cred.yml'))
	```
*	Add associated Gem as `gem 'duo_web', '~> 1.0'` and run `bundle`
*	Change the routes from `routes.rb` as
	```sh
	root to: 'dashboards#duo'
	resources :dashboards do
		post :duo_verify, on: :collection
	end
	# post '/dashboard/duo_verify', to: 'dashboard#duo_verify', as: :duo_verify
	# get '/dashboard/duo', to: 'dashboard#duo', as: :duo
	  ```
*	Add Controller methods into DashboardController (or in the sign-in/signup controller)
	```sh
	def duo
		@sig_request = Duo.sign_request(DUO['DUO_IKEY'], DUO['DUO_SKEY'], DUO['DUO_AKEY'], "123456")
	end
	def duo_verify
		@authenticated_user = Duo.verify_response(DUO['DUO_IKEY'], DUO['DUO_SKEY'], DUO['DUO_AKEY'], params["sig_response"])
		if @authenticated_user
	  		session[:duo_auth] = true
	  		redirect_to dashboards_path
		else
	  		redirect_to new_dashboard_path
	  		# redirect_to unauthenticated_root_path
		end
	end
	```
*	Now create `duo.html.erb` located as `/app/views/dashboards/duo.html.erb` and add following code
	```sh
	<script src="https://api.duosecurity.com/frame/hosted/Duo-Web-v2.js" type="text/javascript"></script>
	<iframe id="duo_iframe"
			data-host="<%= DUO['DUO_HOST'] %>"
			data-sig-request="<%= @sig_request %>"
			data-post-action="dashboards/duo_verify">
			<!-- data-post-action="<%#= duo_verify_dashboards_path(sig_response: @sig_request, method: :post) %>"> -->
	</iframe>
	<style>
	  #duo_iframe {
	    width: 100%;
	    min-width: 304px;
	    max-width: 620px;
	    height: 330px;
	    border: none;
	  }
	</style>
	```
*	Don't forget to skip the authentication in DashboardController
	```sh
	skip_before_action :require_no_authentication, only: [:duo_verify]
 	skip_before_action :verify_authenticity_token
	```
*	Run the server with `rails s`
*	Cheers!
*	For more detail over the topic (https://medium.com/@tjoye20/ruby-on-rails-setting-up-duo-two-factor-authentication-with-devise-b6a9c1a025e0)
