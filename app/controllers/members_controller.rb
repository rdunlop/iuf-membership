# frozen_string_literal: true

# Manage the creation/payment of a member
class MembersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize(Member)
    @members = current_user.members
    redirect_to new_member_path if @members.none
  end

  def new
    @member = Member.new
    authorize(@member)
  end

  def create
    @member = Member.new(member_params)
    authorize(@member)
    @member.user = current_user

    if @member.save
      redirect_to member_path(@member), notice: 'Member created'
    else
      flash.now[:alert] = 'Unable to save member'
      render :new
    end
  end

  def show
    @member = Member.find(params[:id])
    authorize(@member)
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])

    if @member.update(member_params)
      redirect_to member_path(@member), notice: 'Member updated'
    else
      flash.now[:alert] = 'Unable to save member'
      render :edit
    end
  end

  def destroy
    @member = Member.find(params[:id])
    if @member.destroy
      redirect_to members_path, notice: 'Member deleted'
    else
      redirect_to members_path, alert: 'Unable to delete member'
    end
  end

  private

  def member_params
    params.require(:member).permit(
      :first_name,
      :alternate_first_name,
      :last_name,
      :alternate_last_name,
      :birthdate,
      :contact_email
    )
  end
end
