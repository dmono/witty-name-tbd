require 'digest/sha1'
require_relative 'defaults'

module Binary
  def self.xor_distance(id_string1, id_string2)
    id_string1.to_i ^ id_string2.to_i
  end

  def self.shared_prefix_bit_length(id_string1, id_string2)
    return Defaults::ENVIRONMENT[:bit_length] if id_string1 == id_string2
    distance = xor_distance(id_string1, id_string2)
    Defaults::ENVIRONMENT[:bit_length] - distance.to_s(2).size
  end

  def self.sha(str)
    Digest::SHA1.hexdigest(str)
  end

  def self.shared_prefix_bit_length_map(source_node_id, array)
    array.map do |item|
      shared_prefix_bit_length(source_node_id, item.id)
    end
  end

  def self.select_closest_xor(id, array)
    xors = array.map do |el|
      el.id.to_i ^ id.to_i
    end
    idx = xors.index(xors.min)
    idx ? array[idx] : nil
  end

  def self.xor_distance_map(id, array)
    array.map { |obj| xor_distance(id, obj.id) }
  end

  def self.sort_by_xor!(id, array)
    array.sort! do |x, y|
      xor_distance(x.id, id) <=> xor_distance(y.id, id)
    end
  end
end
