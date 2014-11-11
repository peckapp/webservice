# used for eumerating combination of hash parameters
# a modified version of the code from: http://www.cordinc.com/blog/2009/04/combinatorial-iterators-in-jav.html
class CombinatorialIterator
  def initialize(number, hash)
    raise "|hash| >= number && number > 1" if (hash.nil? or number < 1 or hash.keys.count < number)
    @number = number
    @elements = hash.to_a
  end

  def mapCombinations(&block)
    combinations(@number, @elements, [], block.to_proc)
  end

  private

  def combinations(len, items, prefix, block)
    if (len == 1)
      items.each {|x| block.call((prefix.dup << x).to_h) }
    else
      # use slice because no drop in Ruby 1.8.6
      0.upto(items.length - len) do |i|
        combinations(len-1, items.slice(i+1, items.length-i) , prefix.dup << items[i], block)
      end
    end
  end # end combinations method
end # end class
