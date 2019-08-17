class MembersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.user = current_user

    if @member.save
      redirect_to member_path(@member), notice: "Member created"
    else
      flash.now[:alert] = "Unable to save member"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def member_params
    params.require(:member).permit(:first_name)
  end
end
