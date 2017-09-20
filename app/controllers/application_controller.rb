class ApplicationController < ActionController::Base
    include Clearance::Controller
    protect_from_forgery with: :exception

    def not_sign_in_redirect(url: redirect_default_path, msg: default_msg)
        if !signed_in?
            return redirect_to url, notice: msg
        end
    end

    # let the url to become nil if want to return a boolean
    def belongs_to_current_user?(url: nil,resource: nil, resource_id: nil, msg: default_msg)


        is_owner = resource.find(resource_id).user_id == current_user.id

        if url.nil?
            # return boolean if url is not given
            if is_owner
                return false
            else
                return true
            end
        else
            # redirect user with message
            if !is_owner
                flash[:notice] = msg
                return redirect_to url, notice: msg
            end

        end
    end

    # let the url become nil if want to return boolean
    def resource_exist?(url: redirect_default_path, resource: nil, resource_id: params[:id],msg: default_msg)
        is_exist = !resource.find(resource_id).nil?

        if url.nil?
            # return boolean if url is not given
            if is_exist
                return false
            else
                return true
            end
        else
            # redirect user with message
            if !is_exist
                flash[:notice] = msg
                return redirect_to url, notice: msg
            end
        end

    end

    private

    def redirect_default_path
        root_path
    end

    def default_msg
        'You are not allowed to perform this action'
    end
end
