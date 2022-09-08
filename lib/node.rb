# frozen_string_literal: true

# node class for binary search tree
class Node
  attr_accessor :left, :right, :data, :parent

  def initialize(data, parent = nil, left = nil, right = nil)
    @data = data
    @parent = parent
    @left = left
    @right = right
  end

  def children(array = [])
    array << left unless left.nil?
    array << right unless right.nil?
    array
  end

  def children_count
    children.length
  end

  def path(value)
    if value > data
      @right
    else
      @left
    end
  end

  def space_for?(value)
    true if path(value).nil?
  end

  def add_child(value)
    return unless space_for?(value)

    @left = Node.new(value, self) if data > value
    @right = Node.new(value, self) if data < value
  end

  def delete_childless
    if data > parent.data
      parent.right = nil
    else
      parent.left = nil
    end
  end

  def delete_with_child
    child = @left ? left : right
    if data > parent.data
      parent.right = child
    else
      parent.left = child
    end
  end

  def delete_with_children
    replacement = right
    replacement = replacement.left until replacement.left.nil?
    replacement.left = left
    if data > parent.data
      parent.right = replacement

    else
      parent.left = replacement
    end
  end
end
