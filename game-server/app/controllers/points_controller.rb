class PointsController < ApplicationController
    # Class Variables
    @@initial_click = true
    @@initial_line = true
    @@first_click = true
    @@start_x_coord = nil
    @@start_y_coord = nil
    @@end_x_coord = nil
    @@end_y_coord = nil
    @@clicked_nodes = []
    @@first_end_point = nil
    @@sec_end_point = nil

  def reset_variables
    @@initial_click = true
    @@initial_line = true
    @@first_click = true
    @@start_x_coord = nil
    @@start_y_coord = nil
    @@end_x_coord = nil
    @@end_y_coord = nil
    @@clicked_nodes = []
    @@first_end_point = nil
    @@sec_end_point = nil
  end

  def init
    # Initial response to client when game loads
    @payload = {
      "msg": "INITIALIZE", 
      "body": {
        "newLine": nil,
        "heading": "Player 1", 
        "message": "Awaiting Player 1's Move"
      }
    }
    reset_variables
    render json: @payload
  end

  def save_first_click
    # Save the x,y coordinates of the first node click for use during the second node click
    @@start_x_coord = params[:x]
    @@start_y_coord = params[:y]
    resp = {
      "msg": "VALID_START_NODE",
      "body": {
      "newLine": nil,
      "heading": "Player 2",
      "message": "Select a second node to complete the line."
      }
    }
    #Save all coordinates into a class variable to reference later what nodes have been clicked already
    @@clicked_nodes << [params[:x], params[:y]]
    @@first_click = !@@first_click
    render json: resp 
  end

  def save_sec_click
    # Save coordinates of the second node click and construct response using coordinates of the first node and second node clicks
    @@end_x_coord = params[:x]
    @@end_y_coord = params[:y]
    resp = {
      "msg": "VALID_END_NODE",
        "body": {
          "newLine": {
            "start": {
              "x": @@start_x_coord,
              "y": @@start_y_coord
            },
            "end": {
              "x": @@end_x_coord,
              "y": @@end_y_coord
            }
          },
          "heading": "Player 1",
          "message": nil
        }
    }
    #Save coordinates of second node click into coordinates bank
    @@clicked_nodes << [params[:x], params[:y]]
    @@first_click = !@@first_click
    render json: resp
  end

  # def check_clicked_nodes
  #   node_not_exist = true
  #   @@clicked_nodes.each do |coord|
  #     if coord[0] == params[:x] && coord[1] == params[:y]
  #       node_not_exist = false
  #     end
  #   end
  #   node_not_exist
  # end

  def check_end_point
    # Check whether the coordinates of the node currently clicked matches with the coordinates of one of the end points
    # if yes then this method returns true
    is_end_point = false
    if @@first_end_point[0] == params[:x] && @@first_end_point[1] == params[:y]
      is_end_point = true
    elsif @@sec_end_point[0] == params[:x] && @@sec_end_point[1] == params[:y]
      is_end_point = true
    end
    is_end_point
  end

  def save_new_end_point
    # Every time a line is drawn save the x,y coordinates of the ending node as a new end point
    # The end point to be replaced is the one where the beginning x,y coordinates of the new line matches the coordinates
    # of one of the current end points
    if @@first_end_point[0] == @@start_x_coord && @@first_end_point[1] == @@start_y_coord
      @@first_end_point = [@@end_x_coord, @@end_y_coord]
    elsif @@sec_end_point[0] == @@start_x_coord && @@sec_end_point[1] == @@start_y_coord
      @@sec_end_point = [@@end_x_coord, @@end_y_coord]
    end
  end

  def node_clicked
    if @@initial_click && @@first_click
      # Specifically check if this is the first move of the game because the first node can be anywhere
      save_first_click
      @@initial_click = false
    elsif @@initial_line && !@@first_click
      # Specifically check if this is the second move of the game i.e the first line being drawn
      # Save the end points of the first line as end point currently has nothing to compare with for update
      save_sec_click
      @@first_end_point = [@@start_x_coord, @@start_y_coord]
      @@sec_end_point = [@@end_x_coord, @@end_y_coord]
      @@first_line = false
    elsif @@first_click && check_end_point
      # This is for all other moves of the game
      # If this is the first node of a new line and the node being clicked is an end point then call method
      save_first_click
    elsif @@first_click && !check_end_point
      # If this is the first node click of a new line and it is not an end point then throw error resposne
      resp = {
        "msg": "INVALID_START_NODE",
        "body": {
          "newLine": nil,
          "heading": "Player 2",
          "message": "Not a valid starting position."
        }
      }
      render json: resp
    elsif !@@first_click && check_end_point
      # Check if this is a valid second node click
      save_sec_click
      save_new_end_point
    elsif !@@first_click && !check_end_point
      resp = {
        "msg": "INVALID_END_NODE",
        "body": {
          "newLine": nil,
          "heading": "Player 2",
          "message": "Invalid move!"
        }
      }
      render json: resp
    end #end of conditional
  end #end of method

end #end of class
