class ApplicationController < ActionController::Base

    def authenticate_user
        # Validate the token if any
        return render json: { messages: [I18n.t("error.messages.unauthenticated")]}, status: 401 if request.headers["Authorization"].blank?
        begin
            payload = JWT.decode request.headers["Authorization"].delete_prefix("Bearer "), Rails.application.credentials.secret_key_base, 'HS256'
            # Add the @current_user
            @current_user = User.find payload[0]["id"]
        rescue
            # render :unauthenticated if invalid token
            return render json: { messages: [I18n.t("error.messages.unauthenticated")]}, status: 401
        end
    end

    protected

    def paginatable_params
        # Add default pagination params
        params[:meta] ||= {}
        if params[:meta].is_a? String
            params[:meta] = JSON.parse(params[:meta])
        end
        params[:meta][:pagination] ||= {}
        params[:meta][:pagination].permit(:is_first_page, :is_last_page, :next_page, :prev_page, :page, :per_page, :total_pages, :total_objects)
        .reverse_merge(
            page: 1,
            per_page: 10
        )
    end

    def pagination(paginated_array, paginatable_params)
        {
            page: paginatable_params[:page].to_i,
            per_page: paginatable_params[:per_page].to_i,
            total_pages: paginated_array.total_pages,
            total_objects: paginated_array.total_count
        }
    end

end
