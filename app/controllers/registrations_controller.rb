def sign_up_params
  params.require(:user).permit(:email, :password, :password_confirmation)
end
