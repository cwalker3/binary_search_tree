# frozen_string_literal: true

require_relative 'node'

# binary search tree class
class Tree
  def initialize(array)
    @root = build_tree(array.sort.uniq)
  end

  def build_tree(array, parent = nil, mid = array.length / 2)
    return nil if array.empty?
    return Node.new(array[0], parent) if array.length == 1

    root = Node.new(array[mid], parent)
    root.left = build_tree(array[0..mid - 1], root)
    root.right = build_tree(array[mid + 1..], root)
    root
  end

  def find(value, node = @root)
    node = node.path(value) until node.nil? || node.data == value
    node
  end

  def insert(value, node = @root)
    return if find(value)

    node = node.path(value) until node.space_for?(value)
    node.add_child(value)
  end

  def delete(value, node = find(value))
    return if node.nil?

    case node.children_count
    when 0
      node.delete_childless
    when 1
      node.delete_with_child
    when 2
      node.delete_with_children
    end
  end

  def level_order(node = @root, array = [node], result = [])
    array.each do |node|
      node.children.each { |child| array << child }
      result << node.data unless block_given?
      result << yield(node) if block_given?
    end
    result
  end

  def inorder(root = @root, array = [], &block)
    block ||= ->(node) { array << node.data }
    inorder(root.left, array, &block) unless root.left.nil?
    block.call(root)
    inorder(root.right, array, &block) unless root.right.nil?
    array.empty? ? nil : array
  end

  def preorder(root = @root, array = [], &block)
    block ||= ->(node) { array << node.data }
    block.call(root)
    preorder(root.left, array, &block) unless root.left.nil?
    preorder(root.right, array, &block) unless root.right.nil?
    array.empty? ? nil : array
  end

  def postorder(root = @root, array = [], &block)
    block ||= ->(node) { array << node.data }
    postorder(root.left, array, &block) unless root.left.nil?
    postorder(root.right, array, &block) unless root.right.nil?
    block.call(root)
    array.empty? ? nil : array
  end

  def height(root)
    max_depth = 0
    level_order(root) { |node| max_depth = depth(node, root) if depth(node, root) > max_depth }
    max_depth
  end

  def depth(node, root = @root)
    edges = 0
    until node == root
      edges += 1
      node = node.parent
    end
    edges
  end

  def balanced?
    (height(@root.left) - height(@root.right)).abs <= 1
  end

  def rebalance
    @root = build_tree(inorder)
  end
end
